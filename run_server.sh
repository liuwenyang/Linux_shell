#!/bin/bash

# 唯一需要改的  定义服务名称和命令
server_name=frpc
start_command="$PWD/$server_name -c $PWD/frpc.toml"


echo 定义服务名称和命令为:
echo $start_command
echo

#start_command="$PWD/$server_name"
chmod 777 $PWD/$server_name
cat << EOF > /etc/systemd/system/$server_name.service
[Unit]
Description=$server_name
After=network.target
Wants=network.target

[Service]
WorkingDirectory=$PWD
ExecStart=$start_command
Restart=on-failure


StandardOutput=append:$PWD/$server_name.log
StandardError=append:$PWD/$server_name.log

[Install]
WantedBy=multi-user.target

EOF
#重新加载 systemd 配置以识别新的服务文件：
systemctl daemon-reload
systemctl enable $server_name.service
systemctl start $server_name.service

#检查服务
echo 服务为:
cat /etc/systemd/system/$server_name.service
echo

#检查状态并打印
echo 状态为:
sudo systemctl status $server_name.service | tee /dev/tty

systemctl --no-pager status $server_name.service 

echo

echo 开启日志轮转
cat << EOF > /etc/logrotate.d/$server_name
$PWD/$server_name.log {
    rotate 10
    size 10M
    copytruncate
    missingok
    notifempty
    compress
    delaycompress
    create 640 root adm
}


EOF