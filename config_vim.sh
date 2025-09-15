#!/bin/bash


#带''是为了防止打印字符转义
cat << 'EOF' >> ~/.vimrc
#设置显示行号
set number

#启用语法高亮
syntax on

#在底部显示当前光标位置
set ruler

#其他一些常用配置...
#设置Tab键为4个空格
set tabstop=4
set shiftwidth=4
set expandtab

EOF


echo 请手动执行如下命令
echo "source ~/.vimrc" 
#source /root/.vimrc && echo ".vimrc修改完成"

