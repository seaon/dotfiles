#!/usr/bin/env bash

function gitConf () {
    git config --global user.email $GITemail
    git config --global user.name  $GITname

    git config --global core.autocrlf false
}

function vimConf () {
    #
}

function tmuxConf () {
    #
}

function initEnv () {
    #
}

function clean () {
    #
}

# usage:
# sleep 5s &
# waitFor $!
function waitFor () {
    local spin='-\|/'
    local i=0

    while kill -0 $1 2>/dev/null
    do
        i=$(( (i+1) %4 ))
        echo -en "\r${spin:$i:1}"
        sleep .1
    done
    echo 
}

function installDepend () {
    sudo yum install -y gzip \
        wget \
}
