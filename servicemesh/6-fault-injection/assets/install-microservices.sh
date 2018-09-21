#!/bin/bash
echo "Waiting istio installation to complete for this scenario"
until $(oc get project istio-system &> /dev/null); do sleep 1; done

mkdir -p /root/projects/istio-tutorial
#TODO - Move to Katacoda branch
git clone https://github.com/redhat-developer-demos/istio-tutorial /root/projects/istio-tutorial

cp -Rvf /root/projects/istio-tutorial/recommendation/java/vertx /root/projects/istio-tutorial/recommendation-v2
git apply /root/recommendation-v2.diff --unsafe-paths --directory=/root/projects/istio-tutorial/

oc login -u system:admin

oc new-project tutorial
oc adm policy add-scc-to-user privileged -z default -n tutorial

mvn package -f /root/projects/istio-tutorial/customer/java/springboot -DskipTests
docker build -t example/customer /root/projects/istio-tutorial/customer/java/springboot
oc apply -f <(/root/installation/istio-1.0.2/bin/istioctl kube-inject -f /root/projects/istio-tutorial/customer/kubernetes/Deployment.yml) -n tutorial
oc create -f /root/projects/istio-tutorial/customer/kubernetes/Service.yml -n tutorial

mvn package -f /root/projects/istio-tutorial/preference/java/springboot -DskipTests
docker build -t example/preference:v1 /root/projects/istio-tutorial/preference/java/springboot
oc apply -f <(/root/installation/istio-1.0.2/bin/istioctl kube-inject -f /root/projects/istio-tutorial/preference/kubernetes/Deployment.yml) -n tutorial
oc create -f /root/projects/istio-tutorial/preference/kubernetes/Service.yml -n tutorial

mvn package -f /root/projects/istio-tutorial/recommendation/java/vertx -DskipTests
docker build -t example/recommendation:v1 /root/projects/istio-tutorial/recommendation/java/vertx
oc apply -f <(/root/installation/istio-1.0.2/bin/istioctl kube-inject -f /root/projects/istio-tutorial/recommendation/kubernetes/Deployment.yml) -n tutorial
oc create -f /root/projects/istio-tutorial/recommendation/kubernetes/Service.yml -n tutorial

mvn package -f /root/projects/istio-tutorial/recommendation-v2/ -DskipTests
docker build -t example/recommendation:v2 /root/projects/istio-tutorial/recommendation-v2/
oc apply -f <(/root/installation/istio-1.0.2/bin/istioctl kube-inject -f /root/projects/istio-tutorial/recommendation/kubernetes/Deployment-v2.yml) -n tutorial

oc expose service customer -n tutorial