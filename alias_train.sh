
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

alias 0001='docker exec -it capture sh -c "echo '0001' > /dev/stdin" && sleep 2 && echo "输入如下命令进入日志保存文件夹获取日志" && echo "cd  /home/storage/capture"'
alias cap1='echo "start" > /home/storage/capture/start.txt && echo "输入如下命令进入日志保存文件夹获取日志" && echo "cd /home/storage/capture" && echo "等待十秒左右即可缓存完视频 即可下载"'
#火车组定制化功能
alias logc="docker logs -f --tail 1000 cli | grep -E '车坑|归零|溜槽|配煤|从关到位变成开|流速|检测到|发送定量仓闸板开指令|检测到两个闸板同时开|车头装车,溜槽下压; 当前位置|9181\] 车节号:|溜槽提升至安全高度|当前装车高度:|上一节高度|匹配到均值:|溜槽提升|probability'" 
alias logm="docker logs -f --tail 800 ser"
alias rs-c="docker restart cli" 
alias rs-m="docker restart ser"
alias rs-cm="docker restart ser && docker restart cli"  
alias g0='clear && docker logs --tail=2000 cli > /home/zeroPoint.log && docker exec -it tools python zeroPoint.py'
alias 1p='clear && docker logs --tail=2000 cli > /home/onePoint-V21.log && docker exec -it tools python onePoint-V21-5.py'
alias 2p='clear && docker logs --tail=2000 cli > /home/onePoint-V22.log && docker exec -it tools python onePoint-V22-6.5.py'
alias up-c='mv client /home/storage/load/client/client && chmod 777 /home/storage/load/client/client && docker cp cli:/app/client /home/storage/load/client/client_last && docker cp /home/storage/load/client/client cli:/app/client && docker restart cli'
alias up-m='mv main /home/storage/load/server/main && chmod 777 /home/storage/load/server/main && docker cp ser:/app/main /home/storage/load/server/main_last && docker cp /home/storage/load/server/main ser:/app/main && docker restart ser'

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

zc
