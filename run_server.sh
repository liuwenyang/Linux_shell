#!/bin/bash

# 检查是否以 root 权限运行
if [[ $EUID -ne 0 ]]; then
   echo "错误：此脚本需要 root 权限运行"
   echo "请使用: sudo $0"
   exit 1
fi

# 唯一需要改的  定义服务名称和命令
server_name=frpc
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
start_command="$script_dir/$server_name -c $script_dir/frpc.toml"

# 检查可执行文件是否存在
if [[ ! -f "$script_dir/$server_name" ]]; then
    echo "错误：找不到可执行文件 $script_dir/$server_name"
    exit 1
fi

echo 定义服务名称和命令为:
echo $start_command
echo

# 设置安全的文件权限
chmod 755 "$script_dir/$server_name"
if [[ $? -ne 0 ]]; then
    echo "错误：无法设置文件权限"
    exit 1
fi

# 创建 systemd 服务文件
cat << EOF > /etc/systemd/system/$server_name.service
[Unit]
Description=$server_name
After=network-online.target # 等待网络完全就绪后再启动
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=$script_dir
ExecStart=$start_command
Restart=always # 无论什么原因退出都重启
RestartSec=10 # 重启间隔10秒
StartLimitInterval=0 # 取消重启次数限制
StandardOutput=append:$script_dir/$server_name.log
StandardError=append:$script_dir/$server_name.log

[Install]
WantedBy=multi-user.target
EOF

if [[ $? -ne 0 ]]; then
    echo "错误：无法创建服务文件"
    exit 1
fi

# 重新加载 systemd 配置以识别新的服务文件
echo "重新加载 systemd 配置..."
systemctl daemon-reload
if [[ $? -ne 0 ]]; then
    echo "错误：无法重新加载 systemd 配置"
    exit 1
fi

# 启用服务
echo "启用服务..."
systemctl enable $server_name.service
if [[ $? -ne 0 ]]; then
    echo "错误：无法启用服务"
    exit 1
fi

# 启动服务
echo "启动服务..."
systemctl start $server_name.service
if [[ $? -ne 0 ]]; then
    echo "错误：无法启动服务"
    exit 1
fi

# 检查服务
echo 服务为:
cat /etc/systemd/system/$server_name.service
echo

# 检查状态并打印
echo 状态为:
systemctl status $server_name.service --no-pager
echo

echo 开启日志轮转
cat << EOF > /etc/logrotate.d/$server_name
$script_dir/$server_name.log {
    rotate 10
    size 10M
    copytruncate
    missingok
    notifempty
    compress
    delaycompress
    create 644 root root
}
EOF

if [[ $? -ne 0 ]]; then
    echo "警告：无法创建日志轮转配置"
else
    echo "日志轮转配置已创建"
fi

echo "服务 $server_name 配置完成"
