#!/bin/bash
#
#********************************************************************
#Author:                songliangcheng
#QQ:                    2192383945
#Date:                  2022-11-03
#FileName：             04-ipvs.sh
#URL:                   http://blog.mykernel.cn
#Description：          A test toy
#Copyright (C):        2022 All rights reserved
#********************************************************************
source env.sh

if is_ubuntu; then
  apt install ipset ipvsadm -y
else 
  color "其他系统未实现" 1; exit
fi

modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack
lsmod | grep -e ip_vs -e nf_conntrack
