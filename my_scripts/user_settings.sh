#!/bin/bash

# 各アプリのユーザー設定

#-------------------------------
#  code-server
#-------------------------------

# VS Code 拡張機能
# 動作を確認したバージョンに固定し、拡張機能の自動更新は止めておく
code-server --install-extension REditorSupport.r@3.2.0
code-server --install-extension RDebugger.r-debugger@0.5.6
code-server --install-extension quarto.quarto@1.139.0
code-server --install-extension christian-kohler.path-intellisense@2.8.0
code-server --install-extension mechatroner.rainbow-csv@3.24.1
code-server --install-extension cweijan.vscode-office@4.2.3
code-server --install-extension usernamehw.errorlens@3.30.0
code-server --install-extension chouzz.vscode-better-align@1.4.5

# REditorSupport.r に同梱されている {sess} をインストール
SESS_DIR=$(find /home/ruser -path "*/reditorsupport.r*/*/sess" 2>/dev/null | head -n 1)
if [ -n "$SESS_DIR" ]; then
    R CMD INSTALL "$SESS_DIR";
fi

# arfとhttpgdを有効にするための最小限の設定
# docker run -v で上書きマウントする前提

mkdir -p ~/.config/code-server/
# touch ~/.local/share/code-server/User/settings.json

cat << 'EOF' > ~/.local/share/code-server/User/settings.json
{
    "remote.autoForwardPortsSource": "hybrid",
    "extensions.autoUpdate": false,
    "extensions.autoCheckUpdates": false,
    "r.consolePath": "/usr/local/bin/arf",
    "r.interactive.arfPath": "/usr/local/bin/arf",
    "terminal.integrated.defaultProfile.linux": "R Terminal",
    "r.plot.backend": "httpgd",
    "r.lsp.enabled": true
}
EOF

# Rのグラフィックデバイスとして httpgd::hgd() を使う設定とコード整形
# settings.json で "r.plot.backend": "httpgd" が必要

cat << 'EOF' >> /home/${DEFAULT_USER}/.Rprofile

options(
  # use httpgd::hgd() for preview R plots
  device       = "httpgd",
  httpgd.host  = "0.0.0.0",
  httpgd.port  = 8088,
  httpgd.token = "",
  
  # code formatting
  languageserver.formatting_style = function(options) {
    styler::tidyverse_style(
      indent_by = options$tabSize,
      strict    = FALSE,
      scope     = "line_breaks"
    )
  }
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
    },
    {
        "key": "shift+f1",
        "command": "workbench.action.showCommands"
    },
    {
        "key": "f1",
        "command": "-workbench.action.showCommands"
    },
    {
        "key": "f1",
        "command": "r.helpPanel.openForSelection"
    }
]
EOF

#-------------------------------
#  uv
#-------------------------------

# 安全のため、リリース後1週間以上経ったパッケージのみインストールできるようにする

mkdir -p ~/.config/uv
echo 'exclude-newer = "1 week"' >> ~/.config/uv/uv.toml
