#!/bin/bash

#火车组快捷路径
alias pcd='cd /home/storage/load/train/data/lidar/pcd' 
alias csv='cd /home/storage/load/train/data/lidar/csv' 
alias yaml='cd /home/storage/load/config' 
alias om='cd /home/storage/load/models' 
alias zc='cd /home/storage/load/client' 
alias cz='cd /home/storage/matrixai/cz/project' 

#快捷操作
alias log-c='logc > $docker_log_path/$(now)_client.log && cd $docker_log_path && ls'
alias log-m='logm > $docker_log_path/$(now)_server.log && cd $docker_log_path && ls'
alias up-y='cp /home/storage/config/yaml/config.yaml /home/storage/config/yaml/config.yaml_$(now) && mv /tmp/config.yaml /home/storage/zc/ ; mv /home/storage/zc/config.yaml /home/storage/config/yaml ; chmod 777 /home/storage/config/yaml/config.yaml && rs-c'
alias 0209='echo -n "8D08200209000000" | xxd -r -p | nc localhost 6669 && echo 读写参数完成'
alias 1402='echo -n "8D08201402000000" | xxd -r -p | nc localhost 6669 && echo 重读车号完成'

#火车组定制化
alias logc="docker logs -f --tail 1000 cli" 
alias logm="docker logs -f --tail 800 ser"
alias rs-c="docker restart cli" 
alias rs-m="docker restart ser" 


