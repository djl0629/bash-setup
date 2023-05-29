#!/bin/bash

# 生成密钥对
ssh-keygen -t rsa -f ~/.ssh/id_rsa -N "" -q

# 发送公钥
while read ip; do
    ssh-copy-id -f -o StrictHostKeyChecking=no $ip

done < hosts