#!/bin/bash
#!/bin/bash

#检查是否有脚本名称输入
if [[ $# -eq 0 ]] ; then
echo '需要输入脚本名称~'
exit -1
fi

#读取通道配置
if [ ! -f "./channels.conf" ];then
  echo "channels.conf文件不存在"
  exit -1
fi

c=0
for line in `cat channels.conf`
do
  array=(${line//,/ })
   if test ${#array[@]} -eq 3
	  then
        channels[$c]=${array[0]}
        loginpwds[$c]=${array[1]}
	    adminpwds[$c]=${array[2]}
        ((c++))
       else
        echo "配置文件channels.conf有误，请检测！"
        exit 1
    fi
done

function checkresult()
{
  if [ $1 != 0 ];then
    echo $1 $2 "失败，请检查失败原因~"
    exit -1
  else
	echo $2 "成功~"
  fi
}

function enablesftp()
{
#sftp 有时会被关闭，这里默认每次都会打开
sshpass -p $2 ssh  -p 22 admin@$1 > /dev/null 2>&1  << cccccc
sftp enable
exit
exit
cccccc
checkresult $? "检查sftp打开"

#/tmp/data 目录读写权限检查
sshpass -p $2 ssh  -p 22 admin@$1 > /dev/null 2>&1  << dddddd
develop
$3
power=$(ll /tmp | awk  'BEGIN{FS=" "} $9 ~ /^data$/ {print $1}')
if [ $"power" != "drwxrwxrwx" ] ;then
chmod 777 /tmp/data
fi
exit
exit
dddddd
checkresult $? "/tmp/data 目录权限检查"
}

function enablenxsftp()
{
#/tmp/data 目录读写权限检查
sshpass -p $2 ssh  -p 22 root@$1 > /dev/null 2>&1  << dddddd
if [ ! -d "/tmp/data" ]; then
    mkdir -p /tmp/data
fi
power=$(ll /tmp | awk  'BEGIN{FS=" "} $9 ~ /^data$/ {print $1}')
if [ $"power" != "drwxrwxrwx" ] ;then
chmod 777 /tmp/data
fi
exit
exit
dddddd
checkresult $? "/tmp/data 目录权限检查"
}

#分发脚本
function distributenxscript()
{
sshpass -p $3 sftp  root@$1 >  /dev/null 2>&1 << dddddd
put $2 /tmp/data/
exit
exit
dddddd
checkresult $? "传输脚本"

sshpass -p $3 ssh  -p 22 root@$1  > /dev/null 2>&1 << cccccc
cd ~/
if [ ! -d "/home/storage/zc" ]; then
    mkdir -p /home/storage/zc
fi
cd /home/storage/zc
mv /tmp/data/$2 ./
chmod +x $2
exit
exit
cccccc
checkresult $? "脚本赋权"
}

#分发脚本
function distributescript()
{
sshpass -p $3 sftp  admin@$1 >  /dev/null 2>&1 << dddddd
put $2 ./data/
exit
exit
dddddd
checkresult $? "传输脚本"

sshpass -p $3 ssh  -p 22 admin@$1  > /dev/null 2>&1 << cccccc
develop
$4
cd ~/
if [ ! -d "/home/storage/zc" ]; then
    mkdir -p /home/storage/zc
fi
cd /home/storage/zc
mv /tmp/data/$2 ./
chmod +x $2
exit
exit
cccccc
checkresult $? "脚本赋权"
}

function init()
{
local rootname="admin"
if [ $os != 0 ];then
 rootname="root"
fi
sftp  $rootname@$1 >  /dev/null 2>&1 << dddddd
ls
exit
exit
dddddd
checkresult $? "初始化连接"
}

#获取系统版本，0-atlas,1-nx
os=0
function getos()
{
 echo "获取系统版本~"
 local eulertag="euler"
 local osversion=$(cat /proc/version)
 if [[ $osversion =~ $eulertag ]]
 then
  os=0
 else
  os=1
 fi
}

getos
#分发脚本到其他机器上
for(( i=0;i<${#channels[@]};i++)) do
	echo "开始分发到通道:" ${channels[i]}
	if [ "${1}" = "init" ];then
		init ${channels[i]}		
	else
	  if [ $os != 0 ];then
	    enablenxsftp ${channels[i]} ${loginpwds[i]} ${adminpwds[i]}
		distributenxscript ${channels[i]} $1 ${loginpwds[i]} ${adminpwds[i]}  
	  else
	    enablesftp ${channels[i]} ${loginpwds[i]} ${adminpwds[i]}
		distributescript ${channels[i]} $1 ${loginpwds[i]} ${adminpwds[i]}  
	  fi
		
	fi
done;