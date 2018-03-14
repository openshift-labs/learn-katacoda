#!/bin/bash
echo "Waiting istio installation to complete for this scenario"
until $(oc get project istio-system &> /dev/null); do sleep 1; done

cp -Rvf /root/projects/istio-tutorial/recommendation/java/ /root/projects/istio-tutorial/recommendation-v2
git apply /root/recommendation-v2.diff --directory=/root/projects/istio-tutorial/

oc login -u system:admin

oc new-project tutorial
oc adm policy add-scc-to-user privileged -z default -n tutorial

mvn package -f /root/projects/istio-tutorial/customer/java/ -DskipTests
docker build -t example/customer /root/projects/istio-tutorial/customer/java/
oc apply -f <(/root/installation/istio-0.6.0/bin/istioctl kube-inject -f /root/projects/istio-tutorial/customer/java/src/main/kubernetes/Deployment.yml) -n tutorial
oc create -f /root/projects/istio-tutorial/customer/java/src/main/kubernetes/Service.yml -n tutorial

mvn package -f /root/projects/istio-tutorial/preference/java/ -DskipTests
docker build -t example/preference /root/projects/istio-tutorial/preference/java/
oc apply -f <(/root/installation/istio-0.6.0/bin/istioctl kube-inject -f /root/projects/istio-tutorial/preference/java/src/main/kubernetes/Deployment.yml) -n tutorial
oc create -f /root/projects/istio-tutorial/preference/java/src/main/kubernetes/Service.yml -n tutorial

mvn package -f /root/projects/istio-tutorial/recommendation/java/ -DskipTests
docker build -t example/recommendation:v1 /root/projects/istio-tutorial/recommendation/java/
oc apply -f <(/root/installation/istio-0.6.0/bin/istioctl kube-inject -f /root/projects/istio-tutorial/recommendation/java/src/main/kubernetes/Deployment.yml) -n tutorial
oc create -f /root/projects/istio-tutorial/recommendation/java/src/main/kubernetes/Service.yml -n tutorial

mvn package -f /root/projects/istio-tutorial/recommendation-v2/ -DskipTests
docker build -t example/recommendation:v2 /root/projects/istio-tutorial/recommendation-v2/
oc apply -f <(/root/installation/istio-0.6.0/bin/istioctl kube-inject -f /root/projects/istio-tutorial/recommendation/java/src/main/kubernetes/Deployment-v2.yml) -n tutorial

oc expose service customer -n tutorial