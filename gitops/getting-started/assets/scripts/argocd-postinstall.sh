#!/bin/bash
#
## Various postinstall steps needed for the Katacoda environment.

#
## Check if you're admin. If not, exit.
if ! oc get ns openshift-gitop -o name 2>&1 >/dev/null ; then
    echo "ERROR: Please ensure that you're logged in as admin and that the Operator was installed"
    exit 3
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

##
##