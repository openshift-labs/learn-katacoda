Our PodSet controller creates pods containing OwnerReferences in their metadata section. This ensures that they will be removed upon deletion of the podset-sample Custom Resource.

Observe the OwnerReference set on a Podset's pod:

```
oc get pods -o yaml | grep ownerReferences -A10
```{{execute}}
<br>
Delete the podset-sample Custom Resource:

```
oc delete podset podset-sample
```{{execute}}

All of the pods should now be removed:

```
oc get pods
```{{execute}}