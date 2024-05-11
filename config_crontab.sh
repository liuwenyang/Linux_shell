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
#由于 cron 的工作原理是根据系统时间来调度任务，每次脚本运行后系统时间的这种突增会影响到 cron 的下一次执行计划。

#具体来说，cron 使用系统时间来决定何时执行计划中的任务。如果你的脚本将系统时间快速推进8小时，那么实际上在短时间内系统时间远远超过了原本应该按5分钟间隔进行的计划。例如，如果脚本在某个点执行并将时间从13:00推进到21:00，那么所有在这个时间段内应该执行的 cron 任务（每5分钟一次）都会被触发执行，因为系统认为这些任务的执行时间已经到了
update_time="0 */12 * * * /home/storage/zc/update_time.sh" #每5分钟ntpdate  造成bug 到期执行一次, 系统时间超过crontab计时时间 造成循环 时间就会不停叠加8小时  !!改为大于8小时1校时
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