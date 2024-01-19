#!/bin/bash

# 创建一个名为"cloudreve.service"的文件，并写入以下内容：
cat << EOF > /etc/systemd/system/cloudreve.service
[Unit]
Description=Cloudreve
Documentation=https://docs.cloudreve.org
After=network.target
After=mysqld.service
Wants=network.target

[Service]
WorkingDirectory=$PWD
ExecStart=$PWD/cloudreve
Restart=on-abnormal
RestartSec=5s
KillMode=mixed

StandardOutput=null
StandardError=syslog

[Install]
WantedBy=multi-user.target

EOF
#重启
systemctl daemon-reload
systemctl enable cloudreve.service
systemctl start cloudreve.service

#检查状态并打印
sudo systemctl status cloudreve.service | tee /dev/tty

systemctl --no-pager status cloudreve.service 

echo