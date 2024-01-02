#!/bin/bash
#清理文件
shopt -s extglob
rm -rf /home/!(nvidia|storage|config.yaml|app*) && echo --------------清理文件完成-------------- 