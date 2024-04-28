#!/bin/bash
if [ $1 == usb ]; then
    sh ./installByUSB.sh 
else
    #部署文件目录
    export deploy_path=/home
    #小脚本文件夹
    export script_path=$deploy_path/auto_truck_script
fi

#装车文件夹
export zc_path="/home/storage/zc"
#项目名称
export project_name=branch
#程序目录
export program_path=$zc_path/$project_name
#自助装车结果图像文件夹
export zizhu_img_path="/home/storage/data/video/img/result"


#清理脚本文件夹
export clearzcfiles_path="/opt/matrix/middleware"
#分发脚本名称
export distribute_script_name="distribute.sh localupdate.sh remoteupdate.sh"
#清理脚本名称
export clear_script_name="clearzcfiles"
#下载的docker日志文件夹
export docker_log_path=$zc_path/docker_log
#微力同步目录
export SYNC_path=$zc_path/SYNC
#配置文件目录
export config_path=$zc_path/config
#分发脚本文件夹
#export distribute_script_path=$zc_path/distribute_script

#创建文件夹
mkdir  -p $zizhu_img_path $clearzcfiles_path $docker_log_path $SYNC_path
echo --------------创建文件夹完成--------------

# mv $distribute_script_name $distribute_script_path
# echo 移动分发脚本完成
#启动U盘部署就将installByUSB=true







bash $script_path/config_lib.sh

bash $script_path/clean_yaml.sh

bash $script_path/config_time.sh

bash $script_path/config_crontab.sh

bash $script_path/run_images.sh

#sh $script_path/run_app.sh
#移除程序编译,使用镜像,程序编译使用代码文件夹内的deploy.sh
# if [ -d "/home/storage/zc/branch/platforms" ]; then
#     $script_path/runApp.sh
# fi
bash $script_path/run_alias_general.sh

bash $script_path/run_alias_car.sh

bash $script_path/run_clearzcfiles.sh

bash $script_path/clean_trash.sh 


sleep 1
date
echo 请手动调整时间和设置ntp服务
echo 主站需配置Ansible和SVN
reboot