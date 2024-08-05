#!/bin/bash

# 开始行标志
start_string="###beginofchenzhen'salias_train###"
# 结束行标志
end_string="###endofchenzhen'salias_train###"

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
#火车组快捷路径
alias pcd='cd /home/storage/load/train/data/lidar/pcd' 
alias csv='cd /home/storage/load/train/data/lidar/csv' 
alias yaml='cd /home/storage/load/config' 
alias om='cd /home/storage/load/models' 
alias zc='cd /home/storage/load/client' 
alias cz='cd /home/storage/matrixai/cz/project' 
alias dlc='cd /home/storage/load/dlc/'
alias cap='cd /home/storage/capture'

#快捷点位
alias 0209='echo -n "8D08200209000000" | xxd -r -p | nc localhost 6669 && echo 加载通用参数完成'
alias 0401='echo -n "8D08200401000000" | xxd -r -p | nc localhost 6669 && echo 测试读PLC配煤量,掐煤量,车节号完成'
alias 1402='echo -n "8D08201402000000" | xxd -r -p | nc localhost 6669 && echo 读车号 完成'
alias 1404='echo -n "8D08201404000000" | xxd -r -p | nc localhost 6669 && echo 读车号 写plc 完成'
alias 302='echo -n "8D08200403020000" | xxd -r -p | nc localhost 6669 && echo 装车完成之后  重新读plc装车数据 发送给web完成'
alias 0001='echo -n "0001" | xxd -r -p | nc localhost 12345'

#火车组定制化功能
alias logc="docker logs -f --tail 1000 cli | grep -E '车坑|归零|溜槽|配煤|从关到位变成开|检测到|发送定量仓闸板开指令|检测到两个闸板同时开|车头装车,溜槽下压; 当前位置|9181\] 车节号:|溜槽提升至安全高度|当前装车高度:|上一节高度|匹配到均值:|溜槽提升|probability'" 
alias logm="docker logs -f --tail 800 ser"
alias rs-c="docker restart cli" 
alias rs-m="docker restart ser"
alias rs-cm="docker restart ser && docker restart cli"  
alias g0='clear && docker logs --tail=1000 cli > /home/zeroPoint.log && python3 /home/zeroPoint.py'
alias 1p='clear && docker logs --tail=1000 cli > /home/onePoint-V21.log && python3 /home/onePoint-V21-5.py'
alias 2p='clear && docker logs --tail=1000 cli > /home/onePoint-V22.log && python3 /home/onePoint-V22-6.5.py'
alias up-c='mv client /home/storage/load/client/client && chmod 777 /home/storage/load/client/client && docker cp cli:/app/client /home/storage/load/client/client_last && docker cp /home/storage/load/client/client cli:/app/client && docker restart cli'
alias up-m='mv main /home/storage/load/server/main && chmod 777 /home/storage/load/server/main && docker cp ser:/app/main /home/storage/load/server/main_last && docker cp /home/storage/load/server/main ser:/app/main && docker restart ser'
zc

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
