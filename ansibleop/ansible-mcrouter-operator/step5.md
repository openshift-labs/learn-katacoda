Thanks to the embedded StatefulSet controller our Memcached pool will handle creation of a new Pod in the event of failure.

Fetch one of Mcrouter's Memcached Pods from the pool:

```
MCROUTER_CACHE_0=`oc get pods -l app=mcrouter-cache -o jsonpath={$.items[0].metadata.name}`
echo $MCROUTER_CACHE_0
```{{execute}}
<br>

Delete the Pod:

```
oc delete pod $MCROUTER_CACHE_0
```{{execute}}
<br>
The Pod should respawn:

```
oc get pods -l app=mcrouter-cache
```{{execute}}
