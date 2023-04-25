#!/usr/bin/env bash

#when $SSHD_ENABLE=true
function runDropbear(){
#dropbear
if [ "$SSHD_ENABLE" = "true" ]; then
  #dropbear -E -F -R -p 22 -b /etc/motd &
  dropbear -E -F -R -p 22 &
fi
}
runDropbear


function clusterPodMode(){
#gen-kubeconfig dropbear tiller
if [ "$SSHD_ENABLE" = "true" ]; then
  #gen-kubeconfig
  #export TM_KUBECONFIG_PATH=/opt/gen-kubeconfig
  #gen-kubeconfig
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
  runDropbear
  #dropbear -E -F -R -p 22 -b /etc/motd & ##already done in alpine-ext:weak


  ##tiller-local
  #nohup tiller -listen localhost:44134 > /tmp/log-tiller.log 2>&1 &
fi
}
clusterPodMode

echo "tail -f /dev/null"
# nohup /usr/sbin/sshd -D > /dev/null 2>&1 &  #just use dropbear
# exec $@ #trans exec ## in alpine-ext:weak
exec tail -f /dev/null
