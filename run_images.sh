#!/bin/bash
if [ -z "$deploy_path" ]; then
    deploy_path=/home
fi
#nx服务端docker run 命令

#nx客户端docker run 命令

cd $deploy_path
pwd
echo "开始加载镜像..."
cd $deploy_path
pwd
chmod 777 *
#加载镜像
for image in ubuntu tensorrt dataview server client; do
    if [ "$image" == "$(docker images | awk 'BEGIN{FS=" "} $1 ~/'"$image"'/ {print $1}')" ]; then
        echo "加载镜像 $image.tar 已存在"
        continue
    fi
    docker load -i $image.tar && echo "加载镜像 $image.tar 完成" || echo "加载镜像 $image.tar 失败"
done
docker images
#运性镜像
#~/client/和~/c/都能删筛选出来,要做全字匹配
if [ -z "$(docker ps | awk 'BEGIN{FS=" "} $3 ~/main/ {print $1}')" ]; then
    docker run --net=host --runtime nvidia -v /home/storage:/home/storage:rw -v /etc/localtime:/etc/localtime:ro --restart always --name=ser -itd server && echo "-----ser容器加载完成--------"
fi
if [ -z "$(docker ps | awk 'BEGIN{FS=" "} $3 ~/client/ {print $1}')" ]; then
    docker run --net=host -v /home/storage:/home/storage:rw -v /etc/localtime:/etc/localtime:ro --restart always --name=cli -itd client && echo "-----cli容器加载完成--------"
fi
if [ -z "$(docker ps | awk 'BEGIN{FS=" "} $3 ~/dataview/ {print $1}')" ]; then
    docker run --net=host -v /home/storage:/home/storage:rw -v /etc/localtime:/etc/localtime:ro --restart always --name=dataview -itd dataview && echo "-----dataview容器加载完成--------"
fi

docker ps
