Let's now update the CockroachDB `example` Custom Resource and increase the desired number of replicas to `3`:

```
oc patch cockroachdb example --type='json' -p '[{"op": "replace", "path": "/spec/Replicas", "value":3}]'
```{{execute}}
<br>
Verify that the CockroachDB Stateful Set is creating two additional pods:

```
oc get pods -l chart=cockroachdb-2.1.1
```{{execute}}
<br>
The CockroachDB UI should now reflect these additional nodes as well.



