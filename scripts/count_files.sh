#!/bin/bash

# 获取输入参数作为根文件夹
root_folder="$1"

# 检查是否提供了根文件夹参数
if [ -z "$root_folder" ]; then
    echo "请提供根文件夹路径作为参数。Please provide a root folder path as an argument."
    exit 1
fi

# 遍历根文件夹下的所有文件夹
for folder in "$root_folder"/*; do
    if [ -d "$folder" ]; then
        # 获取文件夹名称
        folder_name=$(basename "$folder")
        
        # 统计文件夹下文件的数量
        file_count=$(find "$folder" -type f | wc -l)
        
        # 输出文件夹名称和文件数量
        echo "文件夹 $folder_name 中的文件数量为: $file_count"
    fi
done
