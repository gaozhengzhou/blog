# JumpServer安装

### 官网
https://jumpserver.readthedocs.io/zh/master/setup_by_fast.html

### 说明
- 全新安装的 Centos7 (7.x)
- 需要连接 互联网
- 使用 root 用户执行

_脚本做了一定的容错, 可以多次执行, 安装完成后请勿再次执行_

### Koko、Guacamole 容器化部署(推荐)
```
$ cd /opt
$ yum -y install wget
$ wget -O /opt/jms_install.sh https://demo.jumpserver.org/download/jms_install.sh
$ sh jms_install.sh

# 后续重启服务器后启动异常, 可以使用下面的命令进行启动
$ systemctl start jms_core  # 注意先启动 jms_core 后再启动其他组件
$ docker start jms_koko
$ docker start jms_guacamole

# 停止
$ docker stop jms_koko
$ docker stop jms_guacamole
$ systemctl stop jms_core  # 注意先结束其他组件最后停止 jms_core

# 查看启动状态
$ systemctl status jms_core
$ docker logs -f jms_koko
$ docker logs -f jms_guacamole
```