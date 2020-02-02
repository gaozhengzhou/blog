# Git命令指定ssh-key文件
- 新增/root/.git-ssh.sh文件
```
#!/bin/bash
if [ -z "$GIT_KEYFILE" ]; then
    # if GIT_KEYFILE is not specified, run ssh using default keyfile
    ssh "$@"
else
    ssh -i "$GIT_KEYFILE" "$@"
fi
```

- 增加可执行权限  
`chmod +x /root/.git-ssh.sh`

- 修改环境变量，在/root/.bashrc文件增加以下两行  
```
export GIT_SSH=~/.git-ssh.sh
export GIT_KEYFILE=~/.id_rsa_git
```
_执行 `source /root/.bashrc`应用环境变量_

- 然后就可以无感使用git命令了  
`git clone git@192.168.0.68:gzz/test.git`



