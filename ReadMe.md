# このソフトウェアについて

GitHub簡易アップローダ。

# 使い方

## 準備

Accounts.csv
```
Username,MailAddress,Password
```

アカウントデータファイルを用意する。

## 実行

```sh
$ push
```
```sh
$ push some_username
```

* `push`ファイルを環境変数`PATH`が通っている所に配置する。
* カレントディレクトリをリポジトリと想定する

## 確認表示

### JSON

[リモートリポジトリ生成API](https://developer.github.com/v3/repos/#create)の応答。何か変わっても知れるように。（デバッグ）

### ReadMe

```sh
カレントディレクトリに ReadMe.md が存在しません。作成してください。
```

間違ってカレントディレクトリが`/`などだった場合も、少しは安心。

### User

```sh
ユーザを選択してください。
1) user1  3) user3  5) user5
2) user2  4) user4  6) user6
```

起動引数がなければ、CSVから全ユーザ名を取得して選択肢を出す。辞書順。

```sh
指定されたユーザ名はDBに登録されていません。
```

起動引数でユーザ名を指定しても、DBになければエラーになる。

### add前

* `git status -s`
* `git add -n .`

`git status`を追加。`git rm some.py`などで削除だけしたときも変化がわかるようにした。

### push出力

`git push`コマンドがstderrにパスワードを含むURLを出していたのを抑制した。

```sh
To https://{user}:{pass}@github.com/{user}/{repo}.git
```

# 開発環境

* [Raspberry Pi](https://ja.wikipedia.org/wiki/Raspberry_Pi) 3 Model B
    * [Raspbian](https://www.raspberrypi.org/downloads/raspbian/) GNU/Linux 8.0 (jessie)
        * bash 4.3.30

# ライセンス

このソフトウェアはCC0ライセンスである。

[![CC0](http://i.creativecommons.org/p/zero/1.0/88x31.png "CC0")](http://creativecommons.org/publicdomain/zero/1.0/deed.ja)

利用ライブラリは以下。

Library|License|Copyright
-------|-------|---------
[assert.sh](https://github.com/lehmannro/assert.sh)|[LGPL-3.0](https://github.com/lehmannro/assert.sh/blob/master/COPYING.LESSER)|[Copyright (C) 2007 Free Software Foundation, Inc. http://fsf.org/](https://github.com/lehmannro/assert.sh/blob/master/COPYING)

