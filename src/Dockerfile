    FROM infrastlabs/kube-bin:k8s-cmd as src
    FROM registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.14.3 as tiller
    FROM registry.cn-shenzhen.aliyuncs.com/k-pub/att-kube-mgr:v1.3 as kgctl
FROM infrastlabs/alpine-ext
MAINTAINER sam <sldevsir@126.com>

USER root

##OneByOne
COPY --from=src /down/kubectl /usr/local/bin/
COPY --from=src /down/helm /usr/local/bin/
COPY --from=src /down/stern /usr/local/bin/
COPY --from=src /down/rbac-lookup /usr/local/sbin/
#tiller kgctl
COPY --from=tiller /tiller /usr/local/bin/tiller
COPY --from=kgctl /usr/local/bin/kgctl /usr/local/bin/kgctl

##cloned git
COPY --from=src /opt/k8s-client/kube-ps1 /opt/k8s-client/kube-ps1
COPY --from=src /opt/k8s-client/kubectx /opt/k8s-client/kubectx

ADD *.sh /
RUN sh /build.sh

##run as root
USER root
WORKDIR /
ENTRYPOINT ["bash", "-c", "/entry.sh"]

