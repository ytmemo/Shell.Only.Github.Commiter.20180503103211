#!/bin/bash
# $1 INIファイルパス
# $2 INIセクション
# $3 INIキー
ReadIni() {
    [ $# -lt 3 ] && { echo "引数エラー。IniFilePath, Section, Key, の3つの引数が必要です。: $@"; return; }
    local HasSection=0
    cat $1 | while read line; do
        # 対象セクションの存在確認
        [ "$line" != "[$2]" -a 0 -eq $HasSection ] && continue
        HasSection=1
        # split
        local key="${line%=*}"
        local value="${line#*=}"
        # trim
        local key=`echo $key | xargs`
        local value=`echo $value | xargs`
        [ "$3" = "$key" ] && { echo $value; break; }
#        [ "$3" = "$key" ] && { echo $value; break; return; }
    done
}
#ReadIni /tmp/work/Shell.Only.Github.Commiter.20180501085541/.git/config 'remote "origin"' url
