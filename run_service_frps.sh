#!/bin/bash

# 创建一个名为"frp_sever.service"的文件，并写入以下内容：
cat << EOF > /etc/systemd/system/frp_sever.service
# frp server service
[Unit]
Description=FRP Server Service
After=network.target

[Service]
Type=simple
User=root
ExecStart=$PWD/frps -c $PWD/frps.toml
Restart=on-failure

[Install]
WantedBy=multi-user.target

EOF
#重启
systemctl daemon-reload
systemctl enable frp_sever.service
systemctl start frp_sever.service

#检查状态并打印
sudo systemctl status frp_sever.service | tee /dev/tty

systemctl --no-pager status frp_sever.service 

echo