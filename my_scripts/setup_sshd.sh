#!/bin/bash

mkdir /var/run/sshd

# 公開鍵を置くディレクトリをユーザー $DEFAULT_USER で作っておく
mkdir /home/${DEFAULT_USER}/.ssh/
chown -R ${DEFAULT_USER}:${DEFAULT_USER} /home/${DEFAULT_USER}/.ssh/

# 作業用ディレクトリ
mkdir /workspace
chmod 777 /workspace
