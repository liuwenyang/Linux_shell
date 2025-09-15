#!/bin/bash


#带''是为了防止打印字符转义
#Vim 的配置文件（~/.vimrc）默认只支持纯文本配置命令，注释需要以英文 # 开头，且不能包含非 ASCII 字符（例如中文）。
cat << 'EOF' >> ~/.vimrc
" Show line numbers
set number

" Enable syntax highlighting
syntax on

" Show cursor position at the bottom
set ruler

" Set tab to 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab

EOF


echo "重启vim 配置起作用"

