#FROM infrastlabs/kube-bin:k8s-cmd as src
#kube-cmd-build:bin ##build in aliyun, in hosts which outside
FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/kube-cmd-build:bin as src
FROM registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.14.3 as tiller
FROM registry.cn-shenzhen.aliyuncs.com/k-pub/att-kube-mgr:v1.3 as kgctl
FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/gen-kubeconfig as gen-kc
FROM registry.cn-shenzhen.aliyuncs.com/k-spe/prs-n2n as edge
FROM docker:17.12.1-ce as docker-ce

# FROM infrastlabs/alpine-ext
# FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/alpine-ext
FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/alpine-ext:weak
MAINTAINER sam <sldevsir@126.com>

USER root

##OneByOne
COPY --from=src /ws/kubectl /usr/local/bin/
COPY --from=src /ws/helm /usr/local/bin/
COPY --from=src /ws/stern /usr/local/bin/
COPY --from=src /ws/rbac-lookup /usr/local/sbin/
#tiller kgctl gen-kubeconfig
COPY --from=tiller /tiller /usr/local/bin/tiller
COPY --from=kgctl /usr/local/bin/kgctl /usr/local/bin/kgctl
COPY --from=gen-kc /app/gen-kubeconfig /usr/local/bin/gen-kubeconfig
COPY --from=edge /usr/local/sbin/edge /usr/local/bin/edge
COPY --from=docker-ce /usr/local/bin/docker /usr/local/bin/docker

##cloned git
COPY --from=src /ws/kube-ps1 /opt/k8s-client/kube-ps1
COPY --from=src /ws/kubectx /opt/k8s-client/kubectx

RUN cd /usr/local/bin/ && chmod +x * 
ADD *.sh /
RUN sh /build.sh

##run as root
USER root
WORKDIR /
ENTRYPOINT ["bash", "-c", "/entry.sh"]
