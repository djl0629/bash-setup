#!/bin/bash

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config 
sed -i 's/4096/65535/g' /etc/security/limits.d/*.conf

cat << EOF >> /etc/security/limits.conf
root soft nofile 65535
root hard nofile 65535
* soft nofile 65535
* hard nofile 65535
EOF

sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
