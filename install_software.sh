#!/bin/bash

# 定义一个函数用于检查软件是否已安装并安装未安装的软件
check_and_install() {
    package=$1
    if ! dpkg -l | grep -qw $package; then
        echo "$package 未安装，正在安装..."
        echo
        #sudo apt-get install -y $package
        apt install -y $package
    else
        echo "$package 已安装，跳过..."
    fi
}

#使用apt安装的软件
# 更新软件包信息
echo "正在更新软件包信息..."
sudo apt-get update -y

# 定义需要检查的软件列表
packages=("vim" "chrony" "apt-offline" "baobab" "ctop" "tree" "cgroupfs-mount" "sysstat" "wget" "tmux" "netcat" "net-tools" "dos2unix" "lsof" "tcpdump" "traceroute" "p7zip-full" "docker-compose" "ntpdate" "openssh-server" "at" "netcat" "htop" "curl" "telnet" "vlc" "hardinfo" "git" "subversion" "lm-sensors" )

# 遍历软件列表，检查并安装
for package in "${packages[@]}"; do
    check_and_install $package
done

# 打印安装完成的软件列表
echo "所有请求安装的软件处理完成，列表如下："
for package in "${packages[@]}"; do
    if ! dpkg -l | grep -qw $package; then
        echo "$package 未安装"
    else
        echo "$package 已安装"
    fi
done

#特殊情况安装包
#sudo snap install vscode --classic