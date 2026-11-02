# dotfiles
My dotfiles

## usage
1. Install:
```sh
$ curl -sSL https://raw.githubusercontent.com/seaon/dotfiles/master/bootstrap.sh | bash
```
or
```sh
$ curl -sSL  https://gitee.com/seaon/dotfiles/raw/master/bootstrap.sh | bash
```
2. Update:
```sh
$ bootstrap.sh
```
3. Uninstall:
```sh
$ ./uninstall.sh          # 交互确认后卸载
$ ./uninstall.sh -f       # 不询问，直接卸载
$ ./uninstall.sh -n       # 只预览将要做的操作，不实际修改
$ ./uninstall.sh --purge  # 卸载并同时删除克隆的仓库 ~/.local/dotfiles
```
> 卸载会先备份 `~/.bashrc` / `~/.zshrc` / `~/.vimrc`，再移除其中本项目注入的配置行，并删除 `~/.local/etc`、`~/.local/lib` 下本项目放置的文件。

## third-party components

本项目包含以下第三方组件，保留其原始许可：

- `config/z.sh` — Copyright (c) 2009 rupa deadwyler，基于 WTFPL v2（目录快速跳转工具）。
- `lib/echo.sh` — 彩色 echo 辅助函数，来自 Adam Eivy 的 dotfiles，按原样使用。

## license

本项目以 MIT 许可证发布，详见 [LICENSE](LICENSE)。

## reference
https://zhuanlan.zhihu.com/p/50080614
