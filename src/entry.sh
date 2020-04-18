#!/usr/bin/env bash

runDropbear #when $SSHD_ENABLE=true
clusterPodMode #when $SSHD_ENABLE=true

# echo "start ssh"
# nohup /usr/sbin/sshd -D > /dev/null 2>&1 &  #just use dropbear

# exec $@ #trans exec ## in alpine-ext:weak
exec tail -f /dev/null
