#!/bin/bash


read -p "请输入IP地址：" IP

if [[ $IP =~ ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then
 echo "输入的IP格式合格"
else
 echo "输入的IP格式不合格"
 exit 1
fi

read -p "请输入子网掩码：" SUBNET_MASK

if [[ $SUBNET_MASK =~ ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then
echo "输入的子网掩码格式合格"
else
echo "输入的子网掩码格式不合格"
exit 1
fi

read -p "请输入网关地址：" GATEWAY

if [[ $GATEWAY =~ ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then
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
