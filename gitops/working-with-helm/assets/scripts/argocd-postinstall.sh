#!/bin/bash
logfile=/root/.katacoda-argocd-setup.log
gitRepo="https://github.com/redhat-developer-demos/openshift-gitops-examples"


#
## Create logfile
touch ${logfile}

#
## Clear the screen in attempt to make it look neater
clear

#
## Start the setup process
echo -n "Setting up lab environment, please wait" | tee -a ${logfile}

#
## Git clone the examples repo. Check if it's there.
echo -n '.'
git clone -q ${gitRepo}
if [[ ! -d /root/${gitRepo##*/} ]]; then
    echo -e "\nERROR: Git clone for ${gitRepo} failed" | tee -a ${logfile}
    exit 3
fi

#
## Login as admin
oc login --insecure-skip-tls-verify -u admin -p admin >>${logfile} 2>&1
echo -n '.'

#
## Install the OpenShift GitOps via Operator
oc apply -f /root/${gitRepo##*/}/bootstrap/openshift-gitops-operator-sub.yaml >>${logfile} 2>&1
echo -n '.'

#
## Wait until the deployment  appears
until oc wait --for=condition=available --timeout=60s deploy openshift-gitops-server -n openshift-gitops >>${logfile} 2>&1
do
    sleep 5
    echo -n '.'
done

#
## Installs the argocd CLI tool.
wget -q -O /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.0.1/argocd-linux-amd64
if [[ -f /usr/local/bin/argocd ]] ; then
    chmod +x /usr/local/bin/argocd
    echo -n '.'
else
    echo -e "\nFATAL: ArgoCD cli failed to download" | tee -a ${logfile}
fi

#
## Installs the kustomize cli
wget -q -O /usr/local/src/kustomize_v4.0.5_linux_amd64.tar.gz https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.0.5/kustomize_v4.0.5_linux_amd64.tar.gz
tar -xzf /usr/local/src/kustomize_v4.0.5_linux_amd64.tar.gz -C /usr/local/bin/
if [[ -f /usr/local/bin/kustomize ]] ; then
    chmod +x /usr/local/bin/kustomize
    echo -n '.'
else
    echo -e "\nFATAL: Kustomize cli failed to download" | tee -a ${logfile}
fi

#
## Kustomize v4 requires kubectl v1.21
wget -O /usr/local/bin/kubectl -q https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kubectl
if [[ -f /usr/local/bin/kubectl ]] ; then
    chmod +x /usr/local/bin/kubectl
    echo -n '.'
else
    echo -e "\nFATAL: kubectl update failed to download" | tee -a ${logfile}
fi

#
## Install Helm CLI
wget -O /usr/local/src/helm.tar.gz -q https://get.helm.sh/helm-v3.6.0-linux-amd64.tar.gz
if [[ -f /usr/local/src/helm.tar.gz ]] ; then
    tar -xzf /usr/local/src/helm.tar.gz -C /usr/local/src/
    echo -n '.'
    mv /usr/local/src/linux-amd64/helm /usr/local/bin/
    echo -n '.'
    chmod +x /usr/local/bin/helm
else
    echo -e "\nFATAL: helm install failed" | tee -a ${logfile}
fi

#
## This patches the Argo CD Controller in the following ways
##  - Ignores .spec.host field in routes
##  - Uses SSL edge termination because of Katacoda
oc patch argocd openshift-gitops -n openshift-gitops --type=merge \
--patch $(/root/${gitRepo##*/}/bootstrap/openshift-gitops-operator-patch.yaml) >>${logfile} 2>&1
echo -n '.'

#
## Give the user some hope
echo -n "Halfway there"

#
## This gives the serviceAccount for ArgoCD the ability to manage the cluster.
oc adm policy add-cluster-role-to-user cluster-admin -z openshift-gitops-argocd-application-controller -n openshift-gitops >>${logfile} 2>&1
echo -n '.'

#
## This recycles the pods to make sure the new configurations took.
oc delete pods -l app.kubernetes.io/name=openshift-gitops-server -n openshift-gitops >>${logfile} 2>&1
echo -n '.'
sleep 5

#
## Wait for rollout of new pods and the deployment to be available
until oc wait --for=condition=available --timeout=60s deploy openshift-gitops-server -n openshift-gitops >>${logfile} 2>&1
do
    sleep 5
    echo -n '.'
done
oc rollout status deploy openshift-gitops-server -n openshift-gitops >>${logfile} 2>&1
echo -n '.'

#
## Login to argocd locally for the user.
argoRoute=$(oc get route openshift-gitops-server -n openshift-gitops -o jsonpath='{.spec.host}{"\n"}')
argoUser=admin
argoPass=$(oc get secret/openshift-gitops-cluster -n openshift-gitops -o jsonpath='{.data.admin\.password}' | base64 -d)
argocd login --insecure --grpc-web --username ${argoUser} --password ${argoPass} ${argoRoute} >>${logfile} 2>&1

echo -n '.'

#
## Ready!
echo -e "\nReady!" | tee -a ${logfile}
##  
##