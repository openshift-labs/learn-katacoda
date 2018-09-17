#!/bin/bash
until (oc status &> /dev/null); do sleep 1; done

rm -rf /root/projects/* /root/temp-pom.xml /root/projects/incubator-openwhisk-devtools

wget -c https://github.com/istio/istio/releases/download/1.0.2/istio-1.0.2-linux.tar.gz -P /root/installation

tar -zxvf /root/installation/istio-1.0.2-linux.tar.gz -C /root/installation

oc login -u system:admin; oc adm policy add-cluster-role-to-user cluster-admin admin

oc adm policy add-cluster-role-to-user cluster-admin developer
oc adm policy add-scc-to-user anyuid -z istio-ingress-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z default -n istio-system

oc apply -f /root/installation/istio-1.0.2/install/kubernetes/helm/istio/templates/crds.yaml
oc apply -f /root/installation/istio-1.0.2/install/kubernetes/istio-demo.yaml

oc expose svc istio-ingressgateway -n istio-system
oc expose svc servicegraph -n istio-system
oc expose svc grafana -n istio-system
oc expose svc prometheus -n istio-system
oc expose svc tracing -n istio-system
