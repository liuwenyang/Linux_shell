#!/bin/bash
#设置时区为上海
sudo timedatectl set-timezone Asia/Shanghai
#设置时区为美国
#sudo timedatectl set-timezone America/New_York


#nx小站设置时间方法
#关闭时间同步服务,不然会无法使用timedatectl 导致时间回到装机时间
timedatectl set-ntp no 


#调整docker时间
chmod 777 docker-logs-localtime
mv ./docker-logs-localtime /usr/local/bin/docker-logs-localtime
