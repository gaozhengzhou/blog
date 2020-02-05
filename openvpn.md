# OpenVPN服务搭建

### Server端
- 安装  
    ```
    wget http://mirror.centos.org/centos/7/os/x86_64/Packages/lz4-1.7.5-3.el7.x86_64.rpm
    yum localinstall lz4-1.7.5-3.el7.x86_64.rpm
    yum install openvpn iptables bash easy-rsa openvpn-auth-pam google-authenticator pamtester
    ln -s /usr/share/easy-rsa/3/easyrsa /usr/local/bin
    git clone https://github.com/gaozhengzhou/docker-openvpn.git
    cp docker-openvpn/otp/openvpn /etc/pam.d/
    mv docker-openvpn/ /usr/apps/openvpn/
    ```
- 设置环境变量  
    `vi /etc/profile`
    ```
    export PATH=$PATH:/usr/apps/openvpn/docker-openvpn/bin
    export OPENVPN=/usr/apps/openvpn
    export EASYRSA=/usr/share/easy-rsa/3
    export EASYRSA_PKI=$OPENVPN/pki
    export EASYRSA_VARS_FILE=$OPENVPN/vars
    export EASYRSA_CRL_DAYS=3650
    ```

- 添加用户组  
    `useradd openvpn`  
    `groupadd nogroup`  

- 生成配置  
    `ovpn_genconfig -u tcp://120.77.208.204`  
    `ovpn_initpki`  
    `vi /usr/apps/openvpn/openvpn.conf`  
    
    ```
    server 192.168.255.0 255.255.255.0
    verb 3
    key /usr/apps/openvpn/pki/private/120.77.208.204.key
    ca /usr/apps/openvpn/pki/ca.crt
    cert /usr/apps/openvpn/pki/issued/120.77.208.204.crt
    dh /usr/apps/openvpn/pki/dh.pem
    tls-auth /usr/apps/openvpn/pki/ta.key
    key-direction 0
    keepalive 10 60
    persist-key
    persist-tun
    
    proto tcp
    # Rely on Docker to do port mapping, internally always 1194
    port 11194
    dev tun0
    status /usr/apps/openvpn/openvpn-status.log
    
    user nobody
    group nogroup
    comp-lzo no
    
    ### Route Configurations Below
    route 192.168.254.0 255.255.255.0
    
    ### Push Configurations Below
    push "block-outside-dns"
    push "dhcp-option DNS 100.100.2.136"
    push "dhcp-option DNS 100.100.2.138"
    push "comp-lzo no"
    ```

- 自动启动配置  
    `mkdir /usr/apps/openvpn/logs`  
    `mkdir /usr/apps/openvpn/ovpn`  
    `cd /usr/apps/openvpn`  
    `vi supervisor.conf`  
    ```
    [program:openvpn_server]
    command=/usr/apps/openvpn/docker-openvpn/bin/ovpn_run              ; the program (relative uses PATH, can take args)
    process_name=%(program_name)s ; process_name expr (default %(program_name)s)
    numprocs=1                    ; number of processes copies to start (def 1)
    directory=/usr/apps/openvpn                ; directory to cwd to before exec (def no cwd)
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
    stdout_logfile=/usr/apps/openvpn/logs/stdout.log        ; stdout log path, NONE for none; default AUTO
    stdout_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
    stdout_logfile_backups=10     ; # of stdout logfile backups (default 10)
    stdout_capture_maxbytes=1MB   ; number of bytes in 'capturemode' (default 0)
    stdout_events_enabled=false   ; emit events on stdout writes (default false)
    stderr_logfile=/usr/apps/openvpn/logs/stdout.log        ; stderr log path, NONE for none; default AUTO
    stderr_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
    stderr_logfile_backups=10     ; # of stderr logfile backups (default 10)
    stderr_capture_maxbytes=1MB   ; number of bytes in 'capturemode' (default 0)
    stderr_events_enabled=false   ; emit events on stderr writes (default false)
    environment=PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/apps/openvpn/docker-openvpn/bin:/root/bin,OPENVPN=/usr/apps/openvpn,EASYRSA=/usr/share/easy-rsa/3,EASYRSA_PKI=/usr/apps/openvpn/pki,EASYRSA_VARS_FILE=/usr/apps/openvpn/vars,EASYRSA_CRL_DAYS=3650           ; process environment additions (def no adds)
    serverurl=AUTO                ; override serverurl computation (childutils)
    ```

- 使supervisor配置生效  
    `supervisorctl update`
    
- 查看supervisor状态  
    `supervisorctl status`
    
- 停止openvpn_server服务  
    `supervisorctl stop openvpn_server`
    
- 启动openvpn_server服务  
    `supervisorctl start openvpn_server`
    
- 重启openvpn_server服务  
    `supervisorctl restart openvpn_server`

- 查看openvpn客户端连接状态  
    `cat /usr/apps/openvpn/openvpn-status.log`

### Client端
#### 生成无密码客户端密钥
- 每个客户端一个密钥  
    `CLIENTNAME=gzz`  
    `easyrsa build-client-full ${CLIENTNAME} nopass`  
    
    `ovpn_getclient ${CLIENTNAME} > /usr/apps/openvpn/ovpn/${CLIENTNAME}.ovpn`  
    `cat /usr/apps/openvpn/ovpn/${CLIENTNAME}.ovpn`  
    
#### Windows  
https://swupdate.openvpn.org/community/releases/openvpn-install-2.4.7-I603.exe

#### Linux
- 安装  
    ```
    wget http://swupdate.openvpn.org/community/releases/openvpn-2.4.7.tar.gz
    yum install -y gcc make openssl-devel lz4-devel lzo-devel pam-devel supervisor
    tar zxvf openvpn-2.4.7.tar.gz -C /usr/local/src
    cd /usr/local/src/openvpn-2.4.7
    ./configure --prefix=/usr/apps/openvpn
    make && make install
    ```
- 进入目录  
    `mkdir /usr/apps/openvpn/logs`  
    `cd /usr/apps/openvpn`  

- 输入客户端密钥  
    `vi client.ovpn`  
    ```
    client
    nobind
    dev tun
    remote-cert-tls server
    
    remote 192.168.0.11 1194 tcp
    
    <key>
    -----BEGIN PRIVATE KEY-----
    MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDPM15KCG4EdodI
    DOPhumijfcyhiN03XZLtyqZbeSBWRe2lTjJdo2z3fktR6J5Mx5czeTLBUqGIK7Uc
    AcktLRZUrFu8gtkbrGrbq08ClHK8kVijrv5KWdWZamO3grt+1/HlJ6CT+nPsW8Ea
    TNNZVTNvgwFJ92vH61U3BHaaayQhqV6D0ht7K49vRAsI3YdjHo9WBJIt0+G+VT7w
    qY/EwcmLH9J2wckpXHhjnWIxhoO7XMUitUTsZUrF2E1tnRxIiHWvHBGkxEgGztB4
    PNkctIfpRpiFgm6EmqCVx7yP8/8bgFGkR/3+vLF2jUbJxTi2WF756aFz5/08QRjo
    50KkhHh5AgMBAAECggEAAp1YVEDU+pNwU5VuDrwmc+GzglpSyE8S+pMzFDZsFQqe
    3BYnhoz4ZAsg8jCoRrnCC7E81bmwNiKvD2JqYnqOLJVcNv3DtZiwZIM95P9wjzaa
    Ur5zkQafLmdsSLWKniglcknUuelQKyxhPG65wAfWNVMG4iMQJh6vHZmd0XHgZ9hQ
    ek+kRsL++GE5YTdNq8ZHTVPeOSLlIEk5k6jnM+8AWu6LemWBKzs82n5pHpcIzlgm
    3ox1Ax0wpangqeNBGUXb38QQe/qP42JGkZPAJ6Zec8S3jLDsR37tNY/rCbdSpF5V
    8o3DizMnP124XKCL2vyOOavq2nchJdhQ4TT915+aDQKBgQDxf512zE7D9FNIQiyW
    zl4KwSL1hG1C36EEOOFJZZXl1Axf2ma4uzR6/1xm/MDR2Y3tn/+k0+3ckUxBhRq4
    vSNyiTLRad9ABwaUcx71dLU1R+z3runAFK5DyRiDnk2+jzbDcEUUk7bg0ttwL4wW
    dXV8D/PnmdXkIe1udhZTq8TtuwKBgQDbpIRTdJUPxmlAUXgEXklRAhnHsCynK/vH
    SlyX1aq3eESKJ6jle/XQ5i8lnVp3kaWa7lUuUB+Xa8tnTIUt1CcOaHvmwYkioyza
    jnWTW69tNZLMDJ8w8FLqbF/KjAEmVOJgbHB2ldWyJHqDOavUFM12MM2hlpfxzC0O
    lOgiegD1WwKBgCxUXpU1/6dcrATxkLnF++FBfqdOvbeu0SGzRzdv3Eop2HOn5X83
    bfS99zo4XzSmGLVrz0N0W49HZJYKVtNedKlLofZq1r4sC/sn/qDT4Yd8QnVcuC+4
    HBz5RvSyFFdMdqL9ctDKJKG0Uu+O6socmYpCa2UyCd8skybZqlOFjkqNAoGAE7yP
    y3QBZP5+PLJVZ4cVbXsT1/bDvG3eXQUYlugzQ/NBrWxs59ogt5nHiMi/9ViYGfjq
    nJPEkvWzvF+K5BhZPhkzcQPZD8y73hPJCunFNLoIq99CesJNoRUF8oxsGgaspN95
    p55FKpHOlHYdM5x+7ezqvWdr1eVz8wh8Z4SxC1sCgYEAldmN7K2OpBo5MY+GtZOb
    9ZXgZC+6tTAUnRUDraZ2imfSV5s6F2QUTwei6+8kwBZYU6ksEROtabItuNVKfBbE
    UjYDvm3LrVzWcUsrOET1jUXL4mOcr7k+tRJxPUrGdaBe12qAyhh+V0+Lc2yFxz7f
    SStClLLTUtLJWcW87+UE2BI=
    -----END PRIVATE KEY-----
    </key>
    <cert>
    -----BEGIN CERTIFICATE-----
    MIIDTDCCAjSgAwIBAgIQVuJVbcZn17itDyyXHRwb1zANBgkqhkiG9w0BAQsFADAZ
    MRcwFQYDVQQDDA4xMjAuNzcuMjA4LjIwNDAeFw0yMDAxMTgwMzEwMTFaFw0yMzAx
    MDIwMzEwMTFaMA4xDDAKBgNVBAMMA2d6ejCCASIwDQYJKoZIhvcNAQEBBQADggEP
    ADCCAQoCggEBAM8zXkoIbgR2h0gM4+G6aKN9zKGI3Tddku3Kplt5IFZF7aVOMl2j
    bPd+S1HonkzHlzN5MsFSoYgrtRwByS0tFlSsW7yC2RusaturTwKUcryRWKOu/kpZ
    1ZlqY7eCu37X8eUnoJP6c+xbwbbM01lVM2+DAUn3a8frVTcEdpPfJCGpXoPSG3sr
    j29ECwjdh2Mej1YEki3T4b5VPvCpj8TByYsf0nbBySlceGOdYjGGg7tcxSK1ROxl
    SsXYTW2dHEiIda8cEaTESAbO0Hg82Ry0h+lGmIWCboSaoJXHvI/z/xuAUaRH/f68
    sXaNRsnFOLZYXvnpoXPn/TxBGOjnQqSEeHkCAwEAAaOBmjCBlzAJBgNVHRMEAjAA
    MB0GA1UdDgQWBBRwqRVx0pZmUJbloUar9u/azNLpXTBJBgNVHSMEQjBAgBTJYw1R
    tjglm9a2XalOigcrLllXeqEdpBswGTEXMBUGA1UEAwwOMTIwLjc3LjIwOC4yMDSC
    CQDdsOTjTCmAzzATBgNVHSUEDDAKBggrBgEFBQcDAjALBgNVHQ8EBAMCB4AwDQYJ
    KoZIhvcNAQELBQADggEBAD/1j4rV8/lg7IR6U+7YsPlLkhQJjK94oGi0GyzB8ZWO
    IkOmidbwjYFseOzdmV8cSaog1lvvZiW8lw4ra0v7g0Dsn7mksLdnI4H2wcchICjz
    hqRy7gu5IUceNcVMmxf7+T0MWP6Jw8wCu2hON5HWfx7sjRcSuKnEACW7fIXVTuz9
    Lx2OG7l5VsDRKZmPoW5Ri86F2c2TzKSkTv/ln4mqX9+GB4p8K4V8VtGs+zoj2/su
    QIRcXeMS6KEfsLk3Dh3Rbos5TnjvkWdDKEUKiJTXfduQqFomQrgXXNqI7/qjqiSx
    BdWc5SSvYZCdf4YawpGXHK9og5LPSp3hKo17czPsIB0=
    -----END CERTIFICATE-----
    </cert>
    <ca>
    -----BEGIN CERTIFICATE-----
    MIIDPjCCAiagAwIBAgIJAN2w5ONMKYDPMA0GCSqGSIb3DQEBCwUAMBkxFzAVBgNV
    BAMMDjEyMC43Ny4yMDguMjA0MB4XDTIwMDExODAxNDQwMFoXDTMwMDExNTAxNDQw
    MFowGTEXMBUGA1UEAwwOMTIwLjc3LjIwOC4yMDQwggEiMA0GCSqGSIb3DQEBAQUA
    A4IBDwAwggEKAoIBAQCXaq79bhccUaYfkF6bZR2vV+RX1lN37mSopwFS+Wu33igv
    lGtYeTgYMBpF1rEQcWpW31En1v8L6TeolmtJ0iodfqWNQkID6ZAyiQsXRW2jkOFU
    lN0t7+i1aKKMSISYdToXRm8CixLHCCR2lFRRk0I4xi7W70wO2HSp57/hejkYgSlG
    WiFsYpDSiJKD5DcG/F7ZAyTfZeeqC5birKjfQa80x3EZ+198Vtp0AFzfpiBEqaVr
    iqa+q69oR2n3XaOKi19wdd48g8C9p1e6yQ93JBwtmwXPePmpkvQzGXdWVxyd+wVb
    +lZSQOJYaeg0Z8nFSIk5sW7xjjBsp9ra5Yj6P3OXAgMBAAGjgYgwgYUwHQYDVR0O
    BBYEFMljDVG2OCWb1rZdqU6KBysuWVd6MEkGA1UdIwRCMECAFMljDVG2OCWb1rZd
    qU6KBysuWVd6oR2kGzAZMRcwFQYDVQQDDA4xMjAuNzcuMjA4LjIwNIIJAN2w5ONM
    KYDPMAwGA1UdEwQFMAMBAf8wCwYDVR0PBAQDAgEGMA0GCSqGSIb3DQEBCwUAA4IB
    AQByHelny/LolU5D6mFZ/RPuQQEB303bsshhPwZaAKUT019JO/3fQI1NRpZJwpY/
    LcEKzUcv7mZVjyTA99WdtSGArG14YqefCxBdqbQqZZ+ndsE2TrG0ZPkDMYEQx/hq
    U5ae33p6hQpoF6qCk0e6vj8RL7WgG70dWi376+t/c++Ijmxvn4tascuLuNfhR6Te
    IZlv/P777oFE0WOEA+BDkbMhxYaCsXn8z5khmxr75glbD4oONceDRr+ar991+Ib8
    lS06zvUovlghB7HRjQXngbwDKt9pu/2+cPxB32R05GRHjDFFgG+kGzWsAJlQ6j+g
    GBgzPEc2U6OFLo9Dh78FCQhu
    -----END CERTIFICATE-----
    </ca>
    key-direction 1
    <tls-auth>
    #
    # 2048 bit OpenVPN static key
    #
    -----BEGIN OpenVPN Static key V1-----
    8b46867dbaf776ca1677d24aa330d7b8
    309c9c6836db1490ca756ffcd9bbe26b
    f607009d933da34d9ba00bf6c373737a
    aaa227e980743807fffe8e555edc516a
    ce9d28ab7f7c440241d383657684c978
    e8593414425c97c26d20ff82dd697f4c
    0a536198b11cbeddd6c1e21f4ebd6bc4
    7474add400b27a22376e3e6346480c12
    045f0b502beaeb7d9848f41bb2d2e2b1
    ea898bb263473cdeffe6843079b4daef
    bc1e657c085e08defcd4cc0859abc9ea
    3839034fce617fbf15354dcee104a3c6
    bd8b5255c2534b2986bc4c2672e33d8f
    79c05a4ef8af9f5305b0e6274cffc4d4
    ef91b566f74d2294766ca09da568a2fc
    d78e9e42857979a9f78048550ed28fa0
    -----END OpenVPN Static key V1-----
    </tls-auth>
    
    redirect-gateway def1
    ```
    
- 设置自启脚本  
    `vi supervisor.conf`
    ```
    [program:openvpn_client]
    command=/usr/apps/openvpn/sbin/openvpn --config /usr/apps/openvpn/client.ovpn              ; the program (relative uses PATH, can take args)
    process_name=%(program_name)s ; process_name expr (default %(program_name)s)
    numprocs=1                    ; number of processes copies to start (def 1)
    directory=/usr/apps/openvpn                ; directory to cwd to before exec (def no cwd)
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
    stdout_logfile=/usr/apps/openvpn/logs/stdout.log        ; stdout log path, NONE for none; default AUTO
    stdout_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
    stdout_logfile_backups=10     ; # of stdout logfile backups (default 10)
    stdout_capture_maxbytes=1MB   ; number of bytes in 'capturemode' (default 0)
    stdout_events_enabled=false   ; emit events on stdout writes (default false)
    stderr_logfile=/usr/apps/openvpn/logs/stdout.log        ; stderr log path, NONE for none; default AUTO
    stderr_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
    stderr_logfile_backups=10     ; # of stderr logfile backups (default 10)
    stderr_capture_maxbytes=1MB   ; number of bytes in 'capturemode' (default 0)
    stderr_events_enabled=false   ; emit events on stderr writes (default false)
    environment=A=1,B=2           ; process environment additions (def no adds)
    serverurl=AUTO                ; override serverurl computation (childutils)
    ```
  
- 使supervisor配置生效  
    `supervisorctl update`
    
- 查看supervisor状态  
    `supervisorctl status`
    
- 停止openvpn_client服务  
    `supervisorctl stop openvpn_client`
    
- 启动openvpn_client服务  
    `supervisorctl start openvpn_client`
    
- 重启openvpn_client服务  
    `supervisorctl restart openvpn_client`
    
    