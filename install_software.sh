#!/bin/bash

# 定义一个函数用于检查软件是否已安装并安装未安装的软件
check_and_install() {
    package=$1
    # 改进的检查方法：同时检查dpkg和command
    if ! dpkg -l | grep -q "^ii.*$package" && ! command -v "$package" &> /dev/null; then
        echo "$package 未安装，正在安装..."
        echo
        # 修复：使用sudo权限
        if sudo apt install -y $package; then
            echo "$package 安装成功"
        else
            echo "$package 安装失败，请检查网络连接或软件包名称"
            # 尝试搜索相关包
            echo "正在搜索相关软件包..."
            apt search $package | head -5
            echo "----------------------------------------"
        fi
    else
        echo "$package 已安装，跳过..."
    fi
}

#使用apt安装的软件
# 更新软件包信息
echo "正在更新软件包信息..."
sudo apt-get update -y

# 修正软件包列表（去掉重复的netcat，修正包名）
packages=("ffmpeg" "jq" "vim" "chrony" "apt-offline" "baobab" "ctop" "tree" "rsync" "cgroupfs-mount" "sysstat" "wget" "tmux" "netcat-openbsd" "net-tools" "dos2unix" "lsof" "tcpdump" "traceroute" "p7zip-full" "docker-compose" "valgrind" "ntpdate" "openssh-server" "at" "htop" "curl" "telnet" "vlc" "hardinfo" "git" "subversion" "lm-sensors" )

# 遍历软件列表，检查并安装
for package in "${packages[@]}"; do
    check_and_install $package
done

# 打印安装完成的软件列表
echo "所有请求安装的软件处理完成，列表如下："
for package in "${packages[@]}"; do
    if dpkg -l | grep -q "^ii.*$package" || command -v "$package" &> /dev/null; then
        echo "$package 已安装"
    else
        echo "$package 未安装"
    fi
done

#特殊情况安装包
#sudo snap install vscode --classic
