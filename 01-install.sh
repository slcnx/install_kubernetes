#!/bin/bash
#
#********************************************************************
#Author:                songliangcheng
#QQ:                    2192383945
#Date:                  2022-11-03
#FileName：             install.sh
#URL:                   http://blog.mykernel.cn
#Description：          A test toy
#Copyright (C):        2022 All rights reserved
#********************************************************************

source env.sh

if ! which docker &> /dev/null; then
  curl -sSL https://get.daocloud.io/docker | sh
fi
color "安装docker" 0

if is_ubuntu; then
  curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
  apt update
  apt-get install -y apt-transport-https
  apt install kubeadm=1.25.3-00 kubectl=1.25.3-00 kubelet=1.25.3-00 -y
  color "安装kubernetes" 0
else
  echo '
[kubernetes]
name=kubernetes
baseurl=https://mirrors.tuna.tsinghua.edu.cn/kubernetes/yum/repos/kubernetes-el7-$basearch
enabled=1
gpgcheck=0
' > /etc/yum.repos.d/kubernetes.repo
  yum install kubeadm-1.25.3-0 kubectl-1.25.3-0 kubelet-1.25.3-0 -y
  color "安装kubernetes" 0
fi

