#!/bin/bash
# 清理文件
# 开启通配符
shopt -s extglob
rm -rf /home/!(nvidia|storage|config.yaml|app*) && echo --------------清理文件完成--------------
# if [ $(basename "${PWD}") == "auto_truck_script" ]; then
#   deploy_path=$(dirname "${PWD}")
# fi
# cd $deploy_path
# # 待删除的文件和文件夹数组
# files_to_delete=("client.tar" "dataview.tar" "server.tar" "auto_truck_script" "lib2.zip" "lib.zip" "include2.zip" "include.zip" "bin.zip" "matrix.yaml" "share.zip" "nx_sq.tar.gz")

# # 遍历数组
# for item in "${files_to_delete[@]}"; do

#   if [ -f "$item" ]; then
#     echo "删除文件：$item"
#     rm "$item"
#   elif [ -d "${item%.zip}" ]; then
#     echo "文件夹：${item%.zip}"
#     echo "删除文件夹：${item%.zip}"
#     rm -rf "${item%.zip}"
#   else
#     echo "$item 不存在"
#   fi
# done
