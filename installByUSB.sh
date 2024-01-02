#!/bin/bash

#部署文件目录
export deploy_path=${PWD}
#export deploy_path=$(dirname ${PWD})
#小脚本文件夹
export script_path=$deploy_path/auto_truck_script
echo 部署路径为$deploy_path
echo 脚本路径为$script_path
sh $script_path/config_ssh.sh

sh $script_path/config_limit.sh

sh $script_path/config_ip.sh
