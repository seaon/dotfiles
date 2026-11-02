#!/usr/bin/env bash

# base from https://zhuanlan.zhihu.com/p/50080614

set -e

ROOT_DIR="$HOME/.local"
ETC_DIR="$ROOT_DIR/etc"
LIB_DIR="$ROOT_DIR/lib"
BIN_DIR="$ROOT_DIR/bin"
mkdir -p "$ETC_DIR" "$LIB_DIR" "$BIN_DIR"

# Cross-platform sed -i (macOS requires an explicit empty extension argument)
if [[ "$OSTYPE" == "darwin"* ]]; then
    sedi() { sed -i '' "$@"; }
else
    sedi() { sed -i "$@"; }
fi

# Idempotently add a `source` line to an rc file.
add_source() {
    local rcfile="$1" target="$2"
    touch "$rcfile"
    sedi "\:$target:d" "$rcfile"
    echo "source $target" >> "$rcfile"
}

# Idempotently ensure ~/.local/bin is on PATH.
add_path() {
    local rcfile="$1"
    touch "$rcfile"
    grep -q 'local/bin' "$rcfile" 2>/dev/null || \
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$rcfile"
}

# ---- copy assets ----
cp -rf config/* "$ETC_DIR/"
cp -rf lib/* "$LIB_DIR/"
cp -rf app/* "$BIN_DIR/"
chmod +x "$BIN_DIR/"*

# ---- bash ----
add_source ~/.bashrc "$ETC_DIR/bashrc.sh"
add_source ~/.bashrc "$ETC_DIR/z.sh"
add_source ~/.bashrc "$ETC_DIR/config.sh"
add_source ~/.bashrc "$LIB_DIR/echo.sh"
add_source ~/.bashrc "$LIB_DIR/function.sh"
add_path ~/.bashrc

# ---- zsh (only if a zshrc already exists) ----
if [ -f ~/.zshrc ]; then
    add_source ~/.zshrc "$ETC_DIR/bashrc.sh"
    add_source ~/.zshrc "$ETC_DIR/z.sh"
    add_source ~/.zshrc "$ETC_DIR/config.sh"
    add_source ~/.zshrc "$LIB_DIR/echo.sh"
    add_source ~/.zshrc "$LIB_DIR/function.sh"
    add_path ~/.zshrc
fi

# ---- editor (vim) ----
add_source ~/.vimrc "$ETC_DIR/vimrc.vim"

# ---- apply git identity once (persists into ~/.gitconfig) ----
if command -v git >/dev/null 2>&1; then
    source "$ETC_DIR/config.sh"
    source "$LIB_DIR/function.sh"
    git_conf
fi

echo "All done. 请重新打开终端（或执行 source ~/.bashrc）使配置生效。"
