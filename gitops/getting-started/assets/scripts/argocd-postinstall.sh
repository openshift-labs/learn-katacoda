#!/bin/bash

cat <<EOF
=======================
=  SETTING UP LAB ENV =
=  errors are normal  =
=======================
EOF
#
## Login as admin
oc login --insecure-skip-tls-verify -u admin -p admin

#
## Check if the operator resource is there
if [[ ! -f resources/operator-install ]]; then
    echo "ERROR: Operator install resource not found!"
fi

#
## Install the OpenShift GitOps via Operator
oc apply -k resources/operator-install

#
## Wait until the deployment  appears
until oc wait --for=condition=available --timeout=60s deploy argocd-cluster-server -n openshift-gitops
do
    sleep 5
done

#
## Wait for the rollout to finish
oc rollout status deploy argocd-cluster-server -n openshift-gitops

#
## Installs the argocd CLI tool.
wget -q -O /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v1.8.7/argocd-linux-amd64
if [[ -f /usr/local/bin/argocd ]] ; then
    chmod +x /usr/local/bin/argocd
else
    echo "FATAL: ArgoCD cli failed to download"
fi

#
## This patches the Argo CD Controller in the following ways
##  - Ignores .spec.host field in routes
##  - Uses SSL edge termination because of Katacoda
##  - Uses Argo CD version 1.8.7
oc patch argocd argocd-cluster -n openshift-gitops --type=merge \
-p='{"spec":{"resourceCustomizations":"route.openshift.io/Route:\n  ignoreDifferences: |\n    jsonPointers:\n    - /spec/host\n","server":{"insecure":true,"route":{"enabled":true,"tls":{"insecureEdgeTerminationPolicy":"Redirect","termination":"edge"}}},"version":"v1.8.7"}}'

#
##  Sleep here because CRC is slow to start the rollout process
sleep 5

#
## Wait for the rollout of a new controller
oc rollout status deploy argocd-cluster-server -n openshift-gitops

#
## This gives the serviceAccount for ArgoCD the ability to manage the cluster.
oc adm policy add-cluster-role-to-user cluster-admin -z argocd-cluster-argocd-application-controller -n openshift-gitops

#
## This recycles the pods to make sure the new configurations took.
oc delete pods -l app.kubernetes.io/name=argocd-cluster-server -n openshift-gitops

#
## Wait for rollout of new pods and the deployment to be available
until oc wait --for=condition=available --timeout=60s deploy argocd-cluster-server -n openshift-gitops ;
do
    sleep 10
done
oc rollout status deploy argocd-cluster-server -n openshift-gitops

#
## Sleep here because CRC is slow on the rollout process
sleep 5

#
## Login to argocd locally for the user.
argoRoute=$(oc get route argocd-cluster-server -n openshift-gitops -o jsonpath='{.spec.host}{"\n"}')
argoUser=admin
argoPass=$(oc get secret/argocd-cluster-cluster -n openshift-gitops -o jsonpath='{.data.admin\.password}' | base64 -d)
argocd login --insecure --grpc-web --username ${argoUser} --password ${argoPass} ${argoRoute}
##  
##