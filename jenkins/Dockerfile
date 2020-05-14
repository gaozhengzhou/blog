## https://www.gaozhengzhou.com/#/jenkins
FROM jenkins/jenkins:2.182-centos
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
RUN yum install -y maven git curl wget redis rsync;

# install python3
RUN yum install -y python3; \
        ln -s /usr/bin/python3 /usr/bin/python; \
        ln -s /usr/bin/pip3 /usr/bin/pip;

# install nodejs
RUN wget https://nodejs.org/dist/v12.16.3/node-v12.16.3-linux-x64.tar.xz -O /node-v12.16.3-linux-x64.tar.xz; \
		tar xvf node-v12.16.3-linux-x64.tar.xz;
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/node-v12.16.3-linux-x64/bin"
RUN  npm install -g cnpm --registry=https://registry.npm.taobao.org; \
        npm config set registry https://registry.npm.taobao.org/;

# install yarn
RUN cnpm install yarn -g; \
        yarn config set registry https://registry.npm.taobao.org/;


# install kubectl
RUN curl --silent --location https://www.gaozhengzhou.com/kubernetes/kubernetes.repo | tee /etc/yum.repos.d/kubernetes.repo; \
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

#设置系统编码
RUN yum install kde-l10n-Chinese -y
RUN yum install glibc-common -y
RUN localedef -c -f UTF-8 -i zh_CN zh_CN.utf8

# env
ENV JENKINS_HOME=/data/jenkins/home
ENV CREDENTIALS_HOME=/data/jenkins/credentials
ENV REPOSITORY_HOME=/data/jenkins/repository
ENV DOCKER_CREDENTIALS_HOME=${CREDENTIALS_HOME}/docker
ENV KUBE_CREDENTIALS_HOME=${CREDENTIALS_HOME}/kube
ENV MAVEN_CREDENTIALS_HOME=${CREDENTIALS_HOME}/maven
ENV SSH_CREDENTIALS_HOME=${CREDENTIALS_HOME}/ssh
ENV GIT_SSH=/usr/local/bin/git-ssh.sh
ENV GIT_KEYFILE=${SSH_CREDENTIALS_HOME}/id_rsa
ENV LC_ALL=zh_CN.UTF-8
