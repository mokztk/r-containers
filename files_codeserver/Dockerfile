# rocker/r-ver に code-server を追加する

ARG BUILDKIT_INLINE_CACHE=1
ARG TARGETPLATFORM

FROM --platform=$TARGETPLATFORM rocker/r-ver:4.5.3

ARG TARGETARCH
ENV DEBIAN_FRONTEND=noninteractive

# 各種ツールのバージョン指定
ARG CODESERVER_VERSION="4.117.0"
ARG PANDOC_VERSION="3.9.0.2"
ARG QUARTO_VERSION="1.9.36"
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
        zstd \
        ca-certificates \
        git \
        language-pack-ja-base \
    && /usr/sbin/update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja" \
    && /bin/bash -c "source /etc/default/locale" \
    && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /etc/R

# coder user (passwordless sudo)
RUN useradd -m -s /bin/bash coder \
 && echo "coder ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/coder \
 && chmod 0440 /etc/sudoers.d/coder

# code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --version ${CODESERVER_VERSION}

# Quarto CLI
# rocker/rstudio:4.5.3 と同じバージョンをrocker公式のインストールスクリプトで導入
# wget, ca-certicifates は導入済みのため apt の処理はスキップ（行番号は @2b91d04 準拠）
RUN --mount=type=cache,id=apt-cache-${TARGETARCH},target=/var/cache/apt \
    sed -e "16,26d" -e "85d" /rocker_scripts/install_pandoc.sh | bash \
    && sed -e "21,31d" /rocker_scripts/install_quarto.sh | bash

# uv (Python manager) & radian
COPY --from=ghcr.io/astral-sh/uv:0.11.8 /uv /uvx /opt/uv/bin/

ENV UV_PYTHON_INSTALL_DIR=/opt/uv/python \
    PATH=/opt/venv/bin:/opt/uv/bin:$PATH

RUN /opt/uv/bin/uv venv --python ${PYTHON_VERSION} /opt/venv \
    && uv pip install radian==${RADIAN_VERSION} \
    && chown -R coder:coder /opt/venv

# Node.js / npm / pnpm
# n 公式の npm 不要のインストールスクリプトで Active LTS の v24.15.0 をインストール
# n 自身も改めて入れておく
RUN wget -qO- https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s install ${NODE_VERSION} \
    && npm install -g n@${N_VERSION} npm@${NPM_VERSION} pnpm@${PNPM_VERSION}

# Microsoft Edit
RUN mkdir -p /opt/msedit/ \
    && wget -O /opt/msedit/msedit.tar.zst \
        https://github.com/microsoft/edit/releases/download/v1.2.0/edit-1.2.0-`uname -m`-linux-gnu.tar.zst \
    && cd /opt/msedit \
    && tar -Izstd -xvf msedit.tar.zst \
    && mkdir -p /home/coder/.local/bin \
    && chown -R coder:coder /home/coder/.local/ \ 
    && ln -s /opt/msedit/edit /home/coder/.local/bin/msedit \
    && rm msedit.tar.zst

# mokztk/RStudio_docker から流用した setup script
# 各スクリプトは改行コード LF(UNIX) でないとエラーになる
COPY --chmod=755 my_scripts /my_scripts

# R の site library を一般ユーザー coder でも書き込みできる場所に移す
ENV R_LIBS_SITE=/opt/R/packages/4.5
ENV R_LIBS=${R_LIBS_SITE}:/usr/local/lib/R/library

RUN --mount=type=cache,id=apt-cache-${TARGETARCH},target=/var/cache/apt \
    mkdir -p $R_LIBS_SITE \
    && cp -r /usr/local/lib/R/site-library/* $R_LIBS_SITE/ \
    && bash /my_scripts/install_r_packages_pak.sh \
    && chown -R coder:coder $R_LIBS_SITE \
    && bash /my_scripts/install_notojp.sh

# ユーザー設定
USER coder
RUN bash /my_scripts/user_settings.sh

WORKDIR /workspace

EXPOSE 8080 8088

ENV TZ=Asia/Tokyo \
    LANG=ja_JP.UTF-8 \
    LC_ALL=ja_JP.UTF-8

CMD ["code-server", "--auth", "none", "--bind-addr", "0.0.0.0:8080", "/workspace"]
