#!/usr/bin/env bash

kkn default

#when $SSHD_ENABLE=true
runDropbear
clusterPodMode

echo "tail -f /dev/null"
# nohup /usr/sbin/sshd -D > /dev/null 2>&1 &  #just use dropbear
# exec $@ #trans exec ## in alpine-ext:weak
exec tail -f /dev/null
