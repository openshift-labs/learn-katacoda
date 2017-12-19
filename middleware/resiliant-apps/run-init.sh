#!/usr/bin/env bash
ssh root@host01 "mkdir -p /root/projects && cd /root/projects && git clone https://github.com/RedHat-Middleware-Workshops/modernize-apps-labs"
ssh root@host01 "setenforce 0 || true"
ssh root@host01 "mkdir /tmp/pv-01 /tmp/pv-02 /tmp/pv-03"
ssh root@host01 "chmod 0777 /tmp/pv-01 /tmp/pv-02 /tmp/pv-03"
ssh root@host01 "oc create -f /root/volumes.json"
#ssh root@host01 "docker pull schtool/foo:latest"
#ssh root@host01 "docker pull schtool/foo2:latest"
ssh root@host01 'for i in {1..200}; do oc policy add-role-to-user system:image-puller system:anonymous && break || sleep 1; done'