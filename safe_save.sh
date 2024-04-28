#!/bin/bash
# 设置保留文件数
saveNum=5

# 设置要处理的文件数组,最后一位是文件
declare -a paths=(
    "/home/storage/config/yaml/config.yaml"
    "/home/storage/models/lidar/alids.engine"
)

# 遍历路径数组
for path in "${paths[@]}"; do
    # 备份文件，包括日期时间戳
    cp $path $path.bak_$(date +%Y-%m-%dT%H:%M:%S)

    # 切换到文件所在目录
    cd $(dirname $path)

    # 获取当前目录下的备份文件总数
    total_files=$(ls -1q $(basename $path).bak_* | wc -l)

    # 计算需要删除的文件数量
    let "files_to_delete = $total_files - $saveNum"

    # 如果文件数量少于或等于要保留的文件数量，则不执行任何操作
    if [ "$files_to_delete" -le 0 ]; then
        echo "没有足够的文件需要删除，退出当前循环。" > save_$(basename $path).log
        continue
    fi

    # 按时间排序，删除最旧的备份文件，只保留最新的指定数量的备份文件
    ls -1t $(basename $path).bak_* | tail -n +$(($saveNum+1)) | xargs -d '\n' rm -v > save_$(basename $path).log

    # 打印完成消息到日志文件
    #echo "删除 $(dirname $path) 下最旧的 $files_to_delete 个文件完成。" > save_$(basename $path).log

    # 切换回原始目录
    cd -
done
