If any Memcached member fails it gets restarted or recreated automatically by the Kubernetes infrastructure, and will rejoin the cluster automatically when it comes back up. You can test this scenario by killing any of the pods:

```
oc delete pods -l app.kubernetes.io/name=memcached
```{{execute}}
<br>
Watch the pods respawn:

```
oc get pods -l app.kubernetes.io/name=memcached
```{{execute}}
