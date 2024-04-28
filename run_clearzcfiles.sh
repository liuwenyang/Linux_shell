#!/bin/bash

if [ -z "$clearzcfiles_path" ]; then
  clearzcfiles_path=/opt/matrix/middleware
fi
if [ -z "$clear_script_name" ]; then
  clear_script_name=clearzcfiles
fi
if [ -z "$deploy_path" ]; then
  deploy_path=/home
fi
script_path=$deploy_path/auto_truck_script

cd $script_path
pwd
mkdir -p $clearzcfiles_path
#创建清理脚本文件夹完成
mv $clear_script_name* $clearzcfiles_path && echo && echo --------------移动清理脚本完成-------------- && echo


cd $clearzcfiles_path

echo 清理脚本安放目录为${PWD}
chmod 777 $clearzcfiles_path -R 
$clearzcfiles_path/$clear_script_name.sh -s 15
$clearzcfiles_path/$clear_script_name.sh -l 
$clearzcfiles_path/$clear_script_name.sh -t

sudo systemctl start clearzcfiles.service
sudo systemctl start watchclearzcfiles.service
sudo systemctl start clearzcdockerlogs.service
(sudo systemctl status clearzcfiles.service | tee /dev/tty && \
 sudo systemctl status watchclearzcfiles.service | tee /dev/tty && \
 sudo systemctl status clearzcdockerlogs.service | tee /dev/tty)

$clearzcfiles_path/$clear_script_name.sh -w
#检测清理脚本运行状态
echo 检测清理脚本运行状态
echo clearzcfiles.service为
systemctl --no-pager status clearzcfiles.service 

echo
echo
#启用crontab定时

if ! crontab -l | grep  "$clearzcfiles_path/$clear_script_name.sh -d"; then
    # 如果不存在，添加到crontab
    (crontab -l; echo "0 1 * * 1 $clearzcfiles_path/$clear_script_name.sh -d") | crontab -
    echo ""$clearzcfiles_path/$clear_script_name.sh -d"已添加到crontab中"
else
    echo ""$clearzcfiles_path/$clear_script_name.sh -d"这个任务已存在"
fi
if ! crontab -l | grep  "$clearzcfiles_path/$clear_script_name.sh -z"; then
    # 如果不存在，添加到crontab
    (crontab -l; echo "0 2 * * 1 $clearzcfiles_path/$clear_script_name.sh -z") | crontab -
    echo ""$clearzcfiles_path/$clear_script_name.sh -z"已添加到crontab中"
else
    echo ""$clearzcfiles_path/$clear_script_name.sh -z"这个任务已存在"
fi
if ! crontab -l | grep  "$clearzcfiles_path/$clear_script_name.sh -w"; then
    # 如果不存在，添加到crontab
    (crontab -l; echo "0 3 * * 1 $clearzcfiles_path/$clear_script_name.sh -w") | crontab -
    echo ""$clearzcfiles_path/$clear_script_name.sh -w"已添加到crontab中"
else
    echo ""$clearzcfiles_path/$clear_script_name.sh -w"这个任务已存在"
fi
if ! crontab -l | grep  "$clearzcfiles_path/$clear_script_name.sh -time"; then
    # 如果不存在，添加到crontab
    (crontab -l; echo "0 4 * * 1 $clearzcfiles_path/$clear_script_name.sh -time") | crontab -
    echo ""$clearzcfiles_path/$clear_script_name.sh -time"已添加到crontab中"
else
    echo ""$clearzcfiles_path/$clear_script_name.sh -time"这个任务已存在"
fi
# 重启cron服务以确保新的任务生效
sudo systemctl restart cron

# 重启systemd服务以确保新的服务生效
systemctl daemon-reload

systemctl enable clearzcfiles.service
systemctl enable watchclearzcfiles.service

systemctl start clearzcfiles.service
systemctl start watchclearzcfiles.service




cd -
kill -INT $$


