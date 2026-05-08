# About this images

- **`rocker/r-ver`** を元に `rocker/tidyverse` 相当のパッケージと日本語設定、頻用パッケージをインストールした作業用イメージ
    - `rocker/tidyverse` 相当のうち、容量の大きな dbplyr database backend は RSQLite 以外を省略
- もともと、`rocker/tidyverse` を元に作成していた RStudio server / SSH server イメージと code-server を用いたイメージ [mokztk/codeserver_r](https://github.com/mokztk/codeserver_r) を一本化
- 使用方法別に、4つのイメージを生成
    - **`r_base`**: `rocker/r-ver` に各種パッケージ、python、Node、日本語環境などを導入した共通部分
    - **`rstudio`**: rocker project オリジナルのインストールスクリプトで `rocker/rstudio` 相当の機能を追加
    - **`r_remote`**: RStudio server は導入せず、[Positron](https://positron.posit.co/) などから remote SSH 接続するため SSH server を起動
    - **`codeserver_r`**: UIとして、[code-server](https://github.com/coder/code-server) を追加

```shell
# 4つのイメージをまとめて作成
docker compose build

# 個別に build
docker compose build base_stacks  # r_base
docker compose build rstudio      # rstudio
docker compose build ssh          # r_remote
docker compose build codeserver   # codeserver_r

# 個別に起動
docker run --rm -it mokztk/r_base:4.5.3
docker compose up -d rstudio             # rstudio
docker compose up -d ssh                 # r_remote
docker compose up -d codeserver          # codeserver_r
```

| アプリケーション | バージョン            | 備考                       |
|------------------|-----------------------|----------------------------|
| ベースイメージ   | rocker/r-ver:4.5.3    |                            |
| R                | 4.5.3                 |                            |
| RStudio server   | 2026.04.0+526         | rocker/rstudio:4.5.3 準拠  |
| code-server      | 4.117.0               |                            |
| R languageserver | 0.3.17                | RSPM@2026-04-23            |
| httpgd           | 2.1.4                 | RSPM@2026-04-23            |
| radian           | 0.6.15                |                            |
| Pandoc           | 3.9.0.2               | rocker/rstudio:4.5.3 準拠  |
| Quarto           | 1.9.36                | rocker/rstudio:4.5.3 準拠  |
| Typst            | 0.14.2                | Quarto 同梱                |
| Python3          | 3.12.13               |                            |
| Node.js          | 24.15.0               | Active LTS                 |
| uv               | 0.11.9                |                            |
| n                | 10.2.0                |                            |
| npm              | 11.13.0               |                            |
| pnpm             | 10.33.2               |                            |
| Microsoft Edit   | 2.0.0                 |                            |

## 共通部分（r_base）

`rocker/r-ver` に以下のツールを導入する。標準の起動コマンドは root 権限の `R`

### 一般ユーザー

- 一般ユーザーとして **`ruser`** を設定（4.5.3 以降）
    - 4.5.2 以前は、`rstudio` / `r_remote` では *`rstudio`*、`codeserver_r` では *`coder`*
- システム依存パッケージがスムーズに導入できるよう、パスワード無しで `sudo` 可とする（**非公開での運用前提**）

### 日本語環境、フォント

- Ubuntu の `language-pack-ja`, `language-pack-ja-base`
- 環境変数で `ja_JP.UTF-8` ロケールとタイムゾーン `Asia/Tokyo` を指定
- 日本語フォント
    - **[Noto Sans/Serif JP](https://fonts.google.com/noto/fonts)**（"CJK" なし）
        - `fonts-noto-cjk` は KR, SC, TC のフォントも含むので用途に対して大きすぎる
        - Windows 11 に搭載された Noto Sans/Serif JP（"CJK" なし）と作図コードに互換性が確保できる
        - Github [notofonts/noto-cjk](https://github.com/notofonts/noto-cjk) から個別のOTF版をダウンロードして、Regular, Bold の2ウェイトと Noto Sans Mono CJK JP を手動でインストール
        - serif/sans/monospace の標準日本語フォントとして設定
        - 過去コードの文字化け回避のため、Noto Sans/Serif CJK JP を Noto Sans/Serif JP の別名として登録しておく

### R の追加パッケージ

- DB backend を除く、`rocker/tidyverse` 相当＋個人的な頻用パッケージ
    - [インストール済みのパッケージ一覧](package_list.md)
- インストールの高速化、システム依存パッケージの導入をスムーズにするため `pak::pak()` を活用
- rocker のスクリプトに倣い、インストール後にDLしたアーカイブや導入された *.so を整理
- site library を `/opt/R/packages/4.5` に移動
    - `pak::pak()` でパッケージを追加する際に、同じインストール先にないパッケージは他の場所にあっても重複インストールされてしまう
    - `.libPaths()[1]` が site library になるようにして、一般ユーザー ruser が書き込めるように移動・アクセス権を修正

### Pandoc / Quarto

`rocker/r-ver` 内に収録されている rocker project 製のインストールスクリプトを使用して、`rocker/rstudio:4.5.3` と同じバージョンをインストール

### Python3 / radian

- インストール高速化のため、[uv](https://docs.astral.sh/uv/) を導入
- 公式の `/rocker_scripts/install_python.sh` と同様に仮想環境 `/opt/venv` を作る（プロジェクトとしての `uv init` はなし）
- `reticulate` の運用を考慮し、Numpy / Pandas をインストールしておく
    - Numpy 1.26
    - Pandas 3.0.1
- [radian: A 21 century R console](https://github.com/randy3k/radian) を導入

### Node.js / npm / pnpm

- [Gemini CLI](https://github.com/google-gemini/gemini-cli) などを導入できるよう、 [n](https://github.com/tj/n) 経由で Ubuntu の apt にあるバージョンより新しいものを導入
- 2026-04 現在の Active LTS である Node v24系＋ npm v11系

### [Microsoft Edit](https://github.com/microsoft/edit)

`docker exec -it ...` で設定を変更する際などのCLI用のテキストエディタがないので、`msedit` の名前で使用できるように導入しておく


## RStudio Server イメージ（rstudio）

### RStudio Server

- `rocker/r-ver` 内に収録されている rocker project 製のインストールスクリプトを使用して、`rocker/rstudio:4.5.3` と同じバージョンをインストール
- 起動時のディレクトリは /workspace
- 個人設定は `/home/ruser/.config/rstudio/rstudio-prefs.json`
- TCP 8787 ポートで待機

```shell
docker run --rm -d \
  -p 8787:8787 \
  -v ./rstudio-prefs.json:/home/ruser/.config/rstudio/rstudio-prefs.json \
  --name rstudio \
  mokztk/rstudio:4.5.3
  
# http://localhost:8787/
```

### プログラミングフォント

RStudio Serverのエディタ用カスタムフォントとして導入

- [UDEV Gothic](https://github.com/yuru7/udev-gothic)
    - @tawara_san 氏作の BIZ UD Gothic + JetBrains Mono の合成フォント
    - 半角:全角 3:5版ではなく、通常の1:2でリガチャ有効のバージョン（UDEVGothicLG-*.ttf）を使用
- [Mint Mono](https://github.com/yuru7/mint-mono)
    - @tawara_san 氏作の Intel One Mono と Circle M+ 等の合成フォント
    - 半角:全角 3:5版ではなく、通常の1:2のバージョン（MintMono-*.ttf）を使用。リガチャなし

### 環境変数 PASSWORD の仮設定

- Docker Desktop など `-e PASSWORD=...` が設定できないGUIでも起動テストできるように仮のパスワード `password` を埋め込んでおく
- 更に、普段使いのため `DISABLE_AUTH=true` を埋め込み基本的にはユーザー認証不要とする
- 認証が必要なときは、起動時に `-e DISABLE_AUTH=false`

### rootless モードの設定

Podman の rootless モードで使用する場合は、そのままの rootless モードでは s6-init から RStudio Server が起動できない。
コンテナ内の一般ユーザーは UID 1000 なので、Linux ホストの UID も 1000 ならば

```shell
podman run --rm -d \
  --userns=keep-id \
  --user root \
  -e RUNROOTLESS=false \
  -p 8787:8787 \
  mokztk/rstudio:4.5.3
```

で起動できる。それ以上は、[公式](https://rocker-project.org/use/rootless-podman.html) 参照のこと。

また、`ROOTLESS=false` を設定しておけば、従来どおり一般ユーザーを使用するので amd64 (x86_64) 版と設定ファイルなどを共用できる。

以上より、`ROOTLESS=false` を埋め込んでおく。rocker project 純正の rootless 用処理が必要なら、`-e ROOTLESS=true` で起動する。

### TinyTeX

- Quarto-Typst で日本語PDFも作成できほぼ使わななくなったため、TinyTeX はパッケージはインストールしてあるがセットアップをしていない状態
- 必要に応じてユーザー権限でセットアップスクリプト `/my_script/install_tinytex.sh` を実行する（RStudio の Terminal で可）
    - R4.3系以降メンテナンスしていないが、TeX Live 2022 frozen ベースで LuaLaTeX / XeLaTeX で日本語PDFを作成できる環境が準備できるはず


## SSH server イメージ（r_remote）

パスワード認証（ユーザー・パスワードとも `ruser`）での SSH 接続に加えて、`/home/ruser/.ssh/authorized_keys` に公開鍵を登録すればパスワード不要の公開鍵暗号での接続も可能になる。

```shell
docker run --rm -d \
  -p 2222:22 \
  -v ./id_ed25519.pub:/home/ruser/.ssh/authorized_keys:ro \
  --name r_remote \
  mokztk/r_remote:4.5.3

# ssh ruser@localhost:2222
```

起動時のディレクトリは /workspace に設定


## code-server イメージ（codeserver_r）

- [公式](https://github.com/coder/code-server) のインストールスクリプトを使用してインストール
- code-server は TCP 8080、httpgd は TCP 8088 番ポートを使用
- 設定ファイル用に、`/home/ruser/.local/share/code-server/User/settings.json` に所有者 ruser の空ファイルを作成済
- 起動時のディレクトリは /workspace に設定

#### settings.json 見本ファイル

- R 用コンソールは `radian` (r.rterm.linux)
- R のグラフィックデバイスは `httpgd::hgd()` (r.plot.useHttpgd)
- タブ設定はスペース 2文字分 (editor.tabSize)
- Air, Quarto 拡張機能による保存時の自動整形は off (editor.formatOnSave)
- ファイルの自動保存は off (files.autoSave)
- 起動時にR Terminalを開く（terminal.integrated.defaultProfile.linux）

```shell
docker run --rm -d \
  -p 8080:8080 \
  -p 8088:8088 \
  -v ./settings.json:/home/ruser/.local/share/code-server/User/settings.json \
  --name codeserver_r \
  mokztk/codeserver_r:4.5.3

# http://localhost:8080/      # code-server
# http://localhost:8088/live  # httpgd
```

- 拡張機能 
    - REditorSupport (REditorSupport.r)
    - Air - R Language Support (posit.air-vscode)
    - Quarto (quarto.quarto)
    - Gemini Code Assist (Google.geminicodeassist)
- Language Server
    - R `{languageserver}`
- RStudio と同様のキーボードショートカット
    - `Shift + Ctrl + m` で `|>` を挿入（R, Rmd, Quarto）
    - `Shift + Ctrl + c` で行コメントの切り替え（デフォルトは `Ctrl + /`）

### dependency cooldown

一般ユーザー ruser の場合、pnpm と uv 経由でのパッケージ導入はリリース後1週間以上経過したパッケージのみに制限


## History

- **2020-11-02** [Gist: mokztk/R4.0_2020Oct.Docerfile](https://gist.github.com/mokztk/be9e0d8982fd32987dbb5c9552a9d4a7) から改めてレポジトリとして編集を開始
- **2020-11-02** 🔖[4.0.2_2020Oct](https://github.com/mokztk/RStudio_docker/releases/tag/4.0.2_2020Oct) : `rocker/tidyverse:4.0.2` 対応版 
- **2021-01-14** 🔖[4.0.2_update2101](https://github.com/mokztk/RStudio_docker/releases/tag/4.0.2_update2101) : 4.0.2_2020Oct の修正版 
- **2021-03-06** 🔖[4.0.2_2021Jan](https://github.com/mokztk/RStudio_docker/releases/tag/4.0.2_2021Jan) : `rocker/tidyverse:4.0.2` ベースのままパッケージを更新
- **2021-03-11** 🔖[4.0.3_2020Feb](https://github.com/mokztk/RStudio_docker/releases/tag/4.0.3_2021Feb) : `rocker/tidyverse:4.0.3` にあわせて更新
- **2021-04-01**  ブランチ構成を再編（GitHub flow モドキ）
- **2021-04-04** 🔖[4.0.3_TL2020](https://github.com/mokztk/RStudio_docker/releases/tag/4.0.3_TL2020) : TeX を TeX Live 2020 (frozen) に固定
- **2021-04-13** 🔖[4.0.3_update2104](https://github.com/mokztk/RStudio_docker/releases/tag/4.0.3_update2104) : 4.0.3_TL2020 の修正版
- **2021-08-30** 🔖[4.1.0_2021Aug](https://github.com/mokztk/RStudio_docker/releases/tag/4.1.0_2021Aug) : `rocker/tidyverse:4.1.0` にあわせて更新。coding font 追加
- **2021-09-22** 🔖[4.1.0_2021Aug_r2](https://github.com/mokztk/RStudio_docker/releases/tag/4.1.0_2021Aug_r2) : PlemolJP フォントを最新版に差し替え（記号のズレ対策）
- **2021-11-11** 🔖[4.1.1_2021Oct](https://github.com/mokztk/RStudio_docker/releases/tag/4.1.1_2021Oct) : `rocker/tidyverse:4.1.1` にあわせて更新。フォント周りを中心に整理
- **2022-06-07** 🔖[4.2.0_2022Jun](https://github.com/mokztk/RStudio_docker/releases/tag/4.2.0_2022Jun) : ベースを `rocker/tidyverse:4.2.0` （2022-06-02版）に更新。Quartoの導入、フォントの変更など
- **2022-06-24** 🔖[4.2.0_2022Jun_2](https://github.com/mokztk/RStudio_docker/releases/tag/4.2.0_2022Jun_2) : ベースを `rocker/tidyverse:4.2.0` snapshot確定版に更新。Quarto関係を修正
- **2023-04-06** 🔖[4.2.2_2023Mar](https://github.com/mokztk/RStudio_docker/releases/tag/4.2.2_2023Mar) : `rocker/tidyverse:4.2.2` にあわせて更新。ARM64版を試作
- **2023-06-21** 🔖[4.2.2_2023Mar_2](https://github.com/mokztk/RStudio_docker/releases/tag/4.2.2_2023Mar_2) : Noto Sans JP フォントの導入に失敗していたのを修正
- **2023-06-23** 🔖[4.3.0_2023Jun](https://github.com/mokztk/RStudio_docker/releases/tag/4.3.0_2023Jun) : `rocker/tidyverse:4.3.0` にあわせて更新
- **2024-04-26** 🔖[4.3.3_2024Apr](https://github.com/mokztk/RStudio_docker/releases/tag/4.3.3_2024Apr) : `rocker/rstudio:4.3.3` をベースにQuarto 1.4を追加。Amd64/Arm64のDockerfileを1本化
- **2025-03-06** 🔖[4.4.2_2025Mar](https://github.com/mokztk/RStudio_docker/releases/tag/4.4.2_2025Mar) : `rocker/rstudio:4.4.2` ベースに更新
- **2025-06-15** 🔖[4.5.0_2025Jun](https://github.com/mokztk/RStudio_docker/releases/tag/4.5.0_2025Jun) : `rocker/rstudio:4.5.0` ベースに更新。remote SSH接続できるよう設定を追加
- **2025-10-15** RStudio server版（こちらからは remote SSH 接続を削除）と remote SSH 版を一本化
- **2025-11-04** 🔖[4.5.1_2025Nov](https://github.com/mokztk/RStudio_docker/releases/tag/4.5.1_2025Nov) : `rocker/r-ver:4.5.1` ベースに更新
- **2026-03-13** 🔖[4.5.2_2026Mar](https://github.com/mokztk/RStudio_docker/releases/tag/4.5.2_2026Mar) : `rocker/r-ver:4.5.2` ベースに更新
- **2026-05-08** 🔖[4.5.3_2026May](https://github.com/mokztk/RStudio_docker/releases/tag/4.5.3_2026May) : `rocker/r-ver:4.5.3` ベースに更新。code-server 版と一本化。
