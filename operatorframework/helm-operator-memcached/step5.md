Let's now update the Memcached `example` Custom Resource and increase the desired number of replicas to `5`:

```
oc patch memcached memcached-sample -p '{"spec":{"replicaCount": 5}}' --type=merge
```{{execute}}

<br>
Verify that the Memcached Stateful Set is creating two additional pods:

```
oc get pods
```{{execute}}
