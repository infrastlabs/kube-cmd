kubeconfig="--kubeconfig=/root/.kube/config"
tk1=/run/secrets/kubernetes.io/serviceaccount/token #ro_dir
tk2=/tmp/sa_token_OLD 
if [ -s $tk1 ]; then
    echo "env with sa, enter loop:";
    test -s $tk2 || cat $tk1> $tk2
    mkdir -p /root/.kube
    while true; do
        echo -n "."; ping -c 3 127.0.0.1 > /dev/null 2>&1
        sum1=$(md5sum $tk1 |awk '{print $1}')
        sum2=$(md5sum $tk2 |awk '{print $1}')
        if [ "$sum1" != "$sum2" ]; then
            echo -e "\nrefreshed token: $sum1 != $sum2"
            cat $tk1> $tk2 #refresh tk2
            TOKEN=$(cat $tk1); kubectl config set-credentials "sa" \
                --token=${TOKEN} $kubeconfig
        fi
    done
fi

echo "none sa, skip loop."; tail -f /dev/null