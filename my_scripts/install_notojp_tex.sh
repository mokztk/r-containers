#!/bin/bash

# Noto Sans/Serif JP フォントのインストール
# apt で fonts-noto-cjk + fonts-noto-cjk-extra を入れると300MB超となるため最低限のものを手動で導入する

# Google Fonts で配布されている日本語フォントは現在、"CJK" なしの Noto Sans/Serif JP
# Github notofonts/noto-cjk から日本語サブセット版（SubsetOTF）個別にダウンロードする
# zxjafont.sty のプリセット名は "noto" ではなく、"noto-jp" を使う
# noto-jp で必要な7フォント＋Noto Sans Mono CJK JP

set -x

mkdir /usr/share/fonts/notojp
cd /usr/share/fonts/notojp
wget -q -O NotoSerifJP-Light.otf https://github.com/notofonts/noto-cjk/raw/main/Serif/SubsetOTF/JP/NotoSerifJP-Light.otf
wget -q -O NotoSerifJP-Regular.otf https://github.com/notofonts/noto-cjk/raw/main/Serif/SubsetOTF/JP/NotoSerifJP-Regular.otf
wget -q -O NotoSerifJP-Bold.otf https://github.com/notofonts/noto-cjk/raw/main/Serif/SubsetOTF/JP/NotoSerifJP-Bold.otf
wget -q -O NotoSansJP-Regular.otf https://github.com/notofonts/noto-cjk/raw/main/Sans/SubsetOTF/JP/NotoSansJP-Regular.otf
wget -q -O NotoSansJP-Bold.otf https://github.com/notofonts/noto-cjk/raw/main/Sans/SubsetOTF/JP/NotoSansJP-Bold.otf
wget -q -O NotoSansJP-Black.otf https://github.com/notofonts/noto-cjk/raw/main/Sans/SubsetOTF/JP/NotoSansJP-Black.otf
wget -q -O NotoSansJP-Medium.otf https://github.com/notofonts/noto-cjk/raw/main/Sans/SubsetOTF/JP/NotoSansJP-Medium.otf
wget -q -O NotoSansMonoCJKjp-Regular.otf https://github.com/notofonts/noto-cjk/raw/main/Sans/Mono/NotoSansMonoCJKjp-Regular.otf

chmod 644 /usr/share/fonts/notojp/*
fc-cache -fv

# 標準フォントとして手動で入れた Noto fonts を認識できるようにする
# Noto Sans/Serif CJK JP を Noto Sans/Serif JP の別名として登録しておく（過去のコードの文字化け回避）
# 設定しておけば、最低限グラフの文字化けはなくなる

mkdir -p /home/rstudio/.config/fontconfig
cp /my_scripts/fonts.conf /home/rstudio/.config/fontconfig/
chown -R rstudio:rstudio /home/rstudio/.config
