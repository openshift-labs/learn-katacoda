#!/usr/bin/env bash

ISTIO_VERSION=0.5.0
ISTIO_HOME=${HOME}/istio-${ISTIO_VERSION}

curl -kL https://git.io/getLatestIstio | sed 's/curl/curl -k /g' | ISTIO_VERSION=${ISTIO_VERSION} sh -
export PATH="$PATH:${ISTIO_HOME}/bin"
cd ${ISTIO_HOME}

# workaround bug
sed -i 's/mtlsExcludedServices/#mtlsExcludedServices/' install/kubernetes/istio.yaml

oc new-project istio-system
oc adm policy add-scc-to-user anyuid -z istio-ingress-service-account
oc adm policy add-scc-to-user privileged -z istio-ingress-service-account
oc adm policy add-scc-to-user anyuid -z istio-egress-service-account
oc adm policy add-scc-to-user privileged -z istio-egress-service-account
oc adm policy add-scc-to-user anyuid -z istio-pilot-service-account
oc adm policy add-scc-to-user privileged -z istio-pilot-service-account
oc adm policy add-scc-to-user anyuid -z default
oc adm policy add-scc-to-user privileged -z default
oc adm policy add-cluster-role-to-user cluster-admin -z default
oc apply -f install/kubernetes/istio.yaml
oc create -f install/kubernetes/addons/prometheus.yaml
oc create -f install/kubernetes/addons/grafana.yaml
oc create -f install/kubernetes/addons/servicegraph.yaml
# workaround go bug
oc get deployment servicegraph -n istio-system -o json | sed 's/servicegraph:0.5.0/servicegraph:0.5.1/g' | oc replace -f - -n istio-system
oc apply -f https://raw.githubusercontent.com/jaegertracing/jaeger-kubernetes/master/all-in-one/jaeger-all-in-one-template.yml
oc expose svc grafana
oc expose svc servicegraph
oc expose svc jaeger-query
oc expose svc istio-ingress
oc expose svc prometheus
