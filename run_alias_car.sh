#!/bin/bash
if [ -z "$program_path" ]; then
  program_path=/home/storage/zc/branch
fi
if [ -z "$distribute_script_path" ]; then
  distribute_script_path=/home/storage/zc/distribute_script
fi
# if [ -z "$docker_log_path" ]; then
#   docker_log_path=/home/storage/zc/docker_log
# fi
if [ -z "$$zc_path" ]; then
  zc_path=/home/storage/zc
fi

# 开始行标志
start_string="###beginofchenzhen'salias_car###"
# 结束行标志
end_string="###endofchenzhen'salias_car###"

# 查找包含起始内容和结束内容的行，并删除这之间的行
start_line=$(grep -n "$start_string" ~/.bashrc | cut -d ':' -f1)
end_line=$(grep -n "$end_string" ~/.bashrc | cut -d ':' -f1)

if  grep -q "$start_string" ~/.bashrc && grep -q "$end_string" ~/.bashrc ; then
   echo ".bashrc被alias_car修改过"
   sed -i "/$start_string/,/$end_string/d" ~/.bashrc && echo 清理.bashrc成功
else
   echo ".bashrc未alias_car被修改过"
fi

# 打印开始行标志
cat << EOF >> ~/.bashrc
$start_string
EOF

cat << EOF >> ~/.bashrc
#汽车组快捷路径
alias pcd='cd /home/storage/data/lidar/' 
alias img='cd /home/storage/data/video/img/result/001' 
alias yaml='cd /home/storage/config/yaml' 
alias om='cd /home/storage/models/lidar' 
alias zc='cd /home/storage/zc' 
#华为小站适用
alias up-c='cd $distribute_script_path && mv /tmp/client . && ./localupdate.sh -c'
alias up-m='cd $distribute_script_pathh && mv /tmp/main . && ./localupdate.sh -m'
alias up-a='cd $distribute_script_path && mv /tmp/*.om . && ./localupdate.sh -a'

#nx小站适用的up-c
alias up-lc="cd $program_path && svn update && echo --------svn更新完成-------- && echo && echo --------开始编译-------- && cd client && chmod 777 build.sh && ./build.sh nx && mv /home/storage/zc/branch/client/client/client $distribute_script_path && cd $distribute_script_path && ./localupdate.sh -c"
alias up-lm='cd $program_path && svn update && echo --------svn更新完成-------- && echo && echo --------开始编译-------- && cd service && chmod 777 build.sh && ./build.sh nx && mv /home/storage/zc/branch/service/dist/main $distribute_script_path && cd $distribute_script_path && ./localupdate.sh -m'


EOF
#带''是为了防止打印字符转义
cat << 'EOF' >> ~/.bashrc

alias log-c='logc > $docker_log_path/$(now)_client.log && cd $docker_log_path && ls'
alias log-m='logm > $docker_log_path/$(now)_server.log && cd $docker_log_path && ls'
alias up-y='cp /home/storage/config/yaml/config.yaml /home/storage/config/yaml/config.yaml_$(now) && mv /tmp/config.yaml /home/storage/zc/ ; mv /home/storage/zc/config.yaml /home/storage/config/yaml ; chmod 777 /home/storage/config/yaml/config.yaml && rs-c'

#小站转换识别模型的环境变量
export PATH=/usr/local/cuda-10.2/bin:$PATH
export PATH=$PATH:/opt/cmake-3.24.1/bin
export PATH=/usr/src/tensorrt/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-10.2/lib64:$LD_LIBRARY_PATH

#快捷操作

#汽车组定制化
alias logc="docker logs -tf --tail 1000 $(docker ps | awk 'BEGIN{FS=" "} $3 ~/client/ {print $1}')" 
alias logm="docker logs -tf --tail 800  $(docker ps | awk 'BEGIN{FS=" "} $3 ~/main/ {print $1}')"
alias rs-c="docker restart $(docker ps | awk 'BEGIN{FS=" "} $3 ~/client/ {print $1}')" 
alias rs-m="docker restart $(docker ps | awk 'BEGIN{FS=" "} $3 ~/main/ {print $1}')" 
alias rs-cm="docker restart $(docker ps | awk 'BEGIN{FS=" "} $3 ~/client/ {print $1}') $(docker ps | awk 'BEGIN{FS=" "} $3 ~/main/ {print $1}')" 


cd /home/storage/zc/

EOF

#打印结束行标志
cat << EOF >> ~/.bashrc
$end_string
EOF
# chmod 777 docker-logs-localtime
# mv docker-logs-localtime /usr/local/bin
source ~/.bashrc && echo ".bashrc修改完成"

echo 请手动执行如下命令
echo "source ~/.bashrc" 
