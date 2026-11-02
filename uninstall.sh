#!/usr/bin/env bash
#
# uninstall.sh — 卸载 dotfiles
#
# 它会：
#   1. 备份 ~/.bashrc / ~/.zshrc / ~/.vimrc（带时间戳）
#   2. 从这些 rc 文件中移除本项目注入的 `source ...` 行和 PATH 配置
#   3. 删除 ~/.local/etc 与 ~/.local/lib 中本项目放置的文件
#
# 用法：
#   ./uninstall.sh           交互确认后卸载
#   ./uninstall.sh -f        不询问，直接卸载
#   ./uninstall.sh -n        只预览将要做的操作，不实际修改
#   ./uninstall.sh --purge   卸载并同时删除克隆的仓库 ~/.local/dotfiles
#   ./uninstall.sh -h        显示帮助

set -u

FORCE=0; DRY=0; PURGE=0
for a in "$@"; do
  case "$a" in
    -f|--force) FORCE=1 ;;
    -n|--dry-run) DRY=1 ;;
    --purge) PURGE=1 ;;
    -h|--help) sed -n '6,16p' "$0"; exit 0 ;;
    *) echo "未知参数: $a" >&2; exit 1 ;;
  esac
done

# 跨平台 sed -i（macOS 需要显式空扩展名参数）
if [[ "$OSTYPE" == "darwin"* ]]; then
  sedi() { sed -i '' "$@"; }
else
  sedi() { sed -i "$@"; }
fi

# 转义正则特殊字符，用于 sed 按行匹配
esc() { printf '%s' "$1" | sed 's/[][\.*^$/]/\\&/g'; }

# 与 init.sh / config.sh 保持一致的目录变量
ETC_DIR="$HOME/.local/etc"
LIB_DIR="$HOME/.local/lib"
BIN_DIR="$HOME/.local/bin"
REPO_DIR="${REPO_DIR:-$HOME/.local/dotfiles}"

SHELL_RCS=(~/.bashrc ~/.zshrc)
SRC_TARGETS=(
  "$ETC_DIR/bashrc.sh" "$ETC_DIR/z.sh" "$ETC_DIR/config.sh"
  "$LIB_DIR/echo.sh" "$LIB_DIR/function.sh"
)

backup() {
  [ -f "$1" ] || return 0
  if [ "$DRY" = 1 ]; then
    echo "将备份 $1 -> $1.bak.<timestamp>"
    return 0
  fi
  local bak="$1.bak.$(date +%Y%m%d%H%M%S)"
  cp "$1" "$bak" && echo "已备份 $1 -> $bak"
}

del_source() {
  local rcfile="$1" target="$2"
  [ -f "$rcfile" ] || return 0
  echo "移除 $rcfile 中的: source $target"
  [ "$DRY" = 1 ] && return 0
  sedi "\|$(esc "$target")|d" "$rcfile"
}

del_path() {
  local rcfile="$1"
  [ -f "$rcfile" ] || return 0
  echo "移除 $rcfile 中的 PATH 配置"
  [ "$DRY" = 1 ] && return 0
  sedi '\|export PATH=.*local/bin|d' "$rcfile"
}

remove_assets() {
  echo "删除 ~/.local 下本项目放置的文件"
  if [ "$DRY" = 1 ]; then
    echo "  (dry-run) $ETC_DIR/*  $LIB_DIR/*  $BIN_DIR/*"
    return 0
  fi
  if [ -d "$REPO_DIR" ]; then
    # 依据仓库原始目录，精确删除被拷贝出去的文件（按 basename 对应）
    for f in "$REPO_DIR"/config/*; do [ -f "$f" ] && rm -f "$ETC_DIR/$(basename "$f")"; done
    for f in "$REPO_DIR"/lib/*;    do [ -f "$f" ] && rm -f "$LIB_DIR/$(basename "$f")"; done
    for f in "$REPO_DIR"/app/*;    do [ -f "$f" ] && rm -f "$BIN_DIR/$(basename "$f")"; done
  else
    # 仓库已不存在时的兜底清单
    rm -f "$ETC_DIR"/bashrc.sh "$ETC_DIR"/config.sh "$ETC_DIR"/vimrc.vim "$ETC_DIR"/z.sh
    rm -f "$LIB_DIR"/echo.sh "$LIB_DIR"/function.sh
    rm -f "$BIN_DIR"/timestamp
  fi
  rmdir "$LIB_DIR" 2>/dev/null || true
  rmdir "$ETC_DIR" 2>/dev/null || true
}

if [ "$FORCE" != 1 ] && [ "$DRY" != 1 ]; then
  read -r -p "确认卸载 dotfiles？将修改 ~/.bashrc 等并删除 ~/.local/etc 与 ~/.local/lib 中的文件 [y/N] " ans
  case "$ans" in
    y|Y|yes|YES) ;;
    *) echo "已取消。"; exit 0 ;;
  esac
fi

# 1) 备份 rc 文件
for rc in "${SHELL_RCS[@]}" ~/.vimrc; do backup "$rc"; done

# 2) 移除 source / PATH 行
for rc in "${SHELL_RCS[@]}"; do
  for t in "${SRC_TARGETS[@]}"; do del_source "$rc" "$t"; done
  del_path "$rc"
done
del_source ~/.vimrc "$ETC_DIR/vimrc.vim"

# 3) 删除放置的文件
remove_assets

# 4) 可选：删除克隆仓库
if [ "$PURGE" = 1 ]; then
  if [ "$DRY" = 1 ]; then
    echo "  (dry-run) 将删除仓库 $REPO_DIR"
  else
    echo "删除仓库 $REPO_DIR"
    rm -rf "$REPO_DIR"
  fi
fi

echo "卸载完成。请重新打开终端（或执行 source ~/.bashrc）使改动生效。"
