# このソフトウェアについて

GitHub簡易アップローダ。

## 目的

Git,GitHubのリポジトリをコマンド一発で作成する。

* git
    * init, status, add, commit, push, pull
* github
    * リモートリポジトリ作成
    * AccessToken取得

## 方針

* 導入しやすい環境で実行できるようにする
* リポジトリ作成以外の大機能は実装しない（集計など）

### 実行環境

候補は以下。上ほど環境の導入が容易のはず。

* Bash
    * curl
* Python
    * 2.7.x
    * 3.4.x (pathlib:OK)
    * 3.6.x (f'':OK)
* Bash+Python
* Bash+Python+SQLite3

### DB

* CSV,TSV
* SQLite3

CSVかTSVがいい。入力画面の実装が面倒、環境の容易さ、汎用性が理由。

## 変更点

* 脱外部依存
    * sqlite3とそのDBへの依存を解消してテキストファイル保存にした

## 未実装の欲しい機能

* 入力の簡略化
    * 新規GitHubアカウントを登録するときはTSVファイルに書き込むだけ
        * Username, E-MailAddress, Password
        * 入力後の初回起動時、AccessTokenを自動取得する
            * トークンをTSVファイルに記録する
            * TSVのパスワードを`*`にする
* Github二要素認証対応

# 開発環境

* [Raspberry Pi](https://ja.wikipedia.org/wiki/Raspberry_Pi) 3 Model B
    * [Raspbian](https://www.raspberrypi.org/downloads/raspbian/) GNU/Linux 8.0 (jessie)
        * bash 4.3.30

# ライセンス

このソフトウェアはCC0ライセンスである。

[![CC0](http://i.creativecommons.org/p/zero/1.0/88x31.png "CC0")](http://creativecommons.org/publicdomain/zero/1.0/deed.ja)
