#!/bin/bash

mkdir /var/run/sshd

# 公開鍵を置くディレクトリをユーザー $DEFAULT_USER で作っておく
mkdir /home/${DEFAULT_USER}/.ssh/
chown -R ${DEFAULT_USER}:${DEFAULT_USER} /home/${DEFAULT_USER}/.ssh/

# 作業用ディレクトリ
mkdir /workspace
chmod 777 /workspace

# Rセッションに環境変数を引き継ぐ
cat << 'EOF' > /home/${DEFAULT_USER}/.Renviron
R_LIBS_SITE=/opt/R/packages/4.5
R_LIBS=${R_LIBS_SITE}:/usr/local/lib/R/library
UV_PYTHON_INSTALL_DIR=/opt/uv/python
PATH=/opt/venv/bin:/opt/uv/bin:${PATH}
RETICULATE_PYTHON_ENV="/opt/venv"
LANG=ja_JP.UTF-8
LC_ALL=ja_JP.UTF-8
TZ=Asia/Tokyo
EOF
chown ${DEFAULT_USER}:${DEFAULT_USER} /home/${DEFAULT_USER}/.Renviron

# Python仮想環境 venv を有効化
echo "source /opt/venv/bin/activate" >> /home/${DEFAULT_USER}/.bashrc
