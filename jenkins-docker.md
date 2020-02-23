# Jenkins安装（Dokcer环境）

## 构建docker镜像
- 下载Dockerfile  
wget https://www.gaozhengzhou.com/jenkins/Dockerfile

- 构建镜像  
docker build --tag=registry-vpc.cn-shenzhen.aliyuncs.com/lhs11/jenkins:latest .

- 推送镜像到仓库  
docker push registry-vpc.cn-shenzhen.aliyuncs.com/lhs11/jenkins:latest

## master节点部署
- 



