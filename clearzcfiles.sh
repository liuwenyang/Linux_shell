#!/bin/bash
if [ ! -f clearzcfiles.conf ]; then
  touch clearzcfiles.conf
fi
if [ ! -f clearzcfiles.log ]; then
  touch clearzcfiles.log
fi
#默认保留天数
savedays=15
#最少保存天数
readonly minsavedays=2
#docker保留行数
readonly savelines=5000000
#脚本路径
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function usage() {
  echo "USAGE: 主动或定时清理自动装车产生的历史文件夹"
  echo "parameter:"
  echo "-z 按照设置的保留的天数或默认的天数主动删除历史文件夹"
  echo "-d 主动清理docker日志，数据全清理"
  echo "-o 定时或主动清理docker日志，数据保留最近500W行"
  echo "-t 设置定时清理文件夹任务，默认每天的一点进行"
  echo "-l 设置定时清理docker日志任务，每周天清理一次，且只保留最近500W行数据做备份"
  echo "-s <days> 设置保留最近指定的天数的文件夹"
  echo "-w 检测服务是否正常，不正常则重新启动"
  echo "-h  参数列表"
  echo "-v  版本号"
}

#清理docker日志
function cleardockerlogs() {
  echo $(date) "开始清理docker日志" >>$DIR"/clearzcfiles.log"
  rootp=$(docker info | grep "Docker Root Dir")
  if [[ $rootp =~ "/var/lib/docker" ]]; then
    logs=$(find /var/lib/docker/containers/ -name *-json.log)
    for log in $logs; do
      echo "clean logs : $log"
      tail -n $savelines $log >$log.bak
      cat /dev/null >$log
    done
  elif [[ $rootp =~ "/home/storage/docker" ]]; then
    logs=$(find /home/storage/docker/containers/ -name *-json.log)
    for log in $logs; do
      echo "clean logs : $log"
      tail -n $savelines $log >$log.bak
      cat /dev/null >$log
    done
  fi
  return 0
}

#清理docker日志
function cleardockerpartlogs() {
  echo $(date) "开始清理docker日志" >>$DIR"/clearzcfiles.log"
  rootp=$(docker info | grep "Docker Root Dir")
  if [[ $rootp =~ "/var/lib/docker" ]]; then
    logs=$(find /var/lib/docker/containers/ -name *-json.log)
    for log in $logs; do
      lines=$(wc -l <$log)
      echo "clean logs : $log,lines : $lines" >>$DIR"/clearzcfiles.log"
      if [ $lines -gt $savelines ]; then
        sl=$(expr $lines - $savelines)
        sed -i "1,${sl}d" $log
      fi
    done
  elif [[ $rootp =~ "/home/storage/docker" ]]; then
    logs=$(find /home/storage/docker/containers/ -name *-json.log)
    for log in $logs; do
      lines=$(wc -l <$log)
      echo "clean logs : $log,lines : $lines" >>$DIR"/clearzcfiles.log"
      if [ $lines -gt $savelines ]; then
        sl=$(expr $lines - $savelines)
        sed -i "1,${sl}d" $log
      fi
    done
  fi
  return 0
}

#读取配置文件中保存的天数
function getsavedays() {
  if [ -f $DIR"/clearzcfiles.conf" ]; then
    local conf=$(cat $DIR"/clearzcfiles.conf" | grep -e '^[0-9]*$')
    if [ ! -z "$conf" ] && [ $conf -ge $minsavedays ]; then
      savedays=$conf
    fi
  fi
  return 0
}

#清理文件夹
function clearfiles() {
  local filepath=$1
  local nums=$(ls -d $filepath | wc -l)
  if [ $nums -gt $savedays ]; then
    clearnums=$(expr $nums - $savedays)
    echo "需要清理"$clearnums"个文件夹"
    local files=$(ls -rtd $filepath | head -n $clearnums)
    echo $files >>$DIR"/clearzcfiles.log"
    rm -rf $files
  fi
  return 0
}

#设置保留天数
function setsavedays() {
  local days=$1
  if [ -z "days" ]; then
    echo "设置失败，保留天数不可为空~"
    return -1
  fi

  expr $days "+" 10 &>/dev/null
  if [ $? -eq 0 ]; then
    echo "设置保留"$days"天的文件~"
  else
    echo "设置失败，保留天数应该输入数字~"
    return -1
  fi

  if [ $days -lt $minsavedays ]; then
    echo "设置失败，保留天数不可少于"$minsavedays"天数"
    return -1
  fi

  echo $days >$DIR"/clearzcfiles.conf"
  savedays=$days
  echo -e "设置\033[1m\033[32m成功\033[0m！"
  return 0
}

#清理文件
function clearhistory() {
  getsavedays
  echo $(date) "开始清理文件" >>$DIR"/clearzcfiles.log"
  echo "开始清理img~"
  clearfiles "/home/storage/data/lidar/img/[2-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]"
  echo "开始清理pcd~"
  clearfiles "/home/storage/data/lidar/pcd/[2-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]"
  echo "开始清理log~"
  clearfiles "/home/storage/data/lidar/log/[2-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]"
  echo "开始清理统一的日志~"
  clearfiles "/home/storage/data/lidar/[2-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]"
  echo "开始清理自助原图片~"
  clearfiles "/home/storage/data/video/img/001/[2-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]"
  clearfiles "/home/storage/data/video/img/002/[2-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]"
  echo "开始清理自助结果图像~"
  clearfiles "/home/storage/data/video/img/result/001/[2-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]"
  clearfiles "/home/storage/data/video/img/result/002/[2-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]"
  echo "开始清理自助日志"
  clearfiles "/home/storage/data/video/[2-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]"
  clearfiles "/home/storage/data/video/[2-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]"
  return 0
}

#启动定时清理文件夹任务
function startclearfilstask() {
  systemctl stop clearzcfiles.timer 2>/dev/null
  echo -e "[Unit]\nDescription=Periodic cleaning zc files\n\n[Timer]\nOnCalendar=*-*-* 01:00:00\nPersistent=true\nRandomizedDelaySec=60\nUnit=clearzcfiles.service\n\n[Install]\nWantedBy=timers.target" >/etc/systemd/system/clearzcfiles.timer
  echo -e "[Unit]\nDescription=Periodic cleaning zc files\n\n[Timer]\nOnCalendar=*-*-* 06:00:00\nPersistent=true\nRandomizedDelaySec=60\nUnit=watchclearzcfiles.service\n\n[Install]\nWantedBy=timers.target" >/etc/systemd/system/watchclearzcfiles.timer
  echo -e "[Unit]\nDescription=Periodic cleaning zc files\n\n[Service]\nExecStart=/bin/bash  "$(pwd)"/clearzcfiles.sh -z\nRestart=on-failure\nRestartSec=10s" >/etc/systemd/system/clearzcfiles.service
  echo -e "[Unit]\nDescription=Periodic cleaning zc files\n\n[Service]\nExecStart=/bin/bash  "$(pwd)"/clearzcfiles.sh -w\nRestart=on-failure\nRestartSec=10s" >/etc/systemd/system/watchclearzcfiles.service
  echo "清理文件夹任务的清理脚本工作文件路径为$(pwd)"
  systemctl start watchclearzcfiles.timer 2>/dev/null
  systemctl enable watchclearzcfiles.timer 2>/dev/null

  systemctl start clearzcfiles.timer 2>/dev/null
  systemctl enable clearzcfiles.timer 2>/dev/null

  local info=$(systemctl status clearzcfiles.timer | grep "Active: active")
  if [[ "$info" != "" ]]; then
    echo -e "启动定时清理文件夹任务\033[1m\033[32m成功\033[0m！"
  else
    echo "启动定时清理文件夹任务失败~"
  fi
}

#启动定时清理docker日志任务
function startcleardockerlogtask() {
  systemctl stop clearzcdockerlogs.timer 2>/dev/null
  echo -e "[Unit]\nDescription=Periodic cleaning zc docker logs\n\n[Timer]\nOnCalendar=Sun *-*-* 02:00:00\nPersistent=true\nRandomizedDelaySec=60\nUnit=clearzcdockerlogs.service\n\n[Install]\nWantedBy=timers.target" >/etc/systemd/system/clearzcdockerlogs.timer
  echo -e "[Unit]\nDescription=Periodic cleaning zc docker logs\n\n[Service]\nExecStart=/bin/bash "$(pwd)"/clearzcfiles.sh -d" >/etc/systemd/system/clearzcdockerlogs.service
  systemctl start clearzcdockerlogs.timer 2>/dev/null
  systemctl enable clearzcdockerlogs.timer 2>/dev/null
  local info=$(systemctl status clearzcdockerlogs.timer | grep "Active: active")
  echo "清理docker日志任务的清理脚本工作文件路径为$(pwd)"
  if [[ "$info" != "" ]]; then
    echo -e "启动定时清理docker日志任务\033[1m\033[32m成功\033[0m！"
  else
    echo "启动定时清理docker日志任务失败~"
  fi
}
#清理观察记录历史时间是否错乱的日志
function clearTimeLog() {
  local file="/home/storage/zc/TimeLog.txt" # The path to the file
  local line_num=60000
  # Check if the file has more than 50000 lines
  line_count=$(wc -l <"$file")

  if [ "$line_count" -gt $line_num ]; then
    # The file has more than 50000 lines, truncate the file to the last 50000 lines
    tail -n $line_num "$file" >"$file.tmp" && mv "$file.tmp" "$file"
  fi

}
#检测服务是否正常
function checkservice() {
  local state=$(systemctl is-failed clearzcdockerlogs.timer)
  if [[ "$state" != "active" ]]; then
    echo -e "检测到清理文件任务失败~！"
    $(pwd)/clearzcfiles.sh -l
  fi

  state=$(systemctl is-failed clearzcdockerlogs.service | grep "active")
  if [[ "$state" != "active" ]]; then
    echo -e "检测到清理文件任务失败~！"
    $(pwd)/clearzcfiles.sh -l
  fi

  state=$(systemctl is-failed clearzcfiles.timer)
  if [[ "$state" != "active" ]]; then
    echo -e "检测到清理文件任务失败~！clearzcfiles.timer"
    $(pwd)/clearzcfiles.sh -t
  fi

  state=$(systemctl is-failed clearzcfiles.service)
  if [[ "$state" != "active" ]]; then
    echo -e "检测到清理文件任务失败~！clearzcfiles.service"
    $(pwd)/clearzcfiles.sh -t
  fi
}

function main() {

  while getopts "dlzos:thvw" arg; do
    case $arg in
    z)
      echo "开始主动清理历史文件夹~"
      clearhistory
      ;;
    s)
      echo "开始设置保留天数~"
      setsavedays $OPTARG
      ;;
    t)
      echo "开始设置定时清理文件夹~"
      startclearfilstask
      ;;
    d)
      echo "开始清理docker日志~"
      cleardockerlogs
      ;;
    l)
      echo "开始设置定时清理docker日志任务~"
      startcleardockerlogtask
      ;;
    o)
      echo "开始清理docker日志~"
      cleardockerpartlogs
      ;;
    w)
      echo "检测服务运行状态~"
      checkservice
      ;;
    h)
      usage
      exit 1
      ;;
    v)
      echo "3.6.31"
      exit 1
      ;;
    time)
      clearTimeLog
      exit 1
      ;;
    ?)
      usage
      exit -2
      ;;
    esac
  done
}

main "$@"
RESULT=$?
exit $RESULT
