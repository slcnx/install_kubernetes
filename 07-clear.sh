#!/bin/bash
#
#********************************************************************
#Author:                songliangcheng
#QQ:                    2192383945
#Date:                  2022-11-22
#FileName：             07-clear.sh
#URL:                   http://blog.mykernel.cn
#Description：          A test toy
#Copyright (C):        2022 All rights reserved
#********************************************************************
kubeadm reset --cri-socket /var/run/cri-dockerd.sock
systemctl daemon-reload && systemctl restart kubelet  && iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
ipvsadm --clear
swapoff -a
