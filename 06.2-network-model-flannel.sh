#!/bin/bash
#
#********************************************************************
#Author:                songliangcheng
#QQ:                    2192383945
#Date:                  2022-11-03
#FileName：             06.2-network-model-flannel.sh
#URL:                   http://blog.mykernel.cn
#Description：          https://github.com/flannel-io/flannel#deploying-flannel-manually
#Copyright (C):        2022 All rights reserved
#********************************************************************

# 更新配置
cat <<'EOF'  
net-conf.json: |
    {
      "Network": "10.10.0.0/16",
      "Backend": {
        "Type": "vxlan",
        "DirectRouting": true
      }
    }
EOF

# 应用
kubectl apply -f kube-flannel.yml

# 生成ip
kubectl delete pod -A -l k8s-app=kube-dns
kubectl delete pod --all

