#!/bin/bash

# 备份原有的interfaces文件
cp /etc/network/interfaces /etc/network/interfaces.backup
# 清理原eth0
sed -i '/auto eth0/,+4d' /etc/network/interfaces


read -p "请输入IP地址：" IP

if [[ $IP =~ ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then
 echo "输入的IP格式合格"
else
 echo "输入的IP格式不合格"
 exit 1
fi

# 预设的子网掩码前两个八位组
PRESET_SUBNET="255.255."

# 提示用户输入剩余的部分
read -p "请输入子网掩码：$PRESET_SUBNET" INPUT

# 完整的子网掩码
FULL_SUBNET_MASK="$PRESET_SUBNET$INPUT"

# 正则表达式验证子网掩码格式
if [[ $FULL_SUBNET_MASK =~ ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then
    echo "输入的子网掩码格式合格"
else
    echo "输入的子网掩码格式不合格"
    exit 1
fi

# 提取IP地址的前三个八位组作为默认网关的前缀
GATEWAY_PREFIX=$(echo $IP | cut -d '.' -f 1,2,3)

# 提示用户输入网关地址的最后一部分
read -p "请输入网关地址：$GATEWAY_PREFIX." GATEWAY_LAST_OCTET

# 完整的网关地址
FULL_GATEWAY="$GATEWAY_PREFIX.$GATEWAY_LAST_OCTET"

# 验证网关地址格式
if [[ $FULL_GATEWAY =~ ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then
 echo "输入的网关格式合格"
else
 echo "输入的网关格式不合格"
 exit 1
fi



cat << EOF >> /etc/network/interfaces
auto eth0
iface eth0 inet static
address $IP
netmask $SUBNET_MASK
gateway $GATEWAY
EOF

echo "配置网卡信息为"
cat /etc/network/interfaces
echo

service networking restart 
