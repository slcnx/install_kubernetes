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
if ! go version; then 
tar xvf go1.19.3.linux-amd64.tar.gz -C /opt/
curl -L https://gitee.com/slcnx/post-precompile/raw/master/post-precompile.sh | sed  's/\r//' |  bash -s  -- -bp /opt/go/
export PATH=/opt/go/bin:/opt/go/sbin:$PATH
fi



#git clone https://github.com/Mirantis/cri-dockerd.git
if ! systemctl cat cri-docker.service; then
cd cri-dockerd
mkdir bin
go build -o bin/cri-dockerd
mkdir -p /usr/local/bin
install -o root -g root -m 0755 bin/cri-dockerd /usr/local/bin/cri-dockerd
cp -a packaging/systemd/* /etc/systemd/system
sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
cp cri-docker.service /etc/systemd/system/cri-docker.service
systemctl daemon-reload
systemctl enable cri-docker.service
systemctl start cri-docker.service
systemctl status cri-docker.service
fi


echo "
cri-dockerd using sock: unix:///var/run/cri-dockerd.sock
"
