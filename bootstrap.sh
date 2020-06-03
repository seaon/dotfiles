#!/usr/bin/env bash

set -e

ROOTPATH=$HOME/.local
mkdir -p $ROOTPATH

# git clone respository
cd $ROOTPATH
if [ -d dotfiles ]; then
    cd dotfiles
    git pull
else
    git clone https://github.com/seaon/dotfiles.git
    cd dotfiles
fi

# initialize
source ./init.sh
