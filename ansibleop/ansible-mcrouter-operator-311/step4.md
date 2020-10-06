One simple way to verify Mcrouter Operator functionality is by changing the `memcached_pool_size` in the Mcrouter Custom Resource. Run the folllowing command to bump the pool size to `3` and then observe what happens in the cluster:

```
oc patch mcrouter mcrouter  --type='json' -p '[{"op": "replace", "path": "/spec/memcached_pool_size", "value":3}]'
```{{execute}}
<br>
After a few seconds, a new Memcached Pod should be added to the pool:

```
oc get pods -l app=mcrouter-cache
```{{execute}}
<br>
You should now see the additional Memcached instances reflected in Mcrouter's configuration string.

```
oc describe pod -l app=mcrouter | grep Command -A2
```{{execute}}