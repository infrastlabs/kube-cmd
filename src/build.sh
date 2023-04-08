#!/bin/bash

# sh -c "$(curl -fsSL https://gitee.com/g-system/oh-my-bash/raw/sam-custom/tools/install.sh)"
# sed -i 's/OSH_THEME=.*/OSH_THEME="axin"/g' /root/.bashrc
##Alpine-ext################################
#profile
cat > /etc/profile <<EOF
if [ "\$(id -u)" -eq 0 ]; then
  PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
else
  PATH="/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
fi
export CHARSET=UTF-8
export PAGER=less
export PS1='\h:\w\$ '
umask 022
for script in /etc/profile.d/*.sh ; do
        if [ -r \$script ] ; then
                . \$script
        fi
done
EOF
echo "export TERM=xterm" >> /etc/profile
mkdir -p /usr/local/sbin


# chmod u+s /bin/ping
# echo "welcome to ct~ (alpine-ext: ${VER})" > /etc/motd
# # echo -n "Kernel: "     >>/etc/motd
# # uname -a               >>/etc/motd #TODO `uname -a`
# sed -i 's^/root:/bin/ash^/root:/bin/bash^g' /etc/passwd #root use bash
# echo "Defaults visiblepw" >> /etc/sudoers

TIMEZONE=Asia/Shanghai #ENV
ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && echo $TIMEZONE > /etc/timezone
#bin-link
mv /bin/sh /bin/busy_sh && ln -s /bin/bash /bin/sh #sh->bash
# dir=/usr/bin
# mv $dir/vi $dir/busy_vi && ln -s $dir/vim $dir/vi

# #bin1: gosu lrzsz tmux
# chown root:root /usr/bin/gosu #
# chmod +s gosu; chmod -s gosu
# chmod 751 /usr/bin/rz && chmod 751 /usr/bin/sz

# #dotfiles
# mkdir -p /etc/skel
# cp -a /root/. /etc/skel/ #.tmux.conf

# #user entry
# useradd -m -d /home/entry -s /bin/bash -u 664 entry #id 664
# echo 'entry ALL = (ALL)  ALL' >> /etc/sudoers
# sed -i '/^entry/d' /etc/sudoers #drop
##Alpine-ext################################

runDropbear=/usr/local/bin/runDropbear && touch $runDropbear && chmod +x $runDropbear
cat > $runDropbear <<EOF
#dropbear
if [ "\$SSHD_ENABLE" = "true" ]; then
  dropbear -E -F -R -p 22 -b /etc/motd &
fi
EOF




#bin: kubectl | helm | stern
# cd /usr/local/bin/ && chmod +x * ##in standalone run step for cache layer.
cd /usr/local/bin/ && ln -s kubectl kc #&& ln -s helm hm && ln -s stern sn

cat > /etc/motd <<EOF
welcome to ct~
use khelp to view the usage of detail commands.
EOF

#khelp
khelp=/usr/local/bin/khelp && touch $khelp && chmod +x $khelp
cat > $khelp <<EOF
echo '######################################
kube-mgr-usage:
<kc/kubectl, hm/helm, sn/stern, kkx/kkn>
1.kc get all --all-namespaces | kc get pod -l app=jk1-jenkins -Lapp
   kc get pod,svc,ing -n devops | kc logs -f --tail=200 xxx |kc exec -it xxx bash
2.hm ls | hm install --name jenkins ./jenkins
3.sn xxx | sn -l label
4.kkn to switch namespace, kkx to switch cluster. (default only one cluster)
######################################'
EOF

#krand
krand=/usr/local/bin/krand && touch $krand ##&& chmod +x $krand #needn't exec
cat > $krand <<EOF
if [ -e \$HOME/.kube/config ]; then
    rand=\`date +%s%N | md5sum | head -c 4\`
    mkdir -p \$HOME/.tmp/ && chmod -R 0600 \$HOME/.tmp/
    dest=\$HOME/.tmp/kubeconfig-\$rand
    cp -a \$HOME/.kube/config \$dest
    export KUBECONFIG=\$dest
fi
EOF

function initSSHServer(){
	echo "#SSH_SERVER ##################"
	ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa > /dev/null 2>&1

	#conf
	cp /etc/ssh/sshd_config /etc/ssh/sshd_config_bk
	sed -i "s/#PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config &&\
	sed -i "s/#PubkeyAuthentication.*/PubkeyAuthentication yes/g" /etc/ssh/sshd_config &&\
	sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
}
# echo "---initSSHServer---" && initSSHServer


mkdir -p /usr/local/repos && cd /usr/local/repos
    src=/usr/local/repos/kubectx && dest=/usr/local/bin
    ln -s $src/kubectx $dest/kkx
    ln -s $src/kubens $dest/kkn

    #completion
    kubectl completion bash |sed "s^kubectl^kc^g" > /usr/local/repos/complete-kc.sh
    cat /usr/local/repos/kubectx/completion/kubens.bash |sed "s^kubens^kkn^g" > /usr/local/repos/complete-kkn.sh
    # helm completion bash |sed "s^helm^hm^g" > /usr/local/repos/helm-completion.sh
    # stern --completion=bash |sed "s^stern^sn^g" > /usr/local/repos/stern-completion.sh

#.bashrc
function bashrcPromot(){
file=$1
cat >> $file <<EOF
source /usr/share/bash-completion/bash_completion
source /usr/local/repos/complete-kc.sh
# source /usr/local/repos/helm-completion.sh
# source /usr/local/repos/stern-completion.sh

#source /usr/local/repos/kubectx.sh
source /usr/local/repos/complete-kkn.sh
source /usr/local/repos/kube-ps1/kube-ps1.sh
alias ll='ls -l'
alias kin='f(){ kc exec -it "$@" bash;  unset -f f; }; f'
PS1='[\u@\$(kube_ps1) \W]\$ '
source /usr/local/bin/krand
kkn default
EOF
# PS1='[\u@\h \$kube_ps1 \W]\$ '
}
bashrcPromot /root/.bashrc
# bashrcPromot /home/ctoper/.bashrc

# echo "export HELM_HOST=localhost:44134" >> /etc/profile
sed -i "s^KUBE_PS1_CTX_COLOR-red^KUBE_PS1_CTX_COLOR-green^g" /usr/local/repos/kube-ps1/kube-ps1.sh #alter | git pull

#replace dot-files
# mkdir -p /etc/skel
# \cp /root/.bashrc /etc/skel/.bashrc

#add user
# useradd -m -d /home/koper -s /bin/bash koper

clusterPodMode=/usr/local/bin/clusterPodMode && touch $clusterPodMode && chmod +x $clusterPodMode
cat > $clusterPodMode <<EOF
#gen-kubeconfig dropbear tiller
if [ "\$SSHD_ENABLE" = "true" ]; then
  #gen-kubeconfig
  #export TM_KUBECONFIG_PATH=/opt/gen-kubeconfig
  #gen-kubeconfig
  #export KUBECONFIG=\$TM_KUBECONFIG_PATH
  
  #owner by ctoper: for kkn usage.
  #chmod 777 /opt #for: error: open /opt/gen-kubeconfig.lock: permission denied
  #chown ctoper:ctoper \$TM_KUBECONFIG_PATH

  #special priviledge, just outside common set.
  dest=/root/.bashrc
  #echo "export TM_KUBECONFIG_PATH=/opt/gen-kubeconfig" >> \$dest
  #echo "export KUBECONFIG=\\\$TM_KUBECONFIG_PATH" >> \$dest
  dest=/home/ctoper/.bashrc
  #echo "export TM_KUBECONFIG_PATH=/opt/gen-kubeconfig" >> \$dest
  #echo "export KUBECONFIG=\\\$TM_KUBECONFIG_PATH" >> \$dest

  #run dropbear
  runDropbear
  #dropbear -E -F -R -p 22 -b /etc/motd & ##already done in alpine-ext:weak


  ##tiller-local
  #nohup tiller -listen localhost:44134 > /tmp/log-tiller.log 2>&1 &
fi
EOF

rm -f /build.sh