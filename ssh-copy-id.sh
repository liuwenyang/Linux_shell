#!/bin/bash

# 设置SSH登录的密码
password="matrixai@2"
hosts_file="hosts"
# 检查是否存在SSH公钥，如果不存在则生成
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
fi

# 检查是否存在目标文件
if [ ! -f "$hosts_file" ]; then
    echo "hosts文件不存在或无法访问"
    exit 1
fi
#再Windows下副站粘贴到hosts文件的回车和Linux不是一种字符,格式转换,非常重要
sed -i 's/\r$//' $hosts_file
#检测是否安装了sshpass
if [ ! -x "$(command -v sshpass)" ]; then
    # echo "sshpass未安装"
    # echo "请使用以下命令安装sshpass"
    # echo "sudo apt-get install sshpass"
    # exit 2
    echo "sshpass未安装，正在安装..."
    sudo apt-get install sshpass
    echo "sshpass安装完成"
fi
# 逐行读取hosts文件并检查是否为IP格式
while IFS= read -r line || [[ -n "$line" ]]; do
    # 使用正则表达式检查每行是否是IP地址
    if [[ $line =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        #echo "IP地址: $line"
        echo "正在分发SSH公钥到 $line"

        # 使用ssh-copy-id分发SSH公钥，自动回答yes和输入密码
        sshpass -p "$password" ssh-copy-id -o StrictHostKeyChecking=no "$line" &>/dev/null
        if [ $? -eq 0 ]; then
            echo "成功分发SSH公钥到 $line"
            echo
        else
            echo "分发SSH公钥到 $line 失败"
            echo
        fi
    # else
    #     echo "不符合IP地址格式的行: $line"
    fi 
done < "$hosts_file"
