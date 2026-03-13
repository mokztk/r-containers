#!/usr/bin/bash

# Node.js / npm / pnpm のセットアップ

# n 公式の npm 不要のインストールスクリプトで Active LTS （2026-03 現在は v24系）をインストール
# n 自身も改めて入れておく
wget -qO- https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s install lts_active
npm install -g n

# pnpm をインストール
npm install -g pnpm

# ユーザー rstudio 用に pnpm を設定
# 安全のため、リリース後1週間以上経ったパッケージのみインストールできるようにする
su rstudio <<-EOF
pnpm setup
pnpm config set --location=global minimumReleaseAge 10080
EOF
