#!/usr/bin/env bash

function kubeconfigGenerate() {
  # 生成 kubelet kubeconfig 配置文件 (ref: 01kubelet.sh)
  local kubeconfig="--kubeconfig=/root/.kube/config"
  # embd="--embed-certs=true"
  # ca.crt, token, namespace
  #TODO token变化后，同步更新 >> krand (改生成用户证书??)
  local KUBE_APISERVER="https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT"
  local CA=/run/secrets/kubernetes.io/serviceaccount/ca.crt
  local TOKEN=$(cat /run/secrets/kubernetes.io/serviceaccount/token)
  if [ -s $CA ]; then
    mkdir -p /root/.kube
    kubectl config set-cluster kubernetes \
      --certificate-authority=$CA $embd --server=${KUBE_APISERVER} $kubeconfig
    # --client-certificate/key --token --username/password
    kubectl config set-credentials "sa" \
      --token=${TOKEN} $kubeconfig
    # 
    kubectl config set-context ctx-sa \
      --cluster=kubernetes --namespace=default --user="sa" $kubeconfig
    kubectl config use-context ctx-sa $kubeconfig
  fi
}


#when $SSHD_ENABLE=true
function runDropbear(){
#dropbear
if [ "$SSHD_ENABLE" = "true" ]; then
  kkn default > /dev/null 2>&1 #k3s's kubeconfig.yaml

  #dropbear -E -F -R -p 22 -b /etc/motd &
  dropbear -E -F -R -p 22
fi
}
function clusterPodMode(){
#gen-kubeconfig dropbear tiller
if [ "$SSHD_ENABLE" = "true" ]; then
  #gen-kubeconfig
  #export TM_KUBECONFIG_PATH=/opt/gen-kubeconfig
  #gen-kubeconfig
  kubeconfigGenerate
  
  #export KUBECONFIG=$TM_KUBECONFIG_PATH
  #owner by ctoper: for kkn usage.
  #chmod 777 /opt #for: error: open /opt/gen-kubeconfig.lock: permission denied
  #chown ctoper:ctoper $TM_KUBECONFIG_PATH

  #special priviledge, just outside common set.
  dest=/root/.bashrc
  #echo "export TM_KUBECONFIG_PATH=/opt/gen-kubeconfig" >> $dest
  #echo "export KUBECONFIG=\\$TM_KUBECONFIG_PATH" >> $dest
  dest=/home/ctoper/.bashrc
  #echo "export TM_KUBECONFIG_PATH=/opt/gen-kubeconfig" >> $dest
  #echo "export KUBECONFIG=\\$TM_KUBECONFIG_PATH" >> $dest

  #run dropbear
  # runDropbear
  # dropbear -E -F -R -p 22 -b /etc/motd & ##already done in alpine-ext:weak
  # exec supervisord -n -c /etc/supervisor/supervisord.conf #py's  -n front
  exec supervisord -c /etc/supervisor/supervisord.conf #go's -d daemon


  ##tiller-local
  #nohup tiller -listen localhost:44134 > /tmp/log-tiller.log 2>&1 &
fi
}
env #view
clusterPodMode

# nohup /usr/sbin/sshd -D > /dev/null 2>&1 &  #just use dropbear
# exec $@ #trans exec ## in alpine-ext:weak
echo "SSHD_ENABLE != true; tail -f /dev/null";
test "$SSHD_ENABLE" != "true" && exec tail -f /dev/null
