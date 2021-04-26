#!/bin/bash
logfile=/root/.katacoda-argocd-setup.log

#
## Create logfile
touch ${logfile}

#
## Clear the screen in attempt to make it look neater
clear

#
## Start the setup process
echo -n "Setting up lab environment, please wait"

#
## Login as admin
oc login --insecure-skip-tls-verify -u admin -p admin >>${logfile} 2>&1
echo -n '.'

#
## Check if the operator resource is there
if [[ ! -d resources/operator-install ]]; then
    echo -e "\nERROR: Operator install resource not found!"
    exit 3
fi

#
## Install the OpenShift GitOps via Operator
oc apply -k resources/operator-install >>${logfile} 2>&1
echo -n '.'

#
## Wait until the deployment  appears
until oc wait --for=condition=available --timeout=60s deploy argocd-cluster-server -n openshift-gitops >>${logfile} 2>&1
do
    sleep 15
    echo -n '.'
done

#
## Wait for the rollout to finish
oc rollout status deploy argocd-cluster-server -n openshift-gitops >>${logfile} 2>&1
echo -n '.'

#
## Installs the argocd CLI tool.
wget -q -O /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v1.8.7/argocd-linux-amd64
if [[ -f /usr/local/bin/argocd ]] ; then
    chmod +x /usr/local/bin/argocd
    echo -n '.'
else
    echo -e "\nFATAL: ArgoCD cli failed to download"
fi

#
## This patches the Argo CD Controller in the following ways
##  - Ignores .spec.host field in routes
##  - Uses SSL edge termination because of Katacoda
##  - Uses Argo CD version 1.8.7
oc patch argocd argocd-cluster -n openshift-gitops --type=merge \
-p='{"spec":{"resourceCustomizations":"route.openshift.io/Route:\n  ignoreDifferences: |\n    jsonPointers:\n    - /spec/host\n","server":{"insecure":true,"route":{"enabled":true,"tls":{"insecureEdgeTerminationPolicy":"Redirect","termination":"edge"}}},"version":"v1.8.7"}}' >>${logfile} 2>&1
echo -n '.'

#
##  Sleep here because CRC is slow to start the rollout process
sleep 5

#
## Give the user some hope
echo -n "Halfway there"

#
## Wait for the rollout of a new controller
oc rollout status deploy argocd-cluster-server -n openshift-gitops >>${logfile} 2>&1
echo -n '.'

#
## This gives the serviceAccount for ArgoCD the ability to manage the cluster.
oc adm policy add-cluster-role-to-user cluster-admin -z argocd-cluster-argocd-application-controller -n openshift-gitops >>${logfile} 2>&1
echo -n '.'

#
## This recycles the pods to make sure the new configurations took.
oc delete pods -l app.kubernetes.io/name=argocd-cluster-server -n openshift-gitops >>${logfile} 2>&1
echo -n '.'

#
## Wait for rollout of new pods and the deployment to be available
until oc wait --for=condition=available --timeout=60s deploy argocd-cluster-server -n openshift-gitops >>${logfile} 2>&1
do
    sleep 20
    echo -n '.'
done
oc rollout status deploy argocd-cluster-server -n openshift-gitops >>${logfile} 2>&1
echo -n '.'

#
## Sleep here because CRC is slow on the rollout process
sleep 5

#
## Login to argocd locally for the user.
argoRoute=$(oc get route argocd-cluster-server -n openshift-gitops -o jsonpath='{.spec.host}{"\n"}')
argoUser=admin
argoPass=$(oc get secret/argocd-cluster-cluster -n openshift-gitops -o jsonpath='{.data.admin\.password}' | base64 -d)
argocd login --insecure --grpc-web --username ${argoUser} --password ${argoPass} ${argoRoute} >>${logfile} 2>&1

echo -n '.'

#
## Ready!
echo -e "\nReady!"
##  
##