#!/bin/bash
hostname -I | tr ' ' '\n' | awk NF | awk '{print $1 " master"}' | tee -a /etc/hosts
systemctl restart dnsmasq
setenforce 0

until (oc status &> /dev/null); do sleep 1; done

git --work-tree=/root/projects/istio-tutorial/ --git-dir=/root/projects/istio-tutorial/.git fetch
git --work-tree=/root/projects/istio-tutorial/ --git-dir=/root/projects/istio-tutorial/.git checkout katacoda
make -f /root/projects/istio-tutorial/Makefile
