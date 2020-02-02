# SSH免密登录
## 环境  
>客户端：192.168.0.68 izwz931kkv78tmprntu5ioz  
>服务端：192.168.0.71 izwz990g1xkweknerwfutcz
## 客户端生成SSH Key    
`ssh-keygen -t rsa`

```
[root@izwz931kkv78tmprntu5ioz ~]# ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:heGBosZHupqTEML18WOhHGI4w5R2Mi2+4wY5/hP90so root@izwz931kkv78tmprntu5ioz
The key's randomart image is:
+---[RSA 2048]----+
|o.+    .o        |
| @ *oo.o +       |
|+.X++.= + .      |
|oo= .+ + .       |
|.+.o. . S        |
|=o.. .           |
|==. . o          |
|=+ ... o         |
|.....Eo          |
+----[SHA256]-----+
[root@izwz931kkv78tmprntu5ioz ~]#
```

查看生成的公钥  
`cat /root/.ssh/id_rsa.pub`

查看生成的私钥  
`cat /root/.ssh/id_rsa`

## 复制公钥到服务端
`ssh-copy-id -p 15022 root@192.168.0.71`

```
[root@izwz931kkv78tmprntu5ioz ~]# ssh-copy-id -p 15022 root@192.168.0.71
/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"
/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@192.168.0.71's password:

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh -p '15022' 'root@192.168.0.71'"
and check to make sure that only the key(s) you wanted were added.

[root@izwz931kkv78tmprntu5ioz ~]#
```
  
## 服务端确认公钥是否添加成功
`cat /root/.ssh/authorized_keys`

```
[root@izwz990g1xkweknerwfutcz ~]# cat /root/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDmJeH39utZI2tdX16F0ihqUVKsKJa5rjG+3SdLS8vSQ8SRCXn+YQiG9XrucgtdJ16IXoPd/KtvE1SJKD/Sj4DkxUSyMD4d9Aet+YMOf0W5OJb17A64WeERoDbg45J7dpCbmc3Njjmbibw3OuYJI2QWa4UxcE35e2A/gS6/2AM73e6d/lK0/6wL8mXH20b+x8R4kc07wHgmVku1igcewvZ0iLDYhgAEY/MDlydSHTUg4SsFZknn+zBle22jIGTgQ/RiTFSFtIAHuAQmXLOsv+3GIcHH1rgQgVxGPdvxaHOZkU7ZlPRHYbMOjSf3Jsd8mlpZGbMdtwj9EW root@izwz931kkv78tmprntu5ioz
[root@izwz990g1xkweknerwfutcz ~]#
```

## 测试连接
`ssh -p 15022 root@192.168.0.71`

```
[root@izwz931kkv78tmprntu5ioz ~]# ssh -p 15022 root@192.168.0.71
Last login: Sun Feb  2 17:31:44 2020 from 172.18.44.223

Welcome to Alibaba Cloud Elastic Compute Service !

[root@izwz990g1xkweknerwfutcz ~]#
```

## 指定ssh-key文件连接
- 复制id_rsa到某个目录  
`cp /root/.ssh/id_rsa /tmp/id_rsa_test -p`

- 指定ssh-key连接  
`ssh -i /tmp/id_rsa_test -p 15022 root@192.168.0.71`

## ssh登录忽略known_hosts文件的警告
- 方法一: 修改客户端的~/.ssh/config增加一行  
`StrictHostKeyChecking no`

- 方法二：通过客户端参数忽略  
`ssh -o StrictHostKeyChecking=no -p 15022 root@192.168.0.71`