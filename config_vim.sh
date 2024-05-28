#!/bin/bash


#带''是为了防止打印字符转义
cat << 'EOF' >> ~/.vimrc
set number "显示行号"
set ruler"显示当前光标位置"

EOF


#echo 请手动执行如下命令
#echo "source ~/.vimrc" 
#source /root/.vimrc && echo ".vimrc修改完成"

