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

ping(){
   /bin/ping "$@" | while read pong; do echo "$(now): $pong"; done
}

echo -e "SSH Login Alert\n\n登录账户: $(whoami)\n登录IP: $(echo $SSH_CONNECTION | awk '{print $1}')\n登录时间: $(TZ="Asia/Shanghai" date "+%H:%M:%S")" | mail -s "阿里云主机 $(hostname) ssh登录提醒 " 你的@qq.com
shopt -s extglob 


