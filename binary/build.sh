#!/usr/bin/env sh

KUBE_LATEST_VERSION="v1.17.5" #"v1.14.1" #"v1.11.6"
HELM_VERSION="v2.16.6" #"v2.14.3" #"v2.9.1"
STERN_VER="1.11.0" #1.10.0
KUSZ_VER="3.5.4" #2.0.3

mkdir /ws && cd /ws
    #kubectl helm stern kustomize
    wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -O kubectl
    wget -q https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > helm
    wget -q https://github.com/wercker/stern/releases/download/${STERN_VER}/stern_linux_amd64 -O stern
    wget -q https://github.com/kubernetes-sigs/kustomize/releases/download/v${KUSZ_VER}/kustomize_${KUSZ_VER}_linux_amd64 -O kustomize
    chmod +x *

    #repo
    git clone https://github.com/jonmosco/kube-ps1.git
    git clone https://github.com/ahmetb/kubectx.git
    ls -lh ./
cd ..

rm -f /build.sh