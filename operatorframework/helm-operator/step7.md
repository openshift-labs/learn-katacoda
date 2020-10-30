Let's now update the CockroachDB `example` Custom Resource and increase the desired number of replicas to `3`:

```
oc patch cockroachdb cockroachdb-sample --type='json' -p '[{"op": "replace", "path": "/spec/statefulset/replicas", "value":3}]'
```{{execute}}
<br>
Verify that the CockroachDB Stateful Set is creating two additional pods:

```
oc get pods -l app.kubernetes.io/component=cockroachdb
```{{execute}}
<br>
The CockroachDB UI should now reflect these additional nodes as well.
