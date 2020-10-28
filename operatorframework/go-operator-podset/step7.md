Our PodSet controller creates pods containing OwnerReferences in their `metadata` section. This ensures they will be removed upon deletion of the `podset-sample` CR.

Observe the OwnerReference set on a Podset's pod:

```
oc get pods -o yaml | grep ownerReferences -A10
```{{execute}}
<br>
Delete the podset-sample Custom Resource:

```
oc delete podset podset-sample
```{{execute}}

Thanks to OwnerReferences, all of the pods should be deleted:

```
oc get pods
```{{execute}}