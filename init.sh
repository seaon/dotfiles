#!/usr/bin/env bash

## base from https://zhuanlan.zhihu.com/p/50080614

set -e

ROOTPATH=$HOME/.local
ETC=$ROOTPATH/etc
BIN=$ROOTPATH/bin
mkdir -p $ETC
mkdir -p $BIN

# 初始化脚本

cp -rf config/* $ETC/
cp bootstrap.sh $BIN/

# 添加可执行权限
chmod +x $BIN/*

# source bashrc.sh
sed -i "\:$ETC/bashrc.sh:d" ~/.bashrc
echo "source $ETC/bashrc.sh" >> ~/.bashrc
source ~/.bashrc

# source z.sh
sed -i "\:$ETC/z.sh:d" ~/.bashrc
echo "source $ETC/z.sh" >> ~/.bashrc
source ~/.bashrc

# source vimrc.vim
touch ~/.vimrc
sed -i "\:$ETC/vimrc.vim:d" ~/.vimrc
echo "source $ETC/vimrc.vim" >> ~/.vimrc

# source tmux.conf
touch ~/.tmux.conf
sed -i "\:$ETC/tmux.conf:d" ~/.tmux.conf
echo "source $ETC/tmux.conf" >> ~/.tmux.conf

# 将个人 ~/.local/bin 目录加入 PATH
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# 整理 PATH，删除重复路径
if [ -n "$PATH" ]; then
    old_PATH=$PATH:; PATH=
    while [ -n "$old_PATH" ]; do
        x=${old_PATH%%:*}
        case $PATH: in
           *:"$x":*) ;;
           *) PATH=$PATH:$x;;
        esac
        old_PATH=${old_PATH#*:}
    done
    PATH=${PATH#:}
    unset old_PATH x
fi
export PATH

echo "All done."
