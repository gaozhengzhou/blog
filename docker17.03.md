# Docker17.03安装
- 安装epel源  
```
yum install epel-release -y
```
  
- 安装常用工具
```
yum install -y wget curl telnet bash-completion net-tools nmap htop yum-utils dstat
```
   
- 下载docker安装包  
```
wget https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-17.03.0.ce-1.el7.centos.x86_64.rpm
wget https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-selinux-17.03.0.ce-1.el7.centos.noarch.rpm
```
    
- 安装docker包  
```
yum localinstall -y docker-ce-17.03.0.ce-1.el7.centos.x86_64.rpm  docker-ce-selinux-17.03.0.ce-1.el7.centos.noarch.rpm
```
    
- 设置容器加速器和容器日志上限
```
mkdir -p /etc/docker
cat <<EOF >/etc/docker/daemon.json
{
    "registry-mirrors": ["https://220mqk4t.mirror.aliyuncs.com"],
    "bip": "172.17.10.1/24",
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "100m"
    }
}
EOF
```
  
- 启动服务  
```
systemctl enable docker.service && systemctl start docker.service
```