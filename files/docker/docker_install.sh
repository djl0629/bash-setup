#!/bin/bash

arch=$(uname -m)
cd /tmp/yscredit/setup/docker
if [ "$arch" = "x86_64" ]; then
    echo "当前系统架构为x86_64"

    tar zxcf docker-20.10.0_x86.tgz -C /tmp/yscredit/setup/docker

    cp docker-compose-x86 /usr/bin/docker-compose

elif [ "$arch" = "aarch64" ]; then
    echo "当前系统架构为aarch64"

    tar zxcf docker-20.10.0_arm.tgz -C /tmp/yscredit/setup/docker

    cp docker-compose-aarch64 /usr/bin/docker-compose
    
else
    echo "ERROR:未知架构"
    exit 1
fi

chown -R root:root docker/*
cp docker/* /usr/bin

mkdir -p /etc/docker
cp docker.service /etc/systemd/system/
chmod 0755 /etc/systemd/system/docker.service

cp daemon.json.j2 /etc/docker/daemon.json
chmod 0644 /etc/docker/daemon.json

chmod 0755 /usr/bin/docker-compose

systemctl reload docker
systemctl restart docker

rm -rf /tmp/yscredit/setup/docker