#!/bin/bash
#
## Various postinstall steps needed for the Katacoda environment.

#
## Check if you're admin. If not, exit.
if ! oc get ns openshift-gitops -o name 2>&1 >/dev/null ; then
    echo "ERROR: Please ensure that you're logged in as admin and that the Operator was installed"
    exit 3
fi

#
## Installs the argocd CLI tool.
wget -q -O /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v1.8.7/argocd-linux-amd64
if [[ -f /usr/local/bin/argocd ]] ; then
    chmod +x /usr/local/bin/argocd
else
    echo "FATAL: ArgoCD cli failed to download"
fi
# 
## This patches the ArgoCD Controller to ignore the .spec.host field
## in the Route objects. This is because Routes will always be different
## on Katacoda.
oc patch argocd argocd-cluster -n openshift-gitops --type=json \
-p='[{"op": "add", "path": "/spec/resourceCustomizations", "value":"route.openshift.io/Route:\n  ignoreDifferences: |\n    jsonPointers:\n    - /spec/host\n"}]'

#
## This patches the ArgoCD Controller to use SSL edge termination. this
## is because how Katacoda handles routes.
oc patch argocd argocd-cluster -n openshift-gitops --type=merge \
-p='{"spec":{"server":{"insecure":true,"route":{"enabled":true,"tls":{"insecureEdgeTerminationPolicy":"Redirect","termination":"edge"}}}}}'

#
## This patches the ArgoCD Controller to a version that has helm
oc patch argocd argocd-cluster -n openshift-gitops --type=merge \
-p='{"spec":{"version":"v1.8.7"}}'

#
## This gives the serviceAccount for ArgoCD the ability to manage the cluster.
oc adm policy add-cluster-role-to-user cluster-admin -z argocd-cluster-argocd-application-controller -n openshift-gitops

#
## This recycles the pods to make sure the new configurations took.
oc delete pods -l app.kubernetes.io/name=argocd-cluster-server -n openshift-gitops

#
## Wait for rollout of new pods and the deployment to be available
until oc wait --for=condition=available --timeout=60s deploy argocd-cluster-server -n openshift-gitops;
do
    sleep 10
done
oc rollout status deploy argocd-cluster-server -n openshift-gitops

#
## Login to argocd locally for the user.
argoRoute=$(oc get route argocd-cluster-server -n openshift-gitops -o jsonpath='{.spec.host}{"\n"}')
argoUser=admin
argoPass=$(oc get secret/argocd-cluster-cluster -n openshift-gitops -o jsonpath='{.data.admin\.password}' | base64 -d)
argocd login --insecure --grpc-web --username ${argoUser} --password ${argoPass} ${argoRoute}
##  
##