## docker run -d --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock -v /usr/bin/docker:/usr/bin/docker jenkins/jenkins:lts-centos /bin/bash
## http://mirrors.jenkins-ci.org/status.html
## https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json
## https://www.jianshu.com/p/0aef1cc27d3d
FROM jenkins/jenkins:lts-centos
USER root

# install docker dependency libtool
RUN yum install -y epel-release; \
        yum install -y libtool-ltdl;

# install maven git
RUN yum install -y maven git;

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

# setting env
ENV JENKINS_UC="https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates"
ENV JENKINS_UC_EXPERIMENTAL="https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/experimental"
ENV CREDENTIAL_HOME="/data/credentials"

