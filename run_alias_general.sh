#!/bin/bash

# 开始行标志
start_string="###beginofchenzhen'salias###"
# 结束行标志
end_string="###endofchenzhen'salias###"

# 查找包含起始内容和结束内容的行，并删除这之间的行
start_line=$(grep -n "$start_string" /etc/bashrc | cut -d ':' -f1)
end_line=$(grep -n "$end_string" /etc/bashrc | cut -d ':' -f1)

if  grep -q "$start_string" /etc/bashrc && grep -q "$end_string" /etc/bashrc ; then
   echo "/etc/bashrc被run_alias_general修改过"
   sed -i "/$start_string/,/$end_string/d" /etc/bashrc && echo 清理/etc/bashrc成功
else
   echo "/etc/bashrc未被run_alias_general修改过"
fi
# 打印开始行标志
cat << EOF >> /etc/bashrc
$start_string
EOF

#带''是为了防止打印字符转义
cat << 'EOF' >> /etc/bashrc

alias ll='ls -lhtc --color=auto'
alias ls='ls -A --color=auto'
alias bak="mv $1 $1_($(date +%Y-%m-%dT%H:%M:%S))"
alias .='cd ..'
alias ..='cd ../..'
alias ...='cd ../../..'
alias ....='cd ../../../..'


alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias top='top -d 1'

alias now='date "+%Y-%m-%dT%H:%M:%S"'

alias ds='docker ps -a' 
alias dl='docker logs -f --tail=500'
alias dr='docker restart'
alias cd='function _ccd(){ cd "$1"; ll -lh; };_ccd'
alias cp='cp -r --remove-destination'
alias bak='/usr/local/bin/bak'
alias czcd='function _czcd(){ cd "$(ls -d ./*/ | sort -r | tail -n +"$1" | head -n 1 | sed "s/\/$//")"; };_czcd'
alias czls='du -sh * | sort -h' 
alias czmod='sudo chmod 777 * && ll'
alias dirnum='ls -l | grep "^d" | wc -l'
alias d2u="sed -i 's/\r//' "

export HISTTIMEFORMAT='%F %T '
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
        echo "$(now): $pong"
    done
}



shopt -s extglob 


echo 输入mman查看快捷命令
EOF

#打印结束行标志
cat << EOF >> /etc/bashrc
$end_string
EOF
#/usr/local/bin/czexit &
chmod 777 bak mman czexit
mv bak /usr/local/bin
mv mman /usr/local/bin
# mv czexit /usr/local/bin

echo 请手动执行如下命令
echo "source /etc/bashrc" 
source /etc/bashrc && echo "/etc/bashrc修改完成"

#在/root/.bashrc中添加source /etc/bashrc
if grep -q "source /etc/bashrc" /root/.bashrc; then
   echo "/root/.bashrc被run_alias_general修改过"
else
   echo "/root/.bashrc未被run_alias_general修改过"
   echo "source /etc/bashrc" >> /root/.bashrc
fi
