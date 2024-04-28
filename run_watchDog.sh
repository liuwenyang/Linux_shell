#!/bin/bash
server_name="gpu_usage"
# 设置日志文件路径
LOGFILE="$PWD/$server_name.log"

# 设置间隔时间
INTERVAL=1

while true
do
    echo "Timestamp: $(date)" >> "$LOGFILE"
    nvidia-smi >> "$LOGFILE"
    sleep $INTERVAL
done > /dev/null 2>&1 # Redirect both stdout and stderr to /dev/null

echo "开启日志轮转"
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
    postrotate
        /usr/bin/find $PWD -name "$server_name.log.*.gz" -mtime +30 -exec rm -f {} \;
    endscript
}
EOF
