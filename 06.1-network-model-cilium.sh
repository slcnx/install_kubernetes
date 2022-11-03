#!/bin/bash
#
#********************************************************************
#Author:                songliangcheng
#QQ:                    2192383945
#Date:                  2022-11-03
#FileName：             06-network-model.sh
#URL:                   http://blog.mykernel.cn
#Description：          A test toy
#Copyright (C):        2022 All rights reserved
#********************************************************************



#https://kubernetes.io/docs/concepts/cluster-administration/networking/#how-to-implement-the-kubernetes-networking-model


# https://github.com/cilium/cilium support EBPF

prerequisite() {
  is_ok=$(uname -r | awk -F. '{if ($1>4 || ($1>=4&&$2>=9&&$3>=17)){print "ok"}}')
  [ "$is_ok" == "ok" ] || {
    echo "kernel版本需要4.9.17之上"
    exit
  }
}

prerequisite

# 安装helm
tar xvf helm-v3.10.1-linux-amd64.tar.gz -C /opt/
install /opt/linux-amd64/helm  /usr/local/bin/




# 安装cilium
helm repo add cilium https://helm.cilium.io/ 
helm install cilium cilium/cilium --version 1.12.3 --namespace kube-system --set k8s.requireIPv4PodCIDR=true


# 配置pod cidr
# ... 略 ...
kubectl delete pod -A -l name=cilium-operator
kubectl delete pod -n kube-system    -l k8s-app=cilium --force --grace-period=0


# 检验
CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/master/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}

cilium status


# 清理pod
kubectl get pods --all-namespaces -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name,HOSTNETWORK:.spec.hostNetwork --no-headers=true | grep '<none>' | awk '{print "-n "$1" "$2}' | xargs -L 1 -r kubectl delete pod


# 安装ui
cilium hubble enable --ui
cilium hubble ui



# 卸载
cilium uninstall
helm uninstall cilium -n kube-system
kubectl delete deploy -n kube-system   hubble-relay
kubectl delete deploy -n kube-system   hubble-ui

ip link delete cilium_vxlan
ip link delete cilium_net

