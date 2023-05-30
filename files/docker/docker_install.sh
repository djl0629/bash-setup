#!/bin/bash

arch=$(uname -m)
cd /tmp/yscredit/setup/docker
if [ "$arch" = "x86_64" ]; then
    echo "当前系统架构为x86_64"

    rm -rf ./*aarch64*
    mv -f docker-compose-linux-x86_64 /usr/bin/docker-compose

    # 如果系统没有预装tar则使用unzip解压
    if ! command -v tar &> /dev/null; then
        rm -rf ./*tgz
        unzip docker-20.10.0-x86_64.zip
    else
        rm -rf ./*zip
        tar zxvf docker-20.10.0-x86_64.tgz -C /tmp/yscredit/setup/docker
    fi

elif [ "$arch" = "aarch64" ]; then
    echo "当前系统架构为aarch64"

    rm -rf ./*x86_64*
    mv -f docker-compose-linux-aarch64 /usr/bin/docker-compose

    # 如果系统没有预装tar则使用unzip解压
    if ! command -v tar &> /dev/null; then
        rm -rf ./*tgz
        unzip docker-20.10.0-aarch64.zip
    else
        rm -rf ./*zip
        tar zxvf docker-20.10.0-aarch64.tgz -C /tmp/yscredit/setup/docker
    fi

else
    echo "ERROR:未知架构"
    exit 1
fi

chown -R root:root docker/*
chmod 0755 docker/*
mv -f docker/* /usr/bin

mv -f docker.service /usr/lib/systemd/system/
mv -f docker.socket /usr/lib/systemd/system/
chmod 0755 /usr/lib/systemd/system/docker.service
chmod 0755 /usr/lib/systemd/system/docker.socket

mkdir -p /etc/docker
mv -f daemon.json.j2 /etc/docker/daemon.json
chmod 0644 /etc/docker/daemon.json

chmod 0755 /usr/bin/docker-compose

groupadd docker
systemctl daemon-reload
systemctl restart docker
systemctl enable docker

rm -rf /tmp/yscredit/setup/docker