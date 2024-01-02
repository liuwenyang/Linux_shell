#!/bin/bash
if [ -z "$zc_path" ]; then
  zc_path=/home/storage/zc
fi
if [ -z "$deploy_path" ]; then
  deploy_path=/home
fi
if [ -z "$clearzcfiles_path" ]; then
  clearzcfiles_path="/opt/matrix/middleware"
fi
script_path=$deploy_path/auto_truck_script




######定义cron任务区开始######
#每2周周一凌晨1点自动保存重要文件的脚本
safe_save_cron="0 4 * * 1 root $clearzcfiles_path/safe_save.sh"
#同步系统时间到硬件时间;将硬件时钟调整为与目前的系统时钟一致，每天0点
hwclock_cron="0 0 * * * root timedatectl set-local-rtc 0 && hwclock -s"


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
######添加cron任务区结束######









# 重启cron服务以确保新的任务生效
sudo systemctl restart cron
sudo service cron restart
sudo /etc/init.d/cron restart