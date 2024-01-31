#!/bin/bash

# 创建一个名为"frps.service"的文件，并写入以下内容：
cat << EOF > /etc/systemd/system/frps.service
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
#重新加载 systemd 配置以识别新的服务文件：
systemctl daemon-reload
systemctl enable frps.service
systemctl start frps.service

#检查状态并打印
sudo systemctl status frps.service | tee /dev/tty

systemctl --no-pager status frps.service 

echo