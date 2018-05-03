#!/bin/sh
ReadIni() {
    INI_FILE=$1
    INI_SECTION=$2

# ini parser
    eval `sed -e 's/[[:space:]]*\=[[:space:]]*/=/g' \
        -e 's/;.*$//' \
        -e 's/[[:space:]]*$//' \
        -e 's/^[[:space:]]*//' \
        -e "s/^\(.*\)=\([^\"']*\)$/\1=\"\2\"/" \
       < $INI_FILE \
        | sed -n -e "/^\[$INI_SECTION\]/,/^\s*\[/{/^[^;].*\=.*/p;}"`

    echo $a 
}
ReadIni /tmp/work/Shell.Only.Github.Commiter.20180501085541/.git/config 'remote "origin"'
echo $url
#ReadIni /tmp/work/Shell.Only.Github.Commiter.20180501085541/.git/config 'remote "origin"' 'url'
#ReadIni ../.git/config 'remote "origin"' 'url'
