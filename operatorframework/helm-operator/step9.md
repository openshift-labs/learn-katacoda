Cleanup the Helm-based Cockroachdb Operator by deleting the Custom Resource:

```
oc delete cockroachdb example
```

This will automatically remove the Cockroachdb Statefulset and associated Services:

```
oc get statefulset
oc get pods
oc get services
```