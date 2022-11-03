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


cat apt-key.gpg | apt-key add -
cp sources.list /etc/apt/sources.list
cp kubernetes.list /etc/apt/sources.list.d/kubernetes.list

apt update
apt-get install -y apt-transport-https
apt install kubeadm=1.25.3-00 kubectl=1.25.3-00 kubelet=1.25.3-00 -y


