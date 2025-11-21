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
export HISTTIMEFORMAT='%F %T '
alias d2u="sed -i 's/\r//' "

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

echo -e "SSH Login Alert\n\n登录账户: $(whoami)\n登录IP: $(echo $SSH_CONNECTION | awk '{print $1}')\n登录时间: $(TZ="Asia/Shanghai" date "+%Y-%m-%d %H:%M:%S")" | mail -s "阿里云主机 $(hostname) ssh登录提醒 " 你的@qq.com
shopt -s extglob
