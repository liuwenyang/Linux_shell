#!/bin/bash
if [ -z "$deploy_path" ]; then
    deploy_path=/home
fi
#yaml路径
yaml_path=/home/storage/config/yaml/config.yaml
cp $yaml_path $yaml_path.bak_$(date +%Y-%m-%dT%H:%M:%S) && echo --------------备份旧yaml完成--------------


#清理cube立方体
sed -i 's/center: \[-*[0-9.]\+,\s\(-*[0-9.]\+\),\s\(-*[0-9.]\+\),\s\(-*[0-9.]\+\),\s\(-*[0-9.]\+\),\s\(-*[0-9.]\+\)\]/center: [-22,-22,-22,22,22,22]/g' /home/storage/config/yaml/config.yaml
#清理雷达
sed -i 's/param_ground: \[-*[0-9.]\+,\s\(-*[0-9.]\+\),\s\(-*[0-9.]\+\),\s\(-*[0-9.]\+\),\s\(-*[0-9.]\+\),\s\(-*[0-9.]\+\)\]/param_ground: [-20.000000,-20.000000,-20.000000,20.000000,20.000000,20.000000]/g' /home/storage/config/yaml/config.yaml
sed -i 's/param_tf: \[\(-*[0-9.]\+,\s\)\{15\}-*[0-9.]\+\]/param_tf: [1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1]/g' /home/storage/config/yaml/config.yaml
sed -i 's/param_pcl_step: -*[0-9]/param_pcl_step: 0/g' /home/storage/config/yaml/config.yaml
sed -i 's/param_thetaz: -*[0-9]/param_thetaz: 0/g' /home/storage/config/yaml/config.yaml
sed -i 's/param_thetaz: -*[0-9]/lidar_type: 0/g' /home/storage/config/yaml/config.yaml
#置为0号雷达
sed -i 's/lidar_type: -*[0-9]/lidar_type: 0/g' /home/storage/config/yaml/config.yaml
#置为调试参数
sed -i 's/type_run: -*[0-9]/type_run: 0/g' /home/storage/config/yaml/config.yaml
#清理模型名称

#默认是Y方向投影生成IMG用来识别 type_shadow = 0 投影方式 0 Y方向投影  1 Z方向投影
echo --------------清理yaml参数完成--------------

#再Windows下副站粘贴到hosts文件的回车和Linux不是一种字符,格式转换,非常重要
sed -i 's/\r$//' $yaml_path