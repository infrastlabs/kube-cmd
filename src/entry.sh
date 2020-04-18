#!/usr/bin/env bash

echo "start ssh"
nohup /usr/sbin/sshd -D > /dev/null 2>&1 &

##tiller-local
nohup tiller -listen localhost:44134 > /tmp/log-tiller.log 2>&1 &

exec tail -f /dev/null
