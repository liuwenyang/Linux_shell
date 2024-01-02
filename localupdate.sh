#!/bin/bash
function usage()
{
  echo "USAGE: 更新此小站上的服务"
  echo "parameter:"
  echo "-c  将新client应用放到脚本目录下，更新、备份并重启客户端容器"
  echo "-m  将新main应用放到脚本目录下，更新、备份并重启服务端容器"
  echo "-a  将新alids.om放到脚本目录下，更新、备份原alids.om,并重启服务端容器"
  echo "-e  将新alids.engine放到脚本目录下，更新、备份原alids.engine,并重启服务端容器"
  echo "-r <filename>  更新客户端镜像，需要客户端容器运行中，备份原镜像并重启客户端容器"
  echo "-g <filename>  更新服务端镜像，需要服务端容器运行中，备份原镜像并重启服务端容器"
  echo "-d  清理docker日志"
  echo "-n  设置npu共享模式，确定在docker服务启动之前进行设置"
  echo "-h  参数列表"
  echo "-v  版本号"
}

#更新服务端
function simpleupdatemain()
{
   if [ ! -f "main" ];then
	  echo "main文件不存在~"
      return -1
   fi
   chmod 755 main
   chown 1001:1001 main
   mid=$(docker ps | awk 'BEGIN{FS=" "} $3 ~/main/ {print $1}')
   docker cp ${mid}:/app/main ./main_last
   docker cp main ${mid}:/app/
   docker restart ${mid}
   return 0
}

#更新客户端
function simpleupdateclient()
{
   if [ ! -f "client" ];then
      echo "client文件不存在~"
	  return -1
   fi
   chmod 755 client
   chown 1001:1001 client
   cid=$(docker ps | awk 'BEGIN{FS=" "} $3 ~/client/ {print $1}')
   docker cp ${cid}:/app/client ./client_last
   docker cp client ${cid}:/app/
   docker restart ${cid}
   return 0
}

#更新模型
function updatemodel()
{
  if [ ! -f "alids.om" ];then
    echo "alids.om文件不存在~"
	return -1
  fi
  chmod 755 alids.om 
  chown 1001:1001 alids.om 
  cp /home/storage/models/lidar/alids.om /home/storage/models/lidar/alids_last.om
  cp alids.om /home/storage/models/lidar/
  mid=$(docker ps | awk 'BEGIN{FS=" "} $3 ~/main/ {print $1}')
  docker restart ${mid}
  return 0
}

function updateengine()
{
  if [ ! -f "alids.engine" ];then
    echo "alids.engine文件不存在~"
	return -1
  fi
  chmod 755 alids.engine 
  chown 1001:1001 alids.engine 
  cp /home/storage/models/lidar/alids.engine /home/storage/models/lidar/alids_last.engine
  cp alids.engine /home/storage/models/lidar/
  mid=$(docker ps | awk 'BEGIN{FS=" "} $3 ~/main/ {print $1}')
  docker restart ${mid}
  return 0
}

function setnpushare()
{
  if [ $os != 0 ];then
	echo "不是华为小站，不需要设置！"
	return -1
  fi
  echo -e "[Unit]\nDescription=set npu share \nBefore=docker.service \n\n[Service]\nType=oneshot\nRemainAfterExit=True\nExecStart=/bin/bash -c \"echo Y|npu-smi set -t device-share -i 0 -c 0 -d 1\"\n\n[Install]\nWantedBy=multi-user.target" > /etc/systemd/system/npushare.service
  systemctl enable npushare.service 2>/dev/null
  local info=$(systemctl status npushare.service | grep "Active: active")
  if [[ "$info" != "" ]]
  then
    echo -e "设置npu共享\033[1m\033[32m成功\033[0m!"
  else
    echo "设置npu共享任务失败~"
  fi
}

#清理docker日志
function cleardockerlogs()
{
  rootp=$(docker info | grep "Docker Root Dir")

  if [[ $rootp =~ "/var/lib/docker" ]] ;then 
    logs=$(find /var/lib/docker/containers/ -name *-json.log)  
    for log in $logs  
      do  
        echo "clean logs : $log"  
        cat /dev/null > $log  
      done  
  elif [[ $rootp =~ "/home/storage/docker" ]] ;then
    logs=$(find /home/storage/docker/containers/ -name *-json.log)
    for log in $logs  
      do  
        echo "clean logs : $log"  
        cat /dev/null > $log  
      done  
  fi
  return 0
}

function updateimage()
{
  if [ ! -f $1 ];then
    echo $1 "文件不存在~"
	return -1
  fi
  ctype=$2
  #查找镜像
  cid=$(docker ps | awk 'BEGIN{FS=" "} $3 ~/'"$ctype"'/ {print $1}')
  echo $cid
  if test -z "$cid" ;then
	echo "没有运行的容器~"
	return -1
  fi
 
  #备份原镜像
  cname=$(docker ps | awk 'BEGIN{FS=" "} $3 ~/'"$ctype"'/ {print $2}')
  docker save -o ${cname}_last.tar ${cname}
  echo "停止容器运行~"
  #docker stop $cid
  docker rm $cid -f
  
  docker rmi ${cname}
  nname=$(docker load -i $1 | awk 'BEGIN{FS=": "}  {print $2}')
  if [ $os == 0 ];then
     docker run --device=/dev/davinci0 --device=/dev/davinci_manager --device=/dev/hisi_hdc --device /dev/devmm_svm --net=host -v /home/storage:/home/storage:rw --restart=on-failure -itd ${nname}
  else
     docker run --net=host --runtime nvidia -v /home/storage:/home/storage:rw --restart=on-failure -itd ${nname}
  fi
  echo $2 "成功~"
  return 0
}

#升级客户端镜像
function updateclientimage()
{
  updateimage $1 client
  result=$?
  return $result
}

#升级服务端镜像
function updatemainimage()
{
  updateimage $1 main
  result=$?
  return $result
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


function main()
{
  while getopts "cmaednr:g:hv" arg
    do
    case $arg in
     c)  echo "开始升级client~"
	     simpleupdateclient
         ;;
     m)  echo "开始升级service~"
	     simpleupdatemain
         ;;
     a)  echo "开始升级alids.om~"
	     updatemodel
         ;;
     e)  echo "开始升级alids.engine~"
		 updateengine
		 ;;
     d)  echo "开始清理docker日志~"
	     cleardockerlogs
         ;;
     r)  echo "开始升级client镜像~"
	     echo "镜像文件:" "$OPTARG"
         updateclientimage $OPTARG
		 ;;
     g)  echo "开始升级service镜像~"
	     echo "镜像文件:" "$OPTARG"
         updatemainimage $OPTARG 
		 ;;
	 n)  echo "开始设置npu共享~"
         setnpushare
		 ;;
     h)
	   usage
       exit 1
       ;;
	 v)
	   echo "3.4.13"
	   exit 1
       ;;
     ?)
	   exit -2
    ;;
  esac
  done
}

getos
main "$@"
RESULT=$?
exit $RESULT