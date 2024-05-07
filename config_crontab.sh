#!/bin/bash

if [ -z "$zc_path" ]; then
  zc_path=/home/storage/zc
fi
if [ -z "$deploy_path" ]; then
  deploy_path=/home
fi

script_path=${PWD}


#移动自动保存脚本文件到指定文件夹
mv $script_path/safe_save.sh /home/storage/config/yaml && echo && echo --------------移动备份脚本完成-------------- && echo


######定义cron任务区开始######
#每2周周一凌晨1点自动保存重要文件的脚本
safe_save_cron="0 4 * * 1 /home/storage/config/yaml/safe_save.sh"
#每小时备份yaml的功能, 防止GUI崩溃导致yaml清空
safe_save_yaml="0 * * * * cp /home/storage/config/yaml/config.yaml /home/storage/config/yaml/config.yaml_1h_AutoSave"
#同步系统时间到硬件时间;将硬件时钟调整为与目前的系统时钟一致，每天0点
hwclock_cron="0 0 * * * timedatectl set-local-rtc 0 && hwclock -w && hwclock --systohc"
#每5分钟ntpdate
update_time="*/5 * * * * /home/storage/zc/update_time.sh"
######定义cron任务区结束######






######添加cron任务区开始######
# 检查新任务是否已存在
if ! crontab -l | grep "$safe_save_cron"; then
    # 如果不存在，添加到crontab
    (crontab -l; echo "$safe_save_cron") | crontab -
    echo "每2周周一凌晨4点自动保存重要文件的脚本任务已添加到crontab中"
else
    echo "每2周周一凌晨4点自动保存重要文件的脚本任务已存在"
fi
if ! crontab -l | grep "$hwclock_cron"; then
    # 如果不存在，添加到crontab
    (crontab -l; echo "$hwclock_cron") | crontab -
    echo "同步系统时间到硬件时间;将硬件时钟调整为与目前的系统时钟一致，每天0点"
else
    echo "同步系统时间到硬件时间;将硬件时钟调整为与目前的系统时钟一致，每天0点"
fi
if ! crontab -l | grep "$safe_save_yaml"; then
    # 如果不存在，添加到crontab
    (crontab -l; echo "$safe_save_yaml") | crontab -
    echo "每小时备份yaml的功能"
else
    echo "每小时备份yaml的功能"
fi
if ! crontab -l | grep "$update_time"; then
    # 如果不存在，添加到crontab
    (crontab -l; echo "$update_time") | crontab -
    echo "每5分钟ntpdate"
else
    echo "每5分钟ntpdate"
fi
######添加cron任务区结束######









# 重启cron服务以确保新的任务生效
sudo systemctl restart cron
sudo service cron restart
sudo /etc/init.d/cron restart