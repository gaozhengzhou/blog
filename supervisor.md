# Supervisor安装使用
>Supervisor是用Python开发的一个client/server服务，是Linux/Unix系统下的一个进程管理工具
>它可以很方便的监听、启动、停止、重启一个或多个进程，用来管理自启服务是个不错的选择。

### Server端
- 安装  
    `yum -y install supervisor`

- 编辑配置文件  
    `vi /etc/supervisord.conf`  
    修改最后一行如下
    ```
    [include]
    files = supervisord.d/*.ini /usr/apps/*/supervisor*.conf
    ```
  
- 启动服务  
    `systemctl enable supervisord`  
    `systemctl start supervisord`  

### Client端
- 创建目录  
    `mkdir /usr/apps/ -p`

- 复制项目到/usr/apps/服务下，这里以tomcat8为例  
    `wget http://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-8/v8.5.50/bin/apache-tomcat-8.5.50.tar.gz`
  
- 解压到/usr/apps/  
    `tar zxvf apache-tomcat-8.5.50.tar.gz -C /usr/apps/`
    
- 重命名并进入tomcat目录
    `mv /usr/apps/apache-tomcat-8.5.50/ /usr/apps/tomcat8/`    
    `cd /usr/apps/tomcat8/` 

- 新增supervisor.conf文件  
    `vi supervisor.conf`
    ```
    [program:tomcat8]
    command=/usr/apps/tomcat8/bin/startup.sh              ; the program (relative uses PATH, can take args)
    process_name=%(program_name)s ; process_name expr (default %(program_name)s)
    numprocs=1                    ; number of processes copies to start (def 1)
    directory=/usr/apps/tomcat8                ; directory to cwd to before exec (def no cwd)
    umask=022                     ; umask for process (default None)
    priority=999                  ; the relative start priority (default 999)
    autostart=true                ; start at supervisord start (default: true)
    autorestart=true              ; retstart at unexpected quit (default: true)
    startsecs=10                  ; number of secs prog must stay running (def. 1)
    startretries=3                ; max # of serial start failures (default 3)
    exitcodes=0,2                 ; 'expected' exit codes for process (default 0,2)
    stopsignal=QUIT               ; signal used to kill process (default TERM)
    stopwaitsecs=10               ; max num secs to wait b4 SIGKILL (default 10)
    user=root                   ; setuid to this UNIX account to run the program
    redirect_stderr=true          ; redirect proc stderr to stdout (default false)
    stdout_logfile=/usr/apps/tomcat8/logs/stdout.log        ; stdout log path, NONE for none; default AUTO
    stdout_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
    stdout_logfile_backups=10     ; # of stdout logfile backups (default 10)
    stdout_capture_maxbytes=1MB   ; number of bytes in 'capturemode' (default 0)
    stdout_events_enabled=false   ; emit events on stdout writes (default false)
    stderr_logfile=/usr/apps/tomcat8/logs/stdout.log        ; stderr log path, NONE for none; default AUTO
    stderr_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
    stderr_logfile_backups=10     ; # of stderr logfile backups (default 10)
    stderr_capture_maxbytes=1MB   ; number of bytes in 'capturemode' (default 0)
    stderr_events_enabled=false   ; emit events on stderr writes (default false)
    environment=A=1,B=2           ; process environment additions (def no adds)
    serverurl=AUTO                ; override serverurl computation (childutils)
    ```

- 编辑bin/startup.sh文件    
    `vi bin/startup.sh`
    
    把以下一行的start改为run
    ```
    #exec "$PRGDIR"/"$EXECUTABLE" start "$@"
    exec "$PRGDIR"/"$EXECUTABLE" run "$@"
    ```
- 使supervisor配置生效  
    `supervisorctl update`

- 查看supervisor状态  
    `supervisorctl status`
    
- 停止tomcat8服务  
    `supervisorctl stop tomcat8`
    
- 启动tomcat8服务  
    `supervisorctl start tomcat8`
    
- 重启tomcat8服务  
    `supervisorctl restart tomcat8`