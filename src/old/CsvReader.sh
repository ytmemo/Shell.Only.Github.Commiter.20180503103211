#!/bin/bash
# Accounts.csv
# ユーザ入力値
#   Username,Email,Password[,TwoFactorSecret]
# 変換後
#   Username,Email,'*'[,TwoFactorSecret],AccessToken
GetPathAccounts() {
    PATH_DIR_THIS=$(cd $(dirname $0); pwd)
    PATH_ACCOUNTS="${PATH_DIR_THIS%/}/Accounts.csv"
    echo ${PATH_ACCOUNTS}
}
ReadUsers() {
    for line in $(cat $(GetPathAccounts) | grep -v ^#); do
        TEXT=${line}
        IFS=','
        set -- $TEXT
        echo $1
    done
}
IsExistUser() {
    for name in $(ReadUsers); do
        [ "$name" == "$1" ] && { return 1; }
    done
    return 0;
}
ReadEmail(){
    local user=$1
    for line in $(cat $(GetPathAccounts) | grep -v ^#); do
        TEXT=${line}
        IFS=','
        set -- $TEXT
        [ $1 == $user ] && { echo $2; }
    done
}
ReadPass(){
    local user=$1
    for line in $(cat $(GetPathAccounts) | grep -v ^#); do
        TEXT=${line}
        IFS=','
        set -- $TEXT
        [ $1 == $user ] && { echo $3; }
    done
}
#ReadUsers
#IsExistUser a
#echo $?
#IsExistUser ytyaru
#echo $?
#m=`ReadEmail ytyaru`
#p=`ReadPass ytyaru`
#echo $m
#echo $p

