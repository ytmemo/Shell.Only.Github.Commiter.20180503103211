#!/bin/sh
ReadIni() {
    #local repo_path=`pwd`
    echo $#
    [ $# -lt 3 ] && { echo "引数エラー。IniFilePath, Section, Key, の3つの引数が必要です。: $@"; return; }
    sw=0
    while read F1
    do
        tmp=`echo $F1 | awk /]/'{print $1}'`
        if [ "$tmp" != "" ]; then
            str=`echo $tmp | awk -F[ '{print $2}' | awk -F] '{print $1}'`
            if [ "$str" = "$2" ]; then
                sw=1
            else
                sw=0
            fi
        fi
        echo $tmp $sw
        if [ "$sw" = "1" ]; then
            profile=`echo $F1 | grep $3 |  awk -F= '{print $2}' | awk -F; '{print $1}'`
            keyword=`echo $F1 | grep $3 |  awk -F= '{print $1}'`
            if [ "$profile" != "" ]; then
                if [ "$keyword" = "$3" ]; then
                    echo $profile
                    break
                fi
            fi
        fi
    done < $1
}
ReadIni /tmp/work/Shell.Only.Github.Commiter.20180501085541/.git/config 'remote "origin"' 'url'
#ReadIni ../.git/config 'remote "origin"' 'url'
