#!/bin/bash
rm -rf /root/temp-pom.xml /root/projects/*

#TEMPORARY FIX for this image
hostname -I | tr ' ' '\n' | awk NF | awk '{print $1 " master"}' | tee -a /etc/hosts ; systemctl restart dnsmasq ; setenforce 0

until (oc status &> /dev/null); do sleep 1; done

git --work-tree=/root/projects/istio-tutorial/ --git-dir=/root/projects/istio-tutorial/.git fetch
git --work-tree=/root/projects/istio-tutorial/ --git-dir=/root/projects/istio-tutorial/.git checkout katacoda
make -i -f /root/projects/istio-tutorial/Makefile cleanup istio
rm -fR /root/projects/istio-tutorial
