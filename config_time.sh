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


cat << 'EOF' >> /home/storage/zc/update_time.sh
#!/bin/bash
ntpdate 192.168.1.175 >> /home/storage/zc/TimeLog.txt
echo "真实时间:$(date +"%Y-%m-%d %H:%M:%S")" >> /home/storage/zc/TimeLog.txt
now=$(date +%s)
later=$((now + 8*3600))
date_str=$(date -d @$later +"%Y-%m-%d %H:%M:%S")
timedatectl set-ntp no
timedatectl set-time "$date_str"
timedatectl set-local-rtc 0
echo $date_str
echo "偏移时间:$(date +"%Y-%m-%d %H:%M:%S")" >> /home/storage/zc/TimeLog.txt

EOF

chmod +x update_time.sh
