#!/bin/bash
if [ -z "$program_path" ]; then
  program_path=/home/storage/zc/app
fi
if [ -z "$deploy_path" ]; then
  deploy_path=/home
fi
if [ ! -d $program_path ]; then
    mkdir -p $program_path
    echo "已创建 app 文件夹"
else
    echo "app 文件夹已存在"
fi

#客户端文件夹路径名字
client_path=client
#服务端文件夹路径名字
server_path=service
#客户端容器名字
client_container=cli
#服务端容器名字
server_container=ser
#nx服务端docker run 命令
server_docker_run="docker run --net=host --runtime nvidia -v /home/storage:/home/storage:rw -v /etc/timezone:/etc/timezone:ro -v /etc/localtime:/etc/localtime:ro --restart=on-failure --name=$server_container -itd server"

#nx客户端docker run 命令
client_docker_run="docker run --net=host -v /home/storage:/home/storage:rw -v /etc/timezone:/etc/timezone:ro -v /etc/localtime:/etc/localtime:ro --restart always --name=$client_container -itd client"
cd $deploy_path
pwd
if [ -f server.tar ]; then
    chmod 777 server.tar
    docker load -i server.tar
    echo "已加载server.tar"
    docker images
    $server_docker_run
    docker ps
else
    echo "无server.tar"
    #编译服务端程序
    unzip $deploy_path/app.zip -d $program_path
    rm $program_path/$server_path/build/CMakeCahce.txt 
    chmod 777 $program_path/$server_path/build.sh
    $program_path/$server_path/build.sh nx
    #移动main文件
    cp -p $program_path/$server_path/dist/main $program_path/$server_path/docker/nx/dist/

    #生成服务端镜像
    chmod 777 $program_path/$server_path/docker/nx -R
    docker build -t $server_container.tar $program_path/$server_path/docker
    chmod 777 $program_path/$server_path/docker/nx -R
    #运行服务端镜像
    docker images
    $server_docker_run
    docker ps
fi
if [ -f client.tar ]; then
    chmod 777 client.tar
    docker load -i client.tar
    echo "已加载client.tar"
    docker images
    $client_docker_run  
    docker ps
else
    echo "无client.tar"
    #编译客户端程序
    #清理CMakelists.txt
    rm -rf $program_path/$client_path/build/CMakeCache.txt
    chmod 777 $program_path/$client_path/build.sh
    $program_path/$client_path/build.sh nx

    #移动client文件夹
    cp -R $program_path/$client_path/client  $program_path/$client_path/docker/nx

    #生成客户端镜像
    chmod 777 $program_path/$client_path/docker/nx/client -R
    docker build -t $client_container.tar $program_path/$client_path/docker/nx
    #运行客户端镜像
    docker images
    $client_docker_run
    docker ps
fi

