## docker run -d --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock -v /usr/bin/docker:/usr/bin/docker jenkins/jenkins:lts-centos /bin/bash
## http://mirrors.jenkins-ci.org/status.html
## https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json
## https://www.jianshu.com/p/0aef1cc27d3d
## https://www.cnblogs.com/lvcisco/p/12030494.html
## https://blog.51cto.com/14143894/2465983?source=dra
FROM jenkins/jenkins:lts-centos
USER root

# create directory
RUN mkdir -p /data/jenkins/credentials/docker; \
    mkdir -p /data/jenkins/credentials/kube; \
    mkdir -p /data/jenkins/credentials/maven; \
    mkdir -p /data/jenkins/credentials/ssh; \
    mkdir -p /data/jenkins/repository; \
    mkdir -p /data/jenkins/home;

# install docker dependency libtool
RUN yum install -y epel-release; \
        yum install -y libtool-ltdl;

# install maven git curl wget redis etc.
RUN yum install -y maven git curl wget redis;

# install python3
RUN yum install -y python3; \
        ln -s /usr/bin/python3 /usr/bin/python; \
        ln -s /usr/bin/pip3 /usr/bin/pip;

# install nodejs
RUN yum install -y nodejs; \
        npm install -g cnpm --registry=https://registry.npm.taobao.org; \
        npm config set registry https://registry.npm.taobao.org/;

# install yarn
RUN curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo |  tee /etc/yum.repos.d/yarn.repo; \
        yum install -y yarn; \
        yarn config set registry https://registry.npm.taobao.org/;

# install kubectl
RUN curl --silent --location https://www.gaozhengzhou.com/kubernetes/kubernetes.repo |  tee /etc/yum.repos.d/kubernetes.repo; \
        yum install -y kubectl;

# install jenkins jnlp agent
RUN wget https://www.gaozhengzhou.com/jenkins/agent/agent.jar -O /usr/share/jenkins/agent.jar; \
        wget https://www.gaozhengzhou.com/jenkins/agent/jenkins-agent -O /usr/local/bin/jenkins-agent; \
        chmod +x /usr/local/bin/jenkins-agent;

# git-ssh
RUN wget https://www.gaozhengzhou.com/git/git-ssh.sh -O /usr/local/bin/git-ssh.sh; \
        chmod +x /usr/local/bin/git-ssh.sh;

# ssh client
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config;

# timezone
RUN set -eux; \
        ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
        echo "Asia/Shanghai" > /etc/timezone;

# env
ENV JENKINS_UC=https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates
ENV JENKINS_UC_EXPERIMENTAL=https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/experimental
ENV JENKINS_HOME=/data/jenkins/home
ENV CREDENTIALS_HOME=/data/jenkins/credentials
ENV REPOSITORY_HOME=/data/jenkins/repository
ENV DOCKER_CREDENTIALS_HOME=${CREDENTIALS_HOME}/docker
ENV KUBE_CREDENTIALS_HOME=${CREDENTIALS_HOME}/kube
ENV MAVEN_CREDENTIALS_HOME=${CREDENTIALS_HOME}/maven
ENV SSH_CREDENTIALS_HOME=${CREDENTIALS_HOME}/ssh
ENV GIT_SSH=/usr/local/bin/git-ssh.sh
ENV GIT_KEYFILE=${SSH_CREDENTIALS_HOME}/id_rsa

