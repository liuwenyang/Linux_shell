#!/bin/bash

# 更新系统
sudo apt update && sudo apt upgrade -y

# 安装必要的软件
sudo apt install -y wget mysql-server mysql-client

# 设置MySQL root用户密码
MYSQL_ROOT_PASSWORD='cz' # 修改成你的MySQL root用户密码
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';"

# 创建Zabbix数据库和用户
ZABBIX_DB='zabbix' # Zabbix数据库名
ZABBIX_USER='zabbix' # Zabbix数据库用户
ZABBIX_PASSWORD='cz' # Zabbix数据库密码，可以替换成其他密码

sudo mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "create database ${ZABBIX_DB} character set utf8mb4 collate utf8mb4_bin;"
sudo mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "create user '${ZABBIX_USER}'@'localhost' identified by '${ZABBIX_PASSWORD}';"
sudo mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "grant all privileges on ${ZABBIX_DB}.* to '${ZABBIX_USER}'@'localhost';"
sudo mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "SET GLOBAL log_bin_trust_function_creators = 1;"

# 下载并安装Zabbix
wget https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+bionic_all.deb
sudo dpkg -i zabbix-release_5.0-1+bionic_all.deb
sudo apt update

# 安装Zabbix server, frontend, agent
sudo apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-agent

# 导入初始模式和数据
sudo zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p${ZABBIX_PASSWORD} ${ZABBIX_DB}

# 更新Zabbix server配置
sudo sed -i "s/# DBPassword=/DBPassword=${ZABBIX_PASSWORD}/" /etc/zabbix/zabbix_server.conf

#安装语言包，例如，如果您想要安装中文支持
sudo apt install language-pack-zh-hans

# 重启Zabbix server和agent服务
sudo systemctl restart zabbix-server zabbix-agent apache2
sudo systemctl enable zabbix-server zabbix-agent apache2

echo "Zabbix installation has been completed!"
