Our Memcached controller creates pods containing OwnerReferences in their `metadata` section. This ensures they will be removed upon deletion of the `memcached-sample` CR.

Observe the OwnerReference set on a Memcached's pod:

```
oc get pods -o yaml | grep ownerReferences -A10
```{{execute}}
<br>
Delete the memcached-sample Custom Resource:

```
oc delete memcached memcached-sample
```{{execute}}

Thanks to OwnerReferences, all of the pods should be deleted:

```
oc get pods
```{{execute}}