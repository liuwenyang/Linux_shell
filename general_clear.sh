#!/bin/bash
# 设置保留文件夹数
saveNum=15

# 设置要处理的文件夹数组
declare -a paths=(
    
    "/home/storage/load/train/data/lidar/pcd"
)
<<'COMMENT'
"/home/storage/load/train/data/lidar/csv"
csv历史日志被我移除掉了 因为占空间不大而且比较有用
COMMENT

# 遍历路径数组
for path in "${paths[@]}"; do

    # 切换到文件所在目录
    cd $path

    # 获取当前目录下的符合 2024-07-02 格式的文件夹的总数
    total_files=$(ls -l | grep '^d' | grep -E '[2-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]' | wc -l)

    # 计算需要删除的文件夹数量
    let "files_to_delete = $total_files - $saveNum"

    # 如果文件数量少于或等于要保留的文件数量，则不执行任何操作
    if [ "$files_to_delete" -le 0 ]; then
        echo "没有足够的文件需要删除，退出当前循环。" > clear.log
        continue
    fi

    
    # 列出符合日期格式的目录，并按日期排序
    oldest_dir=$(ls -dt [2-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/ | tail -n $files_to_delete)

    # 按时间排序，删除最旧的文件夹
    rm -rf $oldest_dir

    # 打印完成消息到日志文件
    echo "删除 $oldest_dir 完成。" > clear.log

    # 切换回原始目录
    cd -
done
