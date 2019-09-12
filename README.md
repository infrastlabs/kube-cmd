# kube-cmd

## 管理中台
**软件配套**
- kubectl
- helm
- stern
- kubectx
- kube-ps1

|   组件   |  版本   |                URL链接                |                   说明                   |
| -------- | ------- | ------------------------------------- | ---------------------------------------- |
| kubectl  | v1.14.6 | https://github.com/kubernetes/kubectl | 简写kc,AutoCompletion，-k 支持kustomize  |
| helm     | v2.14.3  | https://github.com/helm/helm          | 简写hm,AutoCompletion, tiller本地模式    |
| stern    | v1.10.0 | https://github.com/wercker/stern      | 简写sn,AutoCompletion, 多POD日志实时查看 |
| kubectx  | master  | https://github.com/ahmetb/kubectx     | kkx/kkn 切换集群 切换NS                  |
| kube-ps1 | master  | https://github.com/jonmosco/kube-ps1  | 控制台信息显示                           |

**控制台说明**
```
原理：
# 临时用：在Master节点挂着kubeconfig，命令拉起容器 直接操作；
  指令：docker run -it --rm -v /root/.kube/:/root/.kube --entrypoint=bash infranstlabs:kube-cmd
# 正式用：结合rbac-auth生成的多用户配置，docker-compose拉起容器，容器内跑ssh，配备多用户与集群用户对应；
  指令：通过dcp拉起，此处略
```
