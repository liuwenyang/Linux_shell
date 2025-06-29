#!/bin/bash

if [ -z "$clearzcfiles_path" ]; then
  clearzcfiles_path=/home/storage/load/train
fi
if [ -z "$clear_script_name" ]; then
  clear_script_name=clearzcfiles_train
fi

pwd
#如果clearzcfiles_path不存在，创建
if [ ! -d "$clearzcfiles_path" ]; then
  mkdir -p $clearzcfiles_path
fi

#赋权
chmod 777 $clear_script_name.sh
#创建清理脚本文件夹完成
mv $clear_script_name.sh $clearzcfiles_path && echo && echo --------------移动清理脚本完成-------------- && echo


cd $clearzcfiles_path

echo 清理脚本安放目录为$clearzcfiles_path
#chmod 777 $clearzcfiles_path -R 
$clearzcfiles_path/$clear_script_name.sh -s 4
$clearzcfiles_path/$clear_script_name.sh -o 
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

if ! crontab -l | grep  "$clearzcfiles_path/$clear_script_name.sh -o"; then
    # 如果不存在，添加到crontab
    (crontab -l; echo "0 1 * * 1 $clearzcfiles_path/$clear_script_name.sh -o") | crontab -
    echo ""$clearzcfiles_path/$clear_script_name.sh -o"已添加到crontab中"
else
    echo ""$clearzcfiles_path/$clear_script_name.sh -o"这个任务已存在"
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


