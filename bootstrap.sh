#!/usr/bin/env bash

set -e

ROOTPATH=$HOME/.local
ETC=$ROOTPATH/etc
BIN=$ROOTPATH/bin
mkdir -p $ETC
mkdir -p $BIN

# git clone respository
cd $ROOTPATH
if [ -d dotfiles ]; then
    cd dotfiles
    git pull
else
    git clone https://github.com/seaon/dotfiles.git
    cd dotfiles
fi
cp -rf config/* $ETC/
cp bootstrap.sh $BIN/

# source init.sh
sed -i "\:$ETC/bashrc.sh:d" ~/.bashrc
echo "source $ETC/bashrc.sh" >> ~/.bashrc
source ~/.bashrc

# source vimrc.vim
touch ~/.vimrc
sed -i "\:$ETC/vimrc.vim:d" ~/.vimrc
echo "source $ETC/vimrc.vim" >> ~/.vimrc

# source tmux.conf
touch ~/.tmux.conf
sed -i "\:$ETC/tmux.conf:d" ~/.tmux.conf
echo "source $ETC/tmux.conf" >> ~/.tmux.conf

# initialize
source lib/init.sh

echo "All done."