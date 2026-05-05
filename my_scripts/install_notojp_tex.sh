#!/bin/bash

# Noto Sans/Serif JP フォントのインストール
# apt で fonts-noto-cjk + fonts-noto-cjk-extra を入れると300MB超となるため最低限のものを手動で導入する

# Google Fonts で配布されている日本語フォントは現在、"CJK" なしの Noto Sans/Serif JP
# Github notofonts/noto-cjk から日本語サブセット版（SubsetOTF）個別にダウンロードする
# zxjafont.sty のプリセット名は "noto" ではなく、"noto-jp" を使う
# noto-jp で必要な7フォント＋Noto Sans Mono CJK JP のうち、未インストールのものを入れて更新する

set -x

mkdir /usr/share/fonts/notojp
cd /usr/share/fonts/notojp
wget -q -O NotoSerifJP-Light.otf https://github.com/notofonts/noto-cjk/raw/main/Serif/SubsetOTF/JP/NotoSerifJP-Light.otf
wget -q -O NotoSansJP-Black.otf https://github.com/notofonts/noto-cjk/raw/main/Sans/SubsetOTF/JP/NotoSansJP-Black.otf
wget -q -O NotoSansJP-Medium.otf https://github.com/notofonts/noto-cjk/raw/main/Sans/SubsetOTF/JP/NotoSansJP-Medium.otf

chmod 644 /usr/share/fonts/notojp/*
fc-cache -fv
