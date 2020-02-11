# Node.js安装

### 官网
https://nodejs.org/en/

### 下载
wget https://nodejs.org/dist/v12.15.0/node-v12.15.0-linux-x64.tar.xz

### 安装
- 解压  
tar xvf node-v12.15.0-linux-x64.tar.xz -C /opt/  

- 修改环境变量  
vi /etc/profile  ## 在文件末增加以下一行
```
export PATH=$PATH:/opt/node-v12.15.0-linux-x64/bin
```

- 应用环境变量  
source /etc/profile  

- 查看版本  
node -v  
npm -v  

### 淘宝 NPM 镜像
- 官网    
https://npm.taobao.org/  

- 安装  
npm install -g cnpm --registry=https://registry.npm.taobao.org

- 查看版本  
cnpm -v


