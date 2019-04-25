#!/usr/bin/env bash

function install () {
    version=2.19.2
    download_file_name=v${version}.tar.gz
    file_name=git-${version}.tar.gz

    mkdir -p ~/app-src
    cd ~/app-src

    if [ ! -f ${file_name} ]; then
        wget -O ${file_name} https://github.com/git/git/archive/${download_file_name}
        tar -zxvf ${file_name}
    fi
}