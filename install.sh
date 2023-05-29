#!/bin/bash

list=$1

# 检查是否指定安装清单
if [ $# -eq 0 ]; then
    echo "ERROR:Please specify the installation list"
    exit 1
fi

# 检查文件是否存在
if [ ! -f "$list" ]
then
    echo "ERROR:file $list does not exist"
    exit 1
fi

# 添加脚本执行权限
find . -type f -name "*.sh" -exec chmod +x {} \;

# 创建数组
mapfile -t ip_pool < hosts
mapfile -t item_pool < $list

# 创建临时工作目录
for address in "${ip_pool[@]}"
do
    ssh $address "/bin/bash -c 'mkdir -p /tmp/yscredit/setup'"
done

# 遍历安装清单并执行安装脚本
for item in "${item_pool[@]}"
do

    if [ ! -f files/$item/$item\_install.sh ]
    then
        echo ERROR:file files/$item/$item\_install.sh does not exist
        exit 1
    else
        for address in "${ip_pool[@]}"
        do
            echo "INFO:当前正在对主机 $address 安装 $item"
            scp -r files/$item $address:/tmp/yscredit/setup/
            ssh $address "/bin/bash /tmp/yscredit/setup/$item/*_install.sh"
        done
        echo "$item install done"
    fi

done
