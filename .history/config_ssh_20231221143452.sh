#!/bin/bash

# 检查文件是否存在

function sshd_config()
{
    # 移除注释并修改 Port
    sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config
    if [ -z "$(grep 'Port 22' /etc/ssh/sshd_config)" ]; then
        echo "修改ssh端口失败"
    else
        echo "修改ssh端口成功"
    fi
    #grep '^Port 22$' /etc/ssh/sshd_config
    # 修改 PermitRootLogin
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
    if [ -z "$(grep 'PermitRootLogin yes' /etc/ssh/sshd_config)" ]; then
        echo "修改PermitRootLogin失败"
    else
        echo "修改PermitRootLogin成功"
        systemctl restart ssh
        echo 已重启ssh服务
    fi
    #grep '^PermitRootLogin $' /etc/ssh/sshd_config

}

if [ -f "/etc/ssh/sshd_config" ]; then
    sshd_config
else
    echo "/etc/ssh/sshd_config 文件不存在"
    echo 是否安装openssh-server
    read -p "y/n: " is_install
    if [ "$is_install" = "y" ]; then
        sudo apt-get install openssh-server
    else
        exit 1
    fi
    sshd_config
fi