#!/bin/bash

# 创建一个名为"frpc.service"的文件，并写入以下内容：
cat << EOF > /etc/systemd/system/frpc.service
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
#重新加载 systemd 配置以识别新的服务文件：
systemctl daemon-reload
systemctl enable frpc.service
systemctl start frpc.service

#检查状态并打印
sudo systemctl status frpc.service | tee /dev/tty

systemctl --no-pager status frpc.service 

echo