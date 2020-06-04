set nocompatible  " Use Vim defaults (much better!)
set bs=indent,eol,start   " allow backspacing over everything in insert mode
set viminfo='20,\"50  " read/write a .viminfo file, don't store more
      " than 50 lines of registers
set history=50    " keep 50 lines of command line history
set ruler   " show the cursor position all the time

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

filetype plugin on

" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"
" 配色方案
colorscheme desert
" 语法高亮度显示
syntax on
" 显示行号
set number
set cursorline " 高亮光标所在行
" 自动对齐
set autoindent
set cindent
" Tab键的宽度
set tabstop=4
" 统一缩进为4
set softtabstop=4
set shiftwidth=4
set smarttab
" 使用空格代替制表符
set expandtab
filetype on
" 设置编码
set fileencoding=utf-8