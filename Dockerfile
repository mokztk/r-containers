# rocker/r-ver をベースに共通部分を作ってから各UIを追加したイメージを作成する

# 共通部分

ARG BUILDKIT_INLINE_CACHE=1
ARG TARGETPLATFORM

FROM --platform=$TARGETPLATFORM rocker/r-ver:4.5.3 AS base_stacks

ARG TARGETARCH
ENV DEBIAN_FRONTEND=noninteractive

# 各種ツールのバージョン指定
ENV PANDOC_VERSION="3.9.0.2"
ENV QUARTO_VERSION="1.9.36"

ARG PYTHON_VERSION="3.12.13"
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
        git \
    && /usr/sbin/update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja" \
    && /bin/bash -c "source /etc/default/locale" \
    && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /etc/R \

# 一般ユーザーを作成。パスワード無しで sudo 可能にする
ENV DEFAULT_USER="ruser"
RUN /rocker_scripts/default_user.sh "${DEFAULT_USER}" \
    && echo "${DEFAULT_USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${DEFAULT_USER} \
    && chmod 0440 /etc/sudoers.d/${DEFAULT_USER}

# pandoc & quarto
# wget, ca-certicifates は導入済みのため apt の処理はスキップ（行番号は @2b91d04 準拠）
RUN --mount=type=cache,id=apt-cache-${TARGETARCH},target=/var/cache/apt \
    sed -e "16,26d" -e "85d" /rocker_scripts/install_pandoc.sh | bash \
    && sed -e "21,31d" /rocker_scripts/install_quarto.sh | bash

# uv (Python manager) & radian
COPY --from=ghcr.io/astral-sh/uv:0.11.9 /uv /uvx /opt/uv/bin/

ENV UV_PYTHON_INSTALL_DIR=/opt/uv/python
ENV UV_CACHE_DIR=/opt/uv/cache
ENV PATH=/opt/venv/bin:/opt/uv/bin:$PATH
ENV RETICULATE_PYTHON_ENV="/opt/venv"

RUN /opt/uv/bin/uv venv --python ${PYTHON_VERSION} /opt/venv \
    && uv pip install radian==${RADIAN_VERSION} \
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
    && tar -Izstd -xzf msedit.tar.gz \
    && mkdir -p /home/${DEFAULT_USER}/.local/bin \
    && chown -R ${DEFAULT_USER}:${DEFAULT_USER} /home/coder/.local/ \ 
    && ln -s /opt/msedit/edit /home/${DEFAULT_USER}/.local/bin/msedit \
    && rm msedit.tar.gz

# mokztk/RStudio_docker から流用した setup script
# 各スクリプトは改行コード LF(UNIX) でないとエラーになる
COPY --chmod=755 my_scripts /my_scripts

# R の site library を一般ユーザー coder でも書き込みできる場所に移す
ENV R_LIBS_SITE=/opt/R/packages/4.5
ENV R_LIBS=${R_LIBS_SITE}:/usr/local/lib/R/library

RUN --mount=type=cache,id=apt-cache-${TARGETARCH},target=/var/cache/apt \
    mkdir -p ${R_LIBS_SITE} \
    && cp -r /usr/local/lib/R/site-library/* ${R_LIBS_SITE}/ \
    && bash /my_scripts/install_r_packages_pak.sh \
    && chown -R ${DEFAULT_USER}:${DEFAULT_USER} ${R_LIBS_SITE} \
    && bash /my_scripts/install_notojp.sh

# 検証用ファイル
COPY --chown=rstudio:rstudio utils /home/rstudio/utils

ENV LANG=ja_JP.UTF-8
ENV LC_ALL=ja_JP.UTF-8
ENV TZ=Asia/Tokyo

CMD ["R"]


# 共通部分をベースにRStudio server等を追加する

FROM base_stacks AS rstudio

# rocker/rstudio:4.5.3 に合わせる
ENV S6_VERSION="v2.1.0.2"
ENV RSTUDIO_VERSION="2026.04.0+526"

RUN --mount=type=cache,id=apt-cache-${TARGETARCH},target=/var/cache/apt \
    apt-get update \
    && bash /rocker_scripts/install_rstudio.sh

RUN /my_scripts/install_coding_fonts.sh

WORKDIR /workspace
RUN echo "session-default-working-dir=/workspace" >> /etc/rstudio/rsession.conf

ENV PASSWORD=password
ENV DISABLE_AUTH=true
ENV RUNROOTLESS=false

EXPOSE 8787
CMD ["/init"]


# 共通部分をベースに、SSH server を追加する

FROM base_stacks AS ssh

RUN /my_scripts/setup_sshd.sh

WORKDIR /workspace

# SSH server を起動
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]


# 共通部分をベースに、code-server を追加する

FROM base_stacks AS codeserver

ENV CODESERVER_VERSION="4.117.0"

# code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --version ${CODESERVER_VERSION}

# ユーザー設定
USER coder
RUN bash /my_scripts/user_settings.sh

WORKDIR /workspace

EXPOSE 8080 8088

CMD ["code-server", "--auth", "none", "--bind-addr", "0.0.0.0:8080", "/workspace"]

