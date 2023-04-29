#!/bin/bash
#setenforce 0
cur=$(cd "$(dirname "$0")"; pwd) 
cd $cur

#registry
source /etc/profile; #export |grep DOCKER_REG
repo=registry.cn-shenzhen.aliyuncs.com
echo "${DOCKER_REGISTRY_PW_sdsir}" |docker login --username=${DOCKER_REGISTRY_USER_sdsir} --password-stdin $repo

ns=infrastlabs

# TEST_BASH
# img=kube-cmd:v2.0-bash #latest #v1.0 
# docker build --pull -t $repo/$ns/$img -f src/Dockerfile_bash .
# exit 0

#src
img=kube-cmd:v2.1 #latest #v1.0 
docker build --network=host --pull -t $repo/$ns/$img -f src/Dockerfile .
docker push $repo/$ns/$img
