# kube-cmd

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
| kube-ps1 | master  | https://github.com/jonmosco/kube-ps1  | 控制台信息显示  

**update**

```bash
KUBE_LATEST_VERSION="v1.17.5" #"v1.14.1" #"v1.11.6"
HELM_VERSION="v2.16.6" #"v2.14.3" #"v2.9.1"
STERN_VER="1.11.0" #1.10.0
KUSZ_VER="v3.5.4" #2.0.3
RBAC_VER="0.5.0"
```

**QuickStart**

- 临时用：在Master节点挂着kubeconfig，命令拉起容器 直接操作
  - `docker run -it --rm -v /root/.kube/:/root/.kube --entrypoint=bash registry.cn-shenzhen.aliyuncs.com/infrastlabs/kube-cmd`

- 正式用：结合rbac-auth生成的多用户配置，docker-compose拉起容器，容器内跑ssh，配备多用户与集群用户对应
  - `dcp up -d` 通过docker-compose拉起

