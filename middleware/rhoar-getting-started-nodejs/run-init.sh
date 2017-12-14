#!/usr/bin/env bash
#ssh root@host01 "mkdir -p /root/projects && cd /root/projects && git clone https://github.com/openshift-katacoda/rhoar-getting-started"
ssh root@host01 "curl -k --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -"
ssh root@host01 "yum -y install nodejs npm"