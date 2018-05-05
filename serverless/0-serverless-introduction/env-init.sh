#!/bin/bash
ssh root@host01 "rm -rf /root/projects"
ssh root@host01 "mkdir -p /root/projects/ocf && mkdir -p /root/openwhisk/bin/"
ssh root@host01 "yum -y install wget tree"
ssh root@host01 "wget -c https://github.com/apache/incubator-openwhisk-cli/releases/download/latest/OpenWhisk_CLI-latest-linux-386.tgz -P /root/installation"
ssh root@host01 "tar -zxvf /root/installation/OpenWhisk_CLI-latest-linux-386.tgz -C /root/openwhisk/bin/"
ssh root@host01 "until $(oc status &> /dev/null); do sleep 1; done; oc adm policy add-cluster-role-to-user cluster-admin admin"
ssh root@host01 "mkdir -p ~/root/projects/getting-started"
