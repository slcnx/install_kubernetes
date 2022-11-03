#!/bin/bash
#
#********************************************************************
#Author:                songliangcheng
#QQ:                    2192383945
#Date:                  2022-11-03
#FileName：             02-container.sh
#URL:                   http://blog.mykernel.cn
#Description：          A test toy
#Copyright (C):        2022 All rights reserved
#********************************************************************
# container prerequisites
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system


# install docker https://docs.docker.com/engine/install/#server
apt-get remove docker docker-engine docker.io containerd runc
apt-get update
apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

mkdir -p /etc/apt/keyrings
cat docker.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] http://172.16.59.144:8081/repository/ubuntu-docker/ \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
VERSION_STRING=5:20.10.21~3-0~ubuntu-focal
apt-get install docker-ce=$VERSION_STRING docker-ce-cli=$VERSION_STRING containerd.io docker-compose-plugin --fix-missing -y

