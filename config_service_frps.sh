#!/bin/bash

# 创建一个名为"frp_client.service"的文件，并写入以下内容：
cat << EOF > /etc/systemd/system/frp_client.service
# frp client service
[Unit]
Description=FRP Client Service
After=network.target

[Service]
Type=simple
User=root
ExecStart=/home/cz/frp_0.52.3_linux_arm64/frps -c /home/cz/frp_0.52.3_linux_arm64/frps.toml
Restart=on-failure

[Install]
WantedBy=multi-user.target

EOF
systemctl daemon-reload
systemctl enable frp_client.service
systemctl start frp_client.service