#!/bin/bash

# 开始行标志
start_string="###beginofchenzhen'salias###"
# 结束行标志
end_string="###endofchenzhen'salias###"

# 查找包含起始内容和结束内容的行，并删除这之间的行
start_line=$(grep -n "$start_string" ~/.bashrc | cut -d ':' -f1)
end_line=$(grep -n "$end_string" ~/.bashrc | cut -d ':' -f1)

if  grep -q "$start_string" ~/.bashrc && grep -q "$end_string" ~/.bashrc ; then
   echo ".bashrc被run_alias_general修改过"
   sed -i "/$start_string/,/$end_string/d" ~/.bashrc && echo 清理.bashrc成功
else
   echo ".bashrc未被run_alias_general修改过"
fi
# 打印开始行标志
cat << EOF >> ~/.bashrc
$start_string
EOF

#带''是为了防止打印字符转义
cat << 'EOF' >> ~/.bashrc

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
alias dl='docker logs -tf --tail=500'
alias dr='docker restart'
alias cd='function _ccd(){ cd "$1"; ll -lh; };_ccd'
alias cp='cp -r --remove-destination'
alias bak='/usr/local/bin/bak'
alias czcd='function _czcd(){ cd "$(ls -d ./*/ | sort -r | tail -n +"$1" | head -n 1 | sed "s/\/$//")"; };_czcd'
alias czls='du -sh * | sort -h' 
alias czmod='sudo chmod 777 * && ll'
alias dirnum='ls -l | grep "^d" | wc -l'
export HISTTIMEFORMAT='%F %T '
ping(){
   /bin/ping "$@" | while read pong; do echo "$(now): $pong"; done
}
w2u() {
  # 安全检查: 确保参数不为空
  if [ -z "$1" ]; then
    echo "Usage: W2U <file>"
    return 1
  fi

  # 安全检查: 确保文件存在
  if [ ! -f "$1" ]; then
    echo "Error: File '$1' not found."
    return 1
  fi

  # 安全检查: 确保文件不是二进制文件
  if [ "$(file "$1" --mime | grep -q 'charset=binary'; echo $?)" = "0" ]; then
    echo "Error: Binary file detected, aborting."
    return 1
  fi

  # 使用 sed 命令替换 CR+LF 为 LF
  # 使用 -i'' 选项直接在原文件上操作，没有备份
  # 如果需要备份原文件，可以使用 -i'.bak' 来创建一个备份
  sed -i'' 's/\r$//' "$1"
  
  # 返回操作结果
  if [ $? -eq 0 ]; then
    echo "Windows下的回车到Linux的回车字符完成"
  else
    echo "Error during conversion."
    return 1
  fi
}


shopt -s extglob 


echo 输入mman查看快捷命令
EOF

#打印结束行标志
cat << EOF >> ~/.bashrc
$end_string
EOF
#/usr/local/bin/czexit &
chmod 777 bak mman czexit
mv bak /usr/local/bin
mv mman /usr/local/bin
# mv czexit /usr/local/bin
echo 请手动执行如下命令
echo "source ~/.bashrc" 
source /root/.bashrc && echo ".bashrc修改完成"

