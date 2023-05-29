## bash-setup脚本
---
#### 使用方法
1、修改`hosts`文件，添加需要批量安装的主机地址

`hosts`文件内容示例
```
10.1.1.13
10.1.1.14
```
2、服务器间免密登录（需要手动输入每台主机的root密码）
```bash
./ssh_key_copy.sh
```
3、修改`list`文件，添加需要批量安装的组件

`list`文件内容示例
```
docker
```
目前支持批量安装的组件清单
```
docker # docker以及docker-compose
system # 系统优化
```
目前支持的系统架构
```
x86_64
aarch64
```