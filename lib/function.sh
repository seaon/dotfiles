#!/usr/bin/env bash

# Apply global git identity. Safe to run repeatedly (idempotent).
function git_conf () {
    git config --global user.email "$GIT_EMAIL"
    git config --global user.name  "$GIT_NAME"

    # core.autocrlf only makes sense on Windows / Git Bash
    case "$OSTYPE" in
        msys*|cygwin*|win32*) git config --global core.autocrlf false ;;
    esac
}

# usage:
# sleep 5s &
# wait_for $!
function wait_for () {
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
