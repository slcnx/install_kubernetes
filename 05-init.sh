#!/bin/bash
#
#********************************************************************
#Author:                songliangcheng
#QQ:                    2192383945
#Date:                  2022-11-03
#FileName：             05-init.sh
#URL:                   http://blog.mykernel.cn
#Description：          A test toy
#Copyright (C):        2022 All rights reserved
#********************************************************************

IP=${1}
if [ -z "$IP" ]; then
  echo "
  ERROR: 使用以下格式 
    $0 your_local_ip
  "; exit
fi
if ! kubectl cluster-info; then
echo 'Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"' >> /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl daemon-reload

sed -i "s@LOCAL_IP@$IP@g" kubeadm.conf
kubeadm init --config ./kubeadm.conf --ignore-preflight-errors=swap

fi 
# check ipvs
kubeproxy=$(kubectl get  pod -n kube-system   -l k8s-app=kube-proxy -o jsonpath='{.items[*].metadata.name}')
kubectl logs  -n kube-system   $kubeproxy | grep 'ipvs Proxier'

# check dns
echo "dns configuration: "
kubectl get svc -A | grep kube-dns


# for test
#kubectl taint nodes --all node-role.kubernetes.io/control-plane-



# join node
echo "参考 join.conf, 完成加入node节点"
