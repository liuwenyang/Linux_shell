#!/bin/bash

# 定义服务名称和命令
server_name=cloudreve
start_command="$PWD/cloudreve"
cat << EOF > /etc/systemd/system/$server_name.service
[Unit]
Description=$server_name
After=network.target
After=mysqld.service
Wants=network.target

[Service]
WorkingDirectory=$PWD
ExecStart=$start_command
Restart=on-abnormal
RestartSec=5s
KillMode=mixed

StandardOutput=null
StandardError=syslog

[Install]
WantedBy=multi-user.target

EOF
#重新加载 systemd 配置以识别新的服务文件：
systemctl daemon-reload
systemctl enable $server_name.service
systemctl start $server_name.service

#检查服务
cat /etc/systemd/system/$server_name.service
echo

#检查状态并打印
sudo systemctl status $server_name.service | tee /dev/tty

systemctl --no-pager status $server_name.service 

echo