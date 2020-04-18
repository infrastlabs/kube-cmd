#!/usr/bin/env bash

# Install  (htpasswd)
# dig:bind-tools
# jq coreutils graphviz bind-tools apache2-utils sysstat
apk add --no-cache openssh git lftp jq coreutils graphviz bind-tools apache2-utils sysstat 

#bin: kubectl | helm | stern
cd /usr/local/bin/ && ln -s kubectl kc && ln -s helm hm && ln -s stern sn

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
echo "---initSSHServer---" && initSSHServer


mkdir -p /opt/k8s-client && cd /opt/k8s-client
    src=/opt/k8s-client/kubectx && dest=/usr/local/bin
    ln -s $src/kubectx $dest/kkx
    ln -s $src/kubens $dest/kkn

    #completion
    kubectl completion bash |sed "s^kubectl^kc^g" > /opt/k8s-client/kubectl-completion.sh
    helm completion bash |sed "s^helm^hm^g" > /opt/k8s-client/helm-completion.sh
    stern --completion=bash |sed "s^stern^sn^g" > /opt/k8s-client/stern-completion.sh
    cat /opt/k8s-client/kubectx/completion/kubens.bash |sed "s^kubens^kkn^g" > /opt/k8s-client/kubens.sh

#.bashrc
cat >> /root/.bashrc <<EOF
source /usr/share/bash-completion/bash_completion
source /opt/k8s-client/kubectl-completion.sh
source /opt/k8s-client/helm-completion.sh
source /opt/k8s-client/stern-completion.sh

#source /opt/k8s-client/kubectx.sh
source /opt/k8s-client/kubens.sh
source /opt/k8s-client/kube-ps1/kube-ps1.sh
alias ll='ls -l'
alias kin='f(){ kc exec -it "$@" bash;  unset -f f; }; f'
PS1='[\u@\$(kube_ps1) \W]\$ '
source /usr/local/bin/krand
EOF
# PS1='[\u@\h \$kube_ps1 \W]\$ '


echo "export HELM_HOST=localhost:44134" >> /etc/profile
sed -i "s^KUBE_PS1_CTX_COLOR-red^KUBE_PS1_CTX_COLOR-green^g" /opt/k8s-client/kube-ps1/kube-ps1.sh #alter | git pull

#replace dot-files
rm -rf /etc/skel/.bashrc
cp /root/.bashrc /etc/skel/

#add user
useradd -m -d /home/koper -s /bin/bash koper
useradd -m -d /home/kapp -s /bin/bash kapp
epasswd root root #sample weak password, or use random
erpasswd koper
erpasswd kapp

#shadow: for jumpserver login
src=/etc/shadow && cp $src /etc/shadow_bk1
u=koper && sed -i "s^$u\:\!^$u\:no_login^g" $src
u=kapp && sed -i "s^$u\:\!^$u\:no_login^g" $src

rm -f /build.sh