# rocker/r-ver をベースに共通部分を作ってから各UIを追加したイメージを作成する

# 共通部分

ARG BUILDKIT_INLINE_CACHE=1
ARG TARGETPLATFORM

FROM --platform=$TARGETPLATFORM rocker/r-ver:4.5.3 AS base_stacks

LABEL org.opencontainers.image.source = "https://github.com/mokztk/r-containers"

ARG TARGETARCH
ENV DEBIAN_FRONTEND=noninteractive

# 各種ツールのバージョン指定
ENV PANDOC_VERSION="3.9.0.2"
ENV QUARTO_VERSION="1.9.36"

ARG PYTHON_VERSION="3.12.13"
ARG NUMPY_VERSION="1.26"
ARG PANDAS_VERSION="3.0.1"
ARG RADIAN_VERSION="0.6.15"
ARG NODE_VERSION="24.15.0"
ARG N_VERSION="10.2.0"
ARG NPM_VERSION="11.13.0"
ARG PNPM_VERSION="10.33.2"

# 日本語設定と必要なライブラリ（Rパッケージ用は別途スクリプト内で導入）
# 以降も何度か apt-get を使うので BuildKit のキャッシュマウント機能を使う
RUN --mount=type=cache,id=apt-cache-${TARGETARCH},target=/var/cache/apt \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        sudo \
        curl \
        wget \
        ca-certificates \
        git \
        language-pack-ja-base \
        ssh \
    && /usr/sbin/update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja" \
    && /bin/bash -c "source /etc/default/locale" \
    && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /etc/R

# 一般ユーザーを作成。パスワード無しで sudo 可能にする
ENV DEFAULT_USER="ruser"
RUN /rocker_scripts/default_user.sh "${DEFAULT_USER}" \
    && mkdir -p /etc/sudoers.d \
    && echo "${DEFAULT_USER} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${DEFAULT_USER}" \
    && chmod 0440 "/etc/sudoers.d/${DEFAULT_USER}"

# pandoc & quarto
# wget, ca-certicifates は導入済みのため apt の処理はスキップ（行番号は @2b91d04 準拠）
RUN --mount=type=cache,id=apt-cache-${TARGETARCH},target=/var/cache/apt \
    sed -e "16,26d" -e "85d" /rocker_scripts/install_pandoc.sh | bash \
    && sed -e "21,31d" /rocker_scripts/install_quarto.sh | bash

# uv (Python manager) & Python environment
COPY --from=ghcr.io/astral-sh/uv:0.11.9 /uv /uvx /opt/uv/bin/

ENV UV_PYTHON_INSTALL_DIR=/opt/uv/python
ENV PATH=/opt/venv/bin:/opt/uv/bin:$PATH
ENV RETICULATE_PYTHON_ENV="/opt/venv"

RUN /opt/uv/bin/uv venv --python ${PYTHON_VERSION} /opt/venv \
    && uv pip install numpy==${NUMPY_VERSION} pandas==${PANDAS_VERSION} radian==${RADIAN_VERSION} \
    && uv cache clean \
    && chown -R ${DEFAULT_USER}:${DEFAULT_USER} /opt/venv

# Node.js / npm / pnpm
# n 公式の npm 不要のインストールスクリプトで Active LTS の v24.15.0 をインストール
# n 自身も改めて入れておく
RUN wget -qO- https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s install ${NODE_VERSION} \
    && npm install -g n@${N_VERSION} npm@${NPM_VERSION} pnpm@${PNPM_VERSION}

# Microsoft Edit
RUN mkdir -p /opt/msedit/ \
    && wget -O /opt/msedit/msedit.tar.gz \
        https://github.com/microsoft/edit/releases/download/v2.0.0/edit-2.0.0-`uname -m`-linux-gnu.tar.gz \
    && cd /opt/msedit \
    && tar -xzf msedit.tar.gz \
    && mkdir -p /home/${DEFAULT_USER}/.local/bin \
    && chown -R ${DEFAULT_USER}:${DEFAULT_USER} /home/${DEFAULT_USER}/.local/ \ 
    && ln -s /opt/msedit/edit /home/${DEFAULT_USER}/.local/bin/msedit \
    && rm msedit.tar.gz

# R の site library を一般ユーザー coder でも書き込みできる場所に移す
ENV R_LIBS_SITE=/opt/R/packages/4.5
ENV R_LIBS=${R_LIBS_SITE}:/usr/local/lib/R/library

COPY --chmod=755 my_scripts/install_r_packages_pak.sh my_scripts/install_notojp.sh /my_scripts/
RUN --mount=type=cache,id=apt-cache-${TARGETARCH},target=/var/cache/apt \
    mkdir -p ${R_LIBS_SITE} \
    && cp -r /usr/local/lib/R/site-library/* ${R_LIBS_SITE}/ \
    && bash /my_scripts/install_r_packages_pak.sh \
    && chown -R ${DEFAULT_USER}:${DEFAULT_USER} ${R_LIBS_SITE} \
    && bash /my_scripts/install_notojp.sh

# 検証用ファイル
COPY --chown=${DEFAULT_USER}:${DEFAULT_USER} utils /home/${DEFAULT_USER}/utils

# その他の setup script
# 各スクリプトは改行コード LF(UNIX) でないとエラーになる
COPY --chmod=755 my_scripts /my_scripts

ENV LANG=ja_JP.UTF-8
ENV LC_ALL=ja_JP.UTF-8
ENV TZ=Asia/Tokyo

# 環境変数のエクスポート
# 1. R用設定 (Renviron.site)
RUN echo "R_LIBS_SITE=${R_LIBS_SITE}" >> /usr/local/lib/R/etc/Renviron.site && \
    echo "R_LIBS=${R_LIBS}" >> /usr/local/lib/R/etc/Renviron.site && \
    echo 'PATH=/opt/venv/bin:/opt/uv/bin:${PATH}' >> /usr/local/lib/R/etc/Renviron.site && \
    echo "RETICULATE_PYTHON_ENV=\"${RETICULATE_PYTHON_ENV}\"" >> /usr/local/lib/R/etc/Renviron.site && \
    echo "LANG=${LANG}" >> /usr/local/lib/R/etc/Renviron.site && \
    echo "LC_ALL=${LC_ALL}" >> /usr/local/lib/R/etc/Renviron.site && \
    echo "TZ=${TZ}" >> /usr/local/lib/R/etc/Renviron.site

# 2. シェル・SSH用設定 (/etc/profile.d/)
RUN echo "export PATH=\"${PATH}\"" > /etc/profile.d/r_containers_env.sh && \
    echo "export UV_PYTHON_INSTALL_DIR=\"${UV_PYTHON_INSTALL_DIR}\"" >> /etc/profile.d/r_containers_env.sh && \
    echo "export LANG=\"${LANG}\"" >> /etc/profile.d/r_containers_env.sh && \
    echo "export LC_ALL=\"${LC_ALL}\"" >> /etc/profile.d/r_containers_env.sh && \
    echo "export TZ=\"${TZ}\"" >> /etc/profile.d/r_containers_env.sh && \
    echo "export R_LIBS_SITE=\"${R_LIBS_SITE}\"" >> /etc/profile.d/r_containers_env.sh && \
    echo "export R_LIBS=\"${R_LIBS}\"" >> /etc/profile.d/r_containers_env.sh

CMD ["R"]


# 共通部分をベースにRStudio server等を追加する

FROM base_stacks AS rstudio

LABEL org.opencontainers.image.source = "https://github.com/mokztk/r-containers"

# rocker/rstudio:4.5.3 に合わせる
ENV S6_VERSION="v2.1.0.2"
ENV RSTUDIO_VERSION="2026.04.0+526"

RUN --mount=type=cache,id=apt-cache-${TARGETARCH},target=/var/cache/apt \
    apt-get update \
    && bash /rocker_scripts/install_rstudio.sh

RUN /my_scripts/install_coding_fonts.sh

RUN mkdir /workspace \
    && chmod 777 /workspace \
    && echo "session-default-working-dir=/workspace" >> /etc/rstudio/rsession.conf

WORKDIR /workspace

ENV PASSWORD=password
ENV DISABLE_AUTH=true
ENV RUNROOTLESS=false

EXPOSE 8787
CMD ["/init"]


# 共通部分をベースに、SSH server を追加する

FROM base_stacks AS ssh

LABEL org.opencontainers.image.source = "https://github.com/mokztk/r-containers"

RUN /my_scripts/setup_sshd.sh

WORKDIR /workspace

# SSH server を起動
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]


# 共通部分をベースに、code-server を追加する

FROM base_stacks AS codeserver

LABEL org.opencontainers.image.source = "https://github.com/mokztk/r-containers"

ENV CODESERVER_VERSION="4.117.0"

# code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --version ${CODESERVER_VERSION}

# ユーザー設定
USER ${DEFAULT_USER}
RUN bash /my_scripts/user_settings.sh

WORKDIR /workspace

EXPOSE 8080 8088

CMD ["code-server", "--auth", "none", "--bind-addr", "0.0.0.0:8080", "/workspace"]

