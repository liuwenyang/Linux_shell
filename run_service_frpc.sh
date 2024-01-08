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
ExecStart=$PWD/frpc -c $PWD/frpc.toml
Restart=on-failure

[Install]
WantedBy=multi-user.target

EOF
#重启
systemctl daemon-reload
systemctl enable frp_client.service
systemctl start frp_client.service

#检查状态并打印
sudo systemctl status frp_client.service | tee /dev/tty

systemctl --no-pager status frp_client.service 

echo