#!/bin/bash
ssh root@host01 "wget -c https://github.com/istio/istio/releases/download/0.6.0/istio-0.6.0-linux.tar.gz -P /root/installation"

ssh root@host01 "git --work-tree=/root/projects/istio-tutorial/ --git-dir=/root/projects/istio-tutorial/.git pull"
ssh root@host01 "rm -rf /root/projects/rhoar-getting-started /root/temp-pom.xml"

ssh root@host01 "tar -zxvf /root/installation/istio-0.6.0-linux.tar.gz -C /root/installation"

ssh root@host01 "sleep 10; oc login -u system:admin; oc adm policy add-cluster-role-to-user cluster-admin admin"

ssh root@host01 "oc adm policy add-cluster-role-to-user cluster-admin developer"
ssh root@host01 "oc adm policy add-scc-to-user anyuid -z istio-ingress-service-account -n istio-system"
ssh root@host01 "oc adm policy add-scc-to-user anyuid -z default -n istio-system"

ssh root@host01 "oc apply -f /root/installation/istio-0.6.0/install/kubernetes/istio.yaml"

ssh root@host01 "oc expose svc istio-ingress -n istio-system"


#Install Microservices
ssh root@host01 "oc new-project tutorial ; oc adm policy add-scc-to-user privileged -z default -n tutorial"

ssh root@host01 "mvn package -f /root/projects/istio-tutorial/customer/ -DskipTests"
ssh root@host01 "docker build -t example/customer /root/projects/istio-tutorial/customer/"
ssh root@host01 "oc apply -f <(/root/installation/istio-0.6.0/bin/istioctl kube-inject -f /root/projects/istio-tutorial/customer/src/main/kubernetes/Deployment.yml) -n tutorial"
ssh root@host01 "oc create -f /root/projects/istio-tutorial/customer/src/main/kubernetes/Service.yml -n tutorial"
ssh root@host01 "oc expose service customer -n tutorial"

ssh root@host01 "mvn package -f /root/projects/istio-tutorial/preference/ -DskipTests"
ssh root@host01 "docker build -t example/preference /root/projects/istio-tutorial/preference/"
ssh root@host01 "oc apply -f <(/root/installation/istio-0.6.0/bin/istioctl kube-inject -f /root/projects/istio-tutorial/preference/src/main/kubernetes/Deployment.yml) -n tutorial"
ssh root@host01 "oc create -f /root/projects/istio-tutorial/preference/src/main/kubernetes/Service.yml -n tutorial"

ssh root@host01 "mvn package -f /root/projects/istio-tutorial/recommendation/ -DskipTests"
ssh root@host01 "docker build -t example/recommendation:v1 /root/projects/istio-tutorial/recommendation/"
ssh root@host01 "oc apply -f <(/root/installation/istio-0.6.0/bin/istioctl kube-inject -f /root/projects/istio-tutorial/recommendation/src/main/kubernetes/Deployment.yml) -n tutorial"
ssh root@host01 "oc create -f /root/projects/istio-tutorial/recommendation/src/main/kubernetes/Service.yml -n tutorial"

