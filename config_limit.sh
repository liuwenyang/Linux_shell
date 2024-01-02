#!/bin/bash
# 解除服务器资源限制

# 检查文件是否存在
if [ ! -f /etc/security/limits.conf ]; then
    echo "错误: /etc/security/limits.conf 文件不存在"
    exit 1
fi

# 找到要删除的行
line_num=$(grep -n 'nvidia hard stack 1024' /etc/security/limits.conf | cut -d ':' -f 1)

# 如果找到了要删除的行，就删除该行及其之后的所有行
if [ -n "$line_num" ]; then
  sed -i "${line_num},\$d" /etc/security/limits.conf
  echo "已删除 /etc/security/limits.conf 中的 'nvidia hard stack 1024' 行及其之后的所有行"
else
  echo "未找到 /etc/security/limits.conf 中的 'nvidia hard stack 1024' 行"
fi
#添加新文本
cat << EOF >> /etc/security/limits.conf
nvidia hard stack 8192
nvidia soft stack 8192
ubuntu hard stack 8192
ubuntu soft stack 8192
root hard stack 8192
root soft stack 8192
soft nofile 65535
hard nofile 65535
EOF
echo "/etc/security/limits.conf文件已修改"
