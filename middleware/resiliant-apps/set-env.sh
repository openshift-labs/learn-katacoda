#!/usr/bin/env bash
${HOME}/.launch.sh
cd ${HOME}/projects/modernize-apps-labs/monolith
git pull --quiet

# install istio
cd ${HOME}
curl -kL https://git.io/getLatestIstio | sed 's/curl/curl -k /g' | ISTIO_VERSION=0.3.0 sh -
export PATH="$PATH:${HOME}/istio-0.3.0/bin"
cd ${HOME}/istio-0.3.0
oc adm policy add-scc-to-user anyuid -z istio-ingress-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z default -n istio-system
oc adm policy add-scc-to-user privileged -z default -n monolith
oc apply -f install/kubernetes/istio.yaml
oc adm policy add-cluster-role-to-user cluster-admin admin

# enable initializer auto sidecar injector
# oc apply -f install/kubernetes/istio-initializer.yaml

# install sample app
oc new-project bookinfo
oc adm policy add-scc-to-user privileged -z default -n bookinfo
cd ${HOME}/istio-0.3.0
oc apply -f <(istioctl kube-inject -f samples/bookinfo/kube/bookinfo.yaml)
