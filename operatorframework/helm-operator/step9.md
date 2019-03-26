Delete the Cockroach DB cluster and all associated resources by  deleting the `example` Custom Resource:

```
oc delete cockroachdb example
```

Verify that the Stateful Set, pods, and services are removed:
```
oc get statefulset
oc get pods
oc get services
```