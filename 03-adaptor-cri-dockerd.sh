#!/bin/bash
#
#********************************************************************
#Author:                songliangcheng
#QQ:                    2192383945
#Date:                  2022-11-03
#FileName：             03-adaptor-cri-dockerd.sh
#URL:                   http://blog.mykernel.cn
#Description：          A test toy
#Copyright (C):        2022 All rights reserved
#********************************************************************
source env.sh
if is_ubuntu; then
  test -f cri-dockerd_0.2.6.3-0.ubuntu-jammy_amd64.deb || wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.2.6/cri-dockerd_0.2.6.3-0.ubuntu-$(lsb_release -cs)_amd64.deb
  dpkg -i cri-dockerd_0.2.6.3-0.ubuntu-jammy_amd64.deb
else
  test -f cri-dockerd-0.2.6-3.el7.x86_64.rpm || wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.2.6/cri-dockerd-0.2.6-3.el7.x86_64.rpm
  rpm -i cri-dockerd-0.2.6-3.el7.x86_64.rpm
fi

cp cri-docker.service /etc/systemd/system/cri-docker.service
systemctl daemon-reload
systemctl enable cri-docker.service
systemctl restart cri-docker.service
systemctl is-active cri-docker.service
echo "
cri-dockerd using sock: unix:///var/run/cri-dockerd.sock
"
color "cri-docker安装" 0
