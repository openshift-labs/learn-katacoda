Delete the CockroachDB cluster and all associated resources by deleting the `example` Custom Resource:

```
oc delete cockroachdb cockroachdb-sample
```{{execute}}
<br>
Verify that the Stateful Set, pods, and services are removed:

```
oc get statefulset
oc get pods
oc get services
```{{execute}}