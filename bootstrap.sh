#!/usr/bin/env bash

set -e

ROOT_DIR=$HOME/.local
mkdir -p "$ROOT_DIR"

# git clone respository
cd "$ROOT_DIR"
if [ -d dotfiles ]; then
    cd dotfiles
    # --ff-only avoids non-fast-forward failures aborting the install
    git pull --ff-only || echo "⚠️ 更新失败（可能本地有修改或与上游分叉），保留当前版本"
else
    git clone https://github.com/seaon/dotfiles.git
    cd dotfiles
fi

# initialize
source "$ROOT_DIR/dotfiles/init.sh"
