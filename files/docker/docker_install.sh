#!/bin/bash

arch=$(uname -m)
cd /tmp/yscredit/setup/docker
if [ "$arch" = "x86_64" ]; then
    echo "当前系统架构为x86_64"

    tar zxvf docker-24.0.2-x86_64.tgz -C /tmp/yscredit/setup/docker

    cp docker-compose-linux-x86_64 /usr/bin/docker-compose

elif [ "$arch" = "aarch64" ]; then
    echo "当前系统架构为aarch64"

    tar zxvf docker-24.0.2-aarch64.tgz -C /tmp/yscredit/setup/docker

    cp docker-compose-linux-aarch64 /usr/bin/docker-compose
    
else
    echo "ERROR:未知架构"
    exit 1
fi

chown -R root:root docker/*
cp docker/* /usr/bin

cp docker.service /usr/lib/systemd/system/
cp docker.socket /usr/lib/systemd/system/
cp containerd.service /usr/lib/systemd/system/
chmod 0755 /usr/lib/systemd/system/docker.service
chmod 0755 /usr/lib/systemd/system/docker.socket
chmod 0755 /usr/lib/systemd/system/containerd.service

mkdir -p /etc/docker
cp daemon.json.j2 /etc/docker/daemon.json
chmod 0644 /etc/docker/daemon.json

chmod 0755 /usr/bin/docker-compose

groupadd docker
systemctl daemon-reload
systemctl restart docker
systemctl enable docker

rm -rf /tmp/yscredit/setup/docker