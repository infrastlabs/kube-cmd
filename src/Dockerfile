# FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/kube-cmd-build:bin as src
# 17.12.1-ce>> 19.03.15 @21.60: buildx
FROM docker:19.03.15 as docker-ce

# 3.14.8> 3.13.12
FROM registry.cn-shenzhen.aliyuncs.com/infrasync/alpine:3.13.12 as down
  ARG TARGETPLATFORM
  # https://gitee.com/infrastlabs/alpine-ext/blob/master/binary/build.sh
  # #gosu-bin
  # wget https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64 -O gosu
  # #lrzsz-src>bin
  # #git clone https://github.com/jnavila/lrzsz  #build err
  # ver=lrzsz-0.12.20 && wget https://ohse.de/uwe/releases/$ver.tar.gz
  # #tmux-bin
  # ver=tmux-2.3 && wget https://github.com/tmux/tmux/releases/download/2.3/$ver.tar.gz


  # ##OneByOne
  # COPY --from=src /ws/kubectl /usr/local/bin/
  # COPY --from=src /ws/rbac-lookup /usr/local/sbin/
  # ##cloned git
  # COPY --from=src /ws/kube-ps1 /opt/k8s-client/kube-ps1
  # COPY --from=src /ws/kubectx /opt/k8s-client/kubectx
  #v1.17.5 v1.14.1 #v1.11.6
  ENV KUBE_LATEST_VERSION=v1.23.17
  #0.5.0
  ENV RBAC_VER=0.10.1
  # HELM_VERSION=v2.16.6 #v2.14.3 #v2.9.1
  # STERN_VER=1.11.0 #1.10.0
  # KUSZ_VER=v3.5.4 #2.0.3

  #RUN mkdir -p /rootfs/usr/local/bin && cd /rootfs/usr/local/bin; \
  WORKDIR /rootfs/usr/local/bin
  RUN echo a.12; \
    test -z "$(echo $TARGETPLATFORM |grep arm)" && arch=amd64 || arch=arm64; \
    #kubectl helm stern kustomize
    # https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.23.md#client-binaries
    # https://dl.k8s.io/v1.23.17/kubernetes-client-linux-amd64.tar.gz #28.6M
    # wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -O kubectl; \
    wget https://dl.k8s.io/${KUBE_LATEST_VERSION}/kubernetes-client-linux-$arch.tar.gz -O - | tar -xz -C /tmp; find /tmp; \
    \cp /tmp/kubernetes/client/bin/kubectl .; 
    # 
  RUN echo a.12; \
    test -z "$(echo $TARGETPLATFORM |grep arm)" && arch=x86_64 || arch=arm64; \
    # https://github.com/FairwindsOps/rbac-lookup/releases/download/v0.10.1/rbac-lookup_0.10.1_Linux_x86_64.tar.gz
    # https://github.com/FairwindsOps/rbac-lookup/releases/download/v0.10.1/rbac-lookup_0.10.1_Linux_arm64.tar.gz
    wget https://ghproxy.com/https://github.com/FairwindsOps/rbac-lookup/releases/download/v${RBAC_VER}/rbac-lookup_${RBAC_VER}_Linux_$arch.tar.gz -O - | tar -xz -C /tmp; \
    \cp /tmp/rbac-lookup .;
    # wget -q https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > helm
    # wget -q https://github.com/wercker/stern/releases/download/${STERN_VER}/stern_linux_amd64 -O stern
    # wget -q https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/${KUSZ_VER}/kustomize_${KUSZ_VER}_linux_amd64.tar.gz -O - | tar -xz #O kustomize  -O kustomize
    # wget https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64 -O gosu
  RUN \
    #gosu-bin
    test -z "$(echo $TARGETPLATFORM |grep arm)" && arch=amd64 || arch=arm64; \
    wget https://ghproxy.com/https://github.com/tianon/gosu/releases/download/1.11/gosu-$arch -O gosu;
  
  # v0.19.0-amd64: errRun with alpine>>  
  # tini-amd64 23.5 KB
  # tini-muslc-amd64  19 KB
  # tini-static-amd64 850 KB
  # tini-static-arm64 534 KB
  # tini-static-muslc-amd64 42.8 KB #无arm64
  # https://ghproxy.com/https://github.com/krallin/tini/releases/download/v0.19.0/tini-static-muslc-amd64
  RUN echo a.12; \
    test -z "$(echo $TARGETPLATFORM |grep arm)" && arch=amd64 || arch=arm64; echo "arch=$arch"; \
    mkdir -p /rootfs/sbin; \
    wget -O /rootfs/sbin/tini https://ghproxy.com/https://github.com/krallin/tini/releases/download/v0.19.0/tini-static-$arch; chmod +x /rootfs/sbin/tini; 


  # go:supervisord x64 10.6M; arm64 3.22M; v0.7.3@May 3, 2021
  # /tmp/supervisord_0.7.3_Linux_64-bit/supervisord_static 只x64包里有
  # /tmp/supervisord_0.7.3_Linux_64-bit/supervisord #3.6M
  RUN \
    test -z "$(echo $TARGETPLATFORM |grep arm)" && arch=64-bit || arch=ARM64; echo "arch=$arch"; \
    wget https://ghproxy.com/https://github.com/ochinchina/supervisord/releases/download/v0.7.3/supervisord_0.7.3_Linux_$arch.tar.gz -O - | tar -xz -C /tmp; find /tmp; \
    \cp /tmp/supervisord_0.7.3_Linux_$arch/supervisord .; 


  # RUN \
  #   #lrzsz-src
  #   ver=lrzsz-0.12.20 && wget https://ohse.de/uwe/releases/$ver.tar.gz -O - | tar -xz -C /tmp; \
  #   #tmux-src
  #   ver=tmux-2.3 && wget https://ghproxy.com/https://github.com/tmux/tmux/releases/download/2.3/$ver.tar.gz -O - | tar -xz -C /tmp; \
  #   find /tmp;
  RUN \
    chmod +x *; \
    #tree -h ./
    find; ls -lh; du -sh *
  # COPY --from=docker-ce /usr/local/bin/docker /rootfs/usr/local/bin/docker

# alpine-ext:weak ERR: home/end>>~
# FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/alpine-ext:weak
FROM registry.cn-shenzhen.aliyuncs.com/infrasync/alpine:3.13.12
MAINTAINER sam <sldevsir@126.com>
# USER root

# https://gitee.com/infrastlabs/alpine-ext/blob/master/src/build.sh
# https://www.jakehu.me/2021/alpine-mirrors/
# domain="mirrors.ustc.edu.cn"
# domain="mirrors.aliyun.com";
# mirrors.tuna.tsinghua.edu.cn
RUN domain="mirrors.tuna.tsinghua.edu.cn"; \
  echo "http://$domain/alpine/v3.13/main" > /etc/apk/repositories; \
  echo "http://$domain/alpine/v3.13/community" >> /etc/apk/repositories

#xshell: grep gawk
#procps: free -h
#shadow: chpasswd jumpserver, expect<mkpasswd>
# tmux: libevent ncurses (2.7-VimEnter-err, by hand with low ver); compile with src: v2.3
# findutils: for k3s agent node.
# coreutils: base64 for secrets
# busybox-extras: telnet  ## nc -vzw 2 host port
# dig: bind-tools
RUN apk add --no-cache \
ca-certificates tzdata curl wget \
sed grep gawk findutils sudo tree unzip procps htop \
expect shadow xterm bash bash-completion coreutils busybox-extras \
\
dropbear openssh-sftp-server openssh-client \
libevent ncurses openssl bind-tools
  
# Install
# kgctl: graphviz
# htpasswd: apache2-utils
# vim tmux-bin-2.3
RUN apk add --no-cache \
  #openssh apache2-utils graphviz \
  lftp jq sysstat git

RUN mkdir -p /usr/local/repos; cd /usr/local/repos; \
  git clone --depth=1 https://ghproxy.com/https://github.com/jonmosco/kube-ps1.git; \
  git clone --depth=1 https://ghproxy.com/https://github.com/ahmetb/kubectx.git
# tmux (3.1c-r0)
RUN apk add --no-cache tmux
# bins
COPY --from=down /rootfs /

ENV TIMEZONE=Asia/Shanghai \
 LANG=C.UTF-8 \
 SSHD_ENABLE=false \
 SSHD_PORT=22
# gosu tmux lrzsz
# COPY --from=src /ws/ /usr/bin/
ADD src/dot/. /root/
ADD src/*.sh /
ADD src/sv.conf /etc/supervisor/supervisord.conf
RUN sh /build.sh

##run as root
# USER root
WORKDIR /root
# ENTRYPOINT ["bash", "-c", "/entry.sh"]
# tini: https://www.5axxw.com/wiki/content/01ppi2
ENTRYPOINT ["/sbin/tini","--"]
# Run your program under Tini
# or docker run your-image /your/program ...
# CMD ["/your/program", "-and", "-its", "arguments"]

# CMD ["bash"]
CMD ["bash", "-c", "/entry.sh"]
