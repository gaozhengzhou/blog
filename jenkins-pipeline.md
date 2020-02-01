# Jenkins Pipeline

## 理念
> Pipeline as code

## 依赖
    jenkins
    gitlab
    maven
    nexus
    nodejs
    npm
    yarn
    docker
    kubernetes

## 流程
![img](images/jenkins-pipeline/jenkins-pipeline.png)

## 步骤
### Pipeline Start
Pipeline开始，触发方式如下：
- 手动触发构建
- GitLab的Webhook触发构建
- API触发构建

### Pull Source Code
从GitLab拉取项目源代码

### Rsync Config
`在config统一维护项目的配置文件，维护生产的数据库账密等信息。`
- 从GitLab拉取config项目
- 使用config的文件替换项目源代码的文件

### Maven/Npm/Yarn Build
编译项目

### Build Docker
构建docker镜像

### Push Image
推送docker镜像到阿里云镜像私库

### Deploy
发布最新镜像到k8s

### Pipeline Finish
Pipeline结束



