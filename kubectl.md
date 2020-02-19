# kubectl安装

## 安装kubectl
- 设置安装源
```
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
       http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
```
    
- 安装  
```
yum install -y kubectl
```

## 安装krew插件（可选）    
- 官网  
<https://github.com/kubernetes-sigs/krew/>  

- 安装  
```
set -x; set temp_dir (mktemp -d); cd "$temp_dir" && \
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/v0.3.4/krew.{tar.gz,yaml}" && \
    tar zxvf krew.tar.gz && \
    set KREWNAME krew-(uname | tr '[:upper:]' '[:lower:]')_amd64 && \
    ./$KREWNAME install --manifest=krew.yaml --archive=krew.tar.gz && \
    set -e KREWNAME; set -e temp_dir
```

- 配置环境变量   
vi /etc/profile  
在文件末尾增加以下一行
```
export PATH="${PATH}:${HOME}/.krew/bin"
```
使环境变量生效  
source /etc/profile

- 查看已安装的插件  
kubectl plugin list

- 查看krew版本  
kubectl krew version

## 安装ingress-nginx插件（可选）
- 官网  
<https://kubernetes.github.io/ingress-nginx/kubectl-plugin/>  

- 安装  
```
set -x; cd "$(mktemp -d)" && \
    curl -fsSLO "https://github.com/kubernetes/ingress-nginx/releases/download/nginx-0.24.0/{ingress-nginx.yaml,kubectl-ingress_nginx-$(uname | tr '[:upper:]' '[:lower:]')-amd64.tar.gz}" && \
    kubectl krew install \
    --manifest=ingress-nginx.yaml --archive=kubectl-ingress_nginx-$(uname | tr '[:upper:]' '[:lower:]')-amd64.tar.gz
```

- 查看已安装的插件  
kubectl plugin list

- 查看ingress-nginx版本  
kubectl ingress-nginx version

    