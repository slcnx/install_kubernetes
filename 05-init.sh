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
source env.sh
IP=${1}
if [ -z "$IP" ]; then
  echo "
  ERROR: 使用以下格式 
    $0 your_local_ip
  "; exit
fi
if is_ubuntu; then
echo "Environment='KUBELET_EXTRA_ARGS=--fail-swap-on=false --hostname-override=$IP'" > /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
else
echo "KUBELET_EXTRA_ARGS='--fail-swap-on=false --hostname-override=$IP'" > /etc/sysconfig/kubelet
fi
systemctl daemon-reload
sed -i -r "s@(advertiseAddress:|name:).*@\1 $IP@g" kubeadm.conf
kubeadm init --config ./kubeadm.conf --ignore-preflight-errors=swap

mkdir -p $HOME/.kube
\cp /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config


# check ipvs
kubeproxy=$(kubectl get  pod -n kube-system   -l k8s-app=kube-proxy -o jsonpath='{.items[*].metadata.name}')
kubectl logs  -n kube-system   $kubeproxy | grep 'ipvs Proxier'

# check dns
echo "dns configuration: "
kubectl get svc -A | grep kube-dns


# for test
kubectl taint nodes --all node-role.kubernetes.io/control-plane-

# join node
echo "参考 join.conf, 完成加入node节点"
