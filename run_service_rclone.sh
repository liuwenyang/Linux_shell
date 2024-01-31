#!/bin/bash

# 定义服务名称和命令
server_name="rclone-webdav"
start_command="/usr/bin/rclone serve webdav /home/dav --addr :50006"

# 创建systemd服务文件
cat << EOF > /etc/systemd/system/$server_name.service
[Unit]
Description=Rclone $server_name service
After=network.target
Wants=network.target

[Service]
ExecStart=$start_command
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

# 重新加载 systemd 配置以识别新的服务文件
systemctl daemon-reload

# 启用服务
systemctl enable $server_name

# 启动服务
systemctl start $server_name

# 检查服务状态
systemctl status $server_name
