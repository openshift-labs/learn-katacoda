You can easily uninstall your operator by first removing the ArgoCD Custom Resource:

```
oc delete argocd example-argocd
```{{execute}}

Removing the ArgoCD Custom Resource, should remove all of the Operator's Operands:

```
oc get deployments
```{{execute}}

And then uninstalling the Operator:

```
oc delete -f argocd-subscription.yaml
ARGOCD_CSV=`oc get csv -o jsonpath={$.items[0].metadata.name}`
oc delete csv $ARGOCD_CSV
```{{execute}}


Once the Subscription and ClusterServiceVersion have been removed, the Operator and associated artifacts will be removed from the cluster:

```
oc get pods
oc get roles
```{{execute}}