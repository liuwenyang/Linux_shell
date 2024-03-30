#!/bin/bash

#被替换文件路径
file_path=/home/storage/config/yaml/config.yaml
cp $file_path $file_path.bak_$(date +%Y-%m-%dT%H:%M:%S) && echo --------------备份旧文件完成--------------



#置为调试参数
sed -i 's/\/home\/storage\/models\/lidar\/HN_24_03_22.engine/\/home\/storage\/models\/lidar\/HN_24_03_26.engine/g' $file_path
#清理模型名称


#再Windows下副站粘贴到hosts文件的回车和Linux不是一种字符,格式转换,非常重要
sed -i 's/\r$//' $file_path