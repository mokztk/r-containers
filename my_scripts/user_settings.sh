#!/bin/bash

# 各アプリのユーザー設定

#-------------------------------
#  code-server
#-------------------------------

# VS Code plugins
code-server --install-extension REditorSupport.r
code-server --install-extension RDebugger.r-debugger
code-server --install-extension quarto.quarto
code-server --install-extension christian-kohler.path-intellisense
code-server --install-extension mechatroner.rainbow-csv
code-server --install-extension grapecity.gc-excelviewer
code-server --install-extension usernamehw.errorlens
code-server --install-extension chouzz.vscode-better-align

# 設定ファイルを docker run -v でマウントするための空ファイル
# 所有者を ${DEFAULT_USER} にして準備しておかないと root になってしまい変更が書き込めない
mkdir -p ~/.config/code-server
touch ~/.local/share/code-server/User/settings.json

# Rのグラフィックデバイスとして httpgd::hgd() を使う設定
# settings.json で "r.plot.useHttpgd": true が必要

cat << EOF >> /home/${DEFAULT_USER}/.Rprofile

# use httpgd::hgd() for preview R plots
options(
  device = "httpgd",
  httpgd.host = "0.0.0.0",
  httpgd.port = 8088,
  httpgd.token = ""
)

EOF

# RStudio に合わせたキーボードショートカット
cat << EOF > ~/.local/share/code-server/User/keybindings.json
[
    {
        "key": "ctrl+shift+m",
        "command": "type",
        "args": {
          "text": " |> "
        },
        "when": "editorTextFocus && editorLangId == 'r'"
    },
    {
        "key": "ctrl+shift+m",
        "command": "type",
        "args": {
          "text": " |> "
        },
        "when": "editorTextFocus && editorLangId == 'rmd'"
    },
    {
        "key": "ctrl+shift+m",
        "command": "type",
        "args": {
          "text": " |> "
        },
        "when": "editorTextFocus && editorLangId == 'quarto'"
    },
    {
        "key": "ctrl+shift+c",
        "command": "editor.action.commentLine",
        "when": "editorTextFocus && !editorReadonly"
    },
    {
        "key": "ctrl+/",
        "command": "-editor.action.commentLine",
        "when": "editorTextFocus && !editorReadonly"
    }
]
EOF

#-------------------------------
#  uv
#-------------------------------

# 安全のため、リリース後1週間以上経ったパッケージのみインストールできるようにする

mkdir -p ~/.config/uv
echo 'exclude-newer = "1 week"' >> ~/.config/uv/uv.toml
