Let's now update the Memcached `example` Custom Resource and increase the desired number of replicas to `3`:

```
oc patch memcached memcached-sample --type='json' -p '[{"op": "replace", "path": "/spec/statefulset/replicas", "value":4}]'
```{{execute}}
<br>
Verify that the Memcached Stateful Set is creating one additional pods:

```
oc get pods
```{{execute}}
