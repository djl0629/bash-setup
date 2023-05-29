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

# 创建临时工作目录
while read address; do
    ssh $address "/bin/bash -c 'mkdir -p /tmp/yscredit/setup'"
done < hosts

# 创建ip池
mapfile -t ip_pool < hosts

# 遍历安装清单并执行安装脚本
while read item; do

    if [ ! -f files/$item/$item\_install.sh ]
    then
        echo ERROR:file files/$item/$item\_install.sh does not exist
        exit 1
    else
        for address in "${ip_pool[@]}"
        do
            scp -r files/$item $address:/tmp/yscredit/setup/
            ssh $address "/bin/bash /tmp/yscredit/setup/$item/$item_install.sh"
        done
        echo "$item install done"
    fi

done < $list