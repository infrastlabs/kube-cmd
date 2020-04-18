#!/bin/bash
#setenforce 0

#registry
repo=registry.cn-shenzhen.aliyuncs.com
source /etc/profile #~/.auth-docker-registry #set DOCKER_REGISTRY_PW DOCKER_REGISTRY_USER
#export |grep DOCKER_REG
echo "${DOCKER_REGISTRY_PW}" |docker login --username=${DOCKER_REGISTRY_USER} --password-stdin $repo

ns=infrastlabs
cur=$(cd "$(dirname "$0")"; pwd) 

#src
img=kube-cmd:latest #v1.0 
docker build --pull -t $repo/$ns/$img  $cur/src/. 
docker push $repo/$ns/$img
