#!/bin/bash

#火车组快捷路径
alias pcd='cd /home/storage/load/train/data/lidar/pcd' 
alias csv='cd /home/storage/load/train/data/lidar/csv' 
alias yaml='cd /home/storage/load/config' 
alias om='cd /home/storage/load/models' 
alias zc='cd /home/storage/load/client' 


#快捷操作
alias log-c='logc > $docker_log_path/$(now)_client.log && cd $docker_log_path && ls'
alias log-m='logm > $docker_log_path/$(now)_server.log && cd $docker_log_path && ls'
alias up-y='cp /home/storage/config/yaml/config.yaml /home/storage/config/yaml/config.yaml_$(now) && mv /tmp/config.yaml /home/storage/zc/ ; mv /home/storage/zc/config.yaml /home/storage/config/yaml ; chmod 777 /home/storage/config/yaml/config.yaml && rs-c'



#火车组定制化
alias logc="docker logs -f --tail 1000 cli" 
alias logm="docker logs -f --tail 800 ser"
alias rs-c="docker restart cli" 
alias rs-m="docker restart ser" 


