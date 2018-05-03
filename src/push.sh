#!/bin/bash
IsSameRepoName () {
    local f="${repo_path}/.git/config"
    [ ! -f "$f" ] && return
    . $(cd $(dirname $0); pwd)/IniReader.sh
    local url=`ReadIni "$f" 'remote "origin"' url`
    # 以下HTTPS形式を想定
    # https://user:pass@github.com/user/repo.git
    username=`echo ${url} | awk -F "/" '{ print $(NF - 1) }'`
    local gitconfig_reponame=`echo ${url} | awk -F "/" '{ print $NF }'`
    local gitconfig_reponame=`echo ${gitconfig_reponame%.git}`
    local cd_name=$(basename "${repo_path}")
    [ "${cd_name}" != "${gitconfig_reponame}" ] && { echo -e ".git/configのリポジトリ名とカレントディレクトリ名が一致しません。他所からコピペした.gitを間違って使い回していませんか？\n  .git/configリポジトリ名: ${gitconfig_reponame}\n  カレントディレクトリ名 : ${cd_name}"; exit 1; }
}
ExistReadMe () {
    for name in README ReadMe readme Readme; do
        for ext in "" .md .txt; do
            [ -f "${repo_path}/${name}${ext}" ] && return 0
        done
    done
    echo "カレントディレクトリに ReadMe.md が存在しません。作成してください。: "${repo_path}
    exit 1
}
SelectUser () {
    #. CsvReader.sh
    # usernameが未定義ならユーザ選択させる
    if [ -z "$username" ] && [ "${username:-A}" = "${username-A}" ]; then
        local select=`ReadUsers`
        echo "ユーザを選択してください。"
        select i in $select; do [ -n "$i" ] && { username=$i; break; }; done
    fi
}
IsRegistedUser () {
    #. CsvReader.sh
    IsExistUser "$1"
    [ 0 -eq $? ] && { echo "指定されたユーザ名はAccounts.csvに登録されていません。: '$1'"; exit 1; }
    username=$1
}
GetPassMail () {
    #. CsvReader.sh
    mailaddr=`ReadEmail "$username"`
    password=`ReadPass "$username"`
    [ -z "$password" ] && { echo "パスワードが見つかりませんでした。DBを確認してください。"; exit 1; }
    [ -z "$mailaddr" ] && { echo "メールアドレスが見つかりませんでした。DBを確認してください。"; exit 1; }
}
OverwriteConfig () {
    local before="	url = https://github.com/"
    if [ "$token" == "" ]; then
        local after="	url = https://${username}:${password}@github.com/"
    else
        local after="	url = https://${username}:${token}@github.com/"
    fi
    local config=".git/config"
    cp "$config" "$config.BAK"
    sed -e "s%$before%$after%" "$config.BAK" > "$config"
    rm "$config.BAK"
}
CreateRepository () {
    if [ ! -d ".git" ]; then
        echo "リポジトリを作成しますか？ (y/n)"
        local ans=''
        read ans
        [ "$ans" == 'y' ] && { git init; CreateRemoteRepository; return; }
        exit 1
    fi
}
CreateRemoteRepository () {
    echo "リモートリポジトリを作成します。"
    #json='{"name":"'${REPO_NAME}'","description":"'${REPO_DESC}'","homepage":"'${REPO_HOME}'"}'it
    json='{"name":"'${repo_name}'"}'
    #echo $json | curl -u "${username}:${password}" https://api.github.com/user/repos -d @-
    local token=`ReadToken $username`
    if [ "$token" == "" ]; then
        echo $json | curl -u "${username}:${password}" https://api.github.com/user/repos -d @-
        git remote add origin https://${username}:${password}@github.com/${username}/${repo_name}.git
        OverwriteConfig
    else
        #echo $json | curl -H "Authorization: token $token" https://api.github.com/user/repos -d @-
        echo $json | curl -u "$username:$token" https://api.github.com/user/repos -d @-
        git remote add origin https://${username}:${token}@github.com/${username}/${repo_name}.git
    fi
}
CheckView () {
    git status -s
    echo "--------------------"
    git add -n .
    echo "--------------------"
    echo commit message入力するとPush。未入力のままEnterキー押下で終了。
    read answer
}
AddCommitPush () {
    if [ -n "$answer" ]; then
        git add .
        git commit -m "$answer"
        #OverwriteConfig
        # stderrにパスワード付URLが見えてしまうので隠す
        git push origin master 2>&1 | grep -v http
    fi
}
MainMethod () {
    if [ -n "$answer" ]; then
        CreateRemoteRepository
        AddCommitPush 
    fi
}

# $1 Githubユーザ名
repo_path=`pwd`
. $(cd $(dirname $0); pwd)/AccountsCsvReader.sh
#repo_path=$(cd $(dirname $0); pwd)
IsSameRepoName 
ExistReadMe
[ 0 -eq $# ] && SelectUser
[ 0 -lt $# ] && IsRegistedUser $1

# パスワード取得と設定
GetPassMail
git config --local user.name $username
git config --local user.email "$mailaddr"

# Create, Add, Commit, Push
repo_name=$(basename $repo_path)
echo "$username/$repo_name"
CreateRepository 
CheckView
AddCommitPush 

unset username
unset password
unset mailaddr
