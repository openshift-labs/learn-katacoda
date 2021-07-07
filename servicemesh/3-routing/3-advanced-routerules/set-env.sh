#!/bin/bash

#TEMPORARY FIX for this image
hostname -I | tr ' ' '\n' | awk NF | awk '{print $1 " master"}' | tee -a /etc/hosts ; systemctl restart dnsmasq ; setenforce 0

git clone https://github.com/redhat-developer-demos/istio-tutorial/ /root/projects/istio-tutorial/ || true
git --work-tree=/root/projects/istio-tutorial/ --git-dir=/root/projects/istio-tutorial/.git fetch
git --work-tree=/root/projects/istio-tutorial/ --git-dir=/root/projects/istio-tutorial/.git checkout katacoda

until (oc status &> /dev/null); do sleep 1; done
make -i -f /root/projects/istio-tutorial/Makefile cleanup istio
/usr/local/bin/launch.sh
export PATH=$PATH:/root/installation/istio-1.0.5/bin/
clear
echo "Tutorial Ready."
