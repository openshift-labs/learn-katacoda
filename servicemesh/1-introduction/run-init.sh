#!/bin/bash
wget -c https://github.com/istio/istio/releases/download/1.0.2/istio-1.0.2-linux.tar.gz -P /root/installation

rm -rf /root/projects/* /root/temp-pom.xml /root/projects/incubator-openwhisk-devtools
until $(oc status &> /dev/null); do sleep 1; done; 

oc adm policy add-cluster-role-to-user cluster-admin admin

#TODO TEMPORARY FIX
hostname -I | awk '{print $1 " master"}' | tee -a /etc/hosts; setenforce 0

