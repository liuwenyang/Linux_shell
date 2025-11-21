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
start_string="###beginofchenzhen'salias_truck###"
# 结束行标志
end_string="###endofchenzhen'salias_truck###"

# 查找包含起始内容和结束内容的行，并删除这之间的行
start_line=$(grep -n "$start_string" /etc/bashrc | cut -d ':' -f1)
end_line=$(grep -n "$end_string" /etc/bashrc | cut -d ':' -f1)

if  grep -q "$start_string" /etc/bashrc && grep -q "$end_string" /etc/bashrc ; then
   echo ".bashrc被alias_car修改过"
   sed -i "/$start_string/,/$end_string/d" /etc/bashrc && echo 清理.bashrc成功
else
   echo ".bashrc未alias_car被修改过"
fi

# 打印开始行标志
cat << EOF >> /etc/bashrc
$start_string
EOF

cat << EOF >> /etc/bashrc
#汽车组快捷路径
alias pcd='cd /home/storage/data/lidar/' 
alias img='cd /home/storage/data/video/img/result/001' 
alias yaml='cd /home/storage/config/yaml' 
alias om='cd /home/storage/models/lidar' 
alias zc='cd /home/storage/zc' 

EOF
#带''是为了防止打印字符转义
cat << 'EOF' >> /etc/bashrc

alias log-c='logc > $docker_log_path/$(now)_client.log && cd $docker_log_path && ls'
alias log-m='logm > $docker_log_path/$(now)_server.log && cd $docker_log_path && ls'
alias up-y='cp /home/storage/config/yaml/config.yaml /home/storage/config/yaml/config.yaml_$(now) && mv /tmp/config.yaml /home/storage/zc/ ; mv /home/storage/zc/config.yaml /home/storage/config/yaml ; chmod 777 /home/storage/config/yaml/config.yaml && rs-c'

#nx小站转换识别模型的环境变量
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


# 智能ping函数 - 根据系统和shell自动选择路径
ping(){
    local ping_cmd
    # 根据系统和shell选择ping路径
    if [[ "$OSTYPE" == "darwin"* ]] && [[ "$SHELL" == */zsh ]]; then
        # Mac系统使用zsh时，使用/sbin/ping
        ping_cmd="/sbin/ping"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac系统使用bash时，也使用/sbin/ping
        ping_cmd="/sbin/ping"
    else
        # Linux系统或bash环境，使用/bin/ping
        ping_cmd="/bin/ping"
    fi
    
    # 检查ping命令是否存在
    if ! command -v "$ping_cmd" &> /dev/null; then
        ping_cmd="ping"
        if ! command -v "$ping_cmd" &> /dev/null; then
            echo "错误: 系统中找不到 ping 命令"
            return 1
        fi
    fi
    
    # 执行ping命令并添加时间戳
    "$ping_cmd" "$@" | while read -r pong; do
        echo "$(date '+%Y-%m-%dT%H:%M:%S'): $pong"
    done
}

cd /home/storage/zc/

EOF

#打印结束行标志
cat << EOF >> /etc/bashrc
$end_string
EOF
# chmod 777 docker-logs-localtime
# mv docker-logs-localtime /usr/local/bin
source /etc/bashrc && echo ".bashrc修改完成"

echo 请手动执行如下命令
echo "source /etc/bashrc"
