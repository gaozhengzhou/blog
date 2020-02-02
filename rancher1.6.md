# Rancher1.6安装
## 环境准备
| 分类 | 主机名 | 规格 | 标签 |
| --- | --- | --- | --- |
| Rancher | PX-RANCHER | 2 vCPU 16 GiB | 无 |
| 数据平面/编排平面 | PX-K8SETCD1 | 2 vCPU 8 GiB | etcd=true orchestration=true |
| 数据平面/编排平面 | PX-K8SETCD2 | 2 vCPU 8 GiB | etcd=true orchestration=true |
| 数据平面/编排平面 | PX-K8SETCD3 | 2 vCPU 8 GiB | etcd=true orchestration=true |
| 计算平面 | PX-K8SNODE1 | 4 vCPU 32 GiB | compute=true |
| 计算平面 | PX-K8SNODE2 | 4 vCPU 32 GiB | compute=true |

## 添加rancher节点（在Rancher的ECS执行）
`sudo docker run -d --restart=unless-stopped -v /data/rancher/mysql/:/var/lib/mysql/ -p 8080:8080 rancher/server`

## 创建K8S环境（在Rancher管理界面执行）
- 在环境管理创建（隔离平面Kubernetes）环境模板
- 使用（隔离平面Kubernetes）环境模板创建P版环境

## 添加3台数据平面+编排平面节点（在数据平面+编排平面ECS执行）
示例（实际命令在Rancher管理界面生成）：  
`sudo docker run -e CATTLE_HOST_LABELS='etcd=true&orchestration=true'  --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher rancher/agent:v1.2.11 http://172.18.44.233:8080/v1/scripts/F5B5CB3B1F5B70360CA4:1577750400000:FetMofqpLMqcp4z88ZHIdJBH3M`

## 添加3台计算平面节点（在计算平面ECS执行）
示例（实际命令在Rancher管理界面生成）：  
`sudo docker run --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher rancher/agent:v1.2.11 http://172.18.44.233:8080/v1/scripts/F5B5CB3B1F5B70360CA4:1577750400000:FetMofqpLMqcp4z88ZHIdJBH3M`



