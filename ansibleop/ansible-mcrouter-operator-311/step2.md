Now that the Mcrouter Operator is deployed, we can apply the `kind: McRouter` Custom Resource.

The Mcrouter Custom Resource contains a number of configurable options in the `spec` section.

```
# The image to run for the `mcrouter` Deployment.
mcrouter_image: devan2502/mcrouter:latest

# The port Mcrouter will run on.
mcrouter_port: 5000

# The image to run for the `memcached` StatefulSet.
memcached_image: memcached:1.5-alpine

# The size of the memcached pool.
memcached_pool_size: 3

# The port Memcached will run on.
memcached_port: 11211

# The memcached pool can be 'sharded' or 'replicated'.
# 'sharded' uses a key hashing algorithm to distribute Memcached sets and gets among Memcached Pods; this means a key foo may always go to pod A, while the key bar always goes to pod B.
# 'replicated' sends all Memcached sets to all Memcached pods, and distributes gets randomly.
pool_setup: replicated

# Set to '/var/mcrouter/fifos' to debug mcrouter with mcpiper.
debug_fifo_root: ''
```

Let's create an instance of Mcrouter that will create a replicated Memcached pool size of 2. This will create a Deployment consisting of 1 pod (`image: devan2502/mcrouter:latest` ) as well as a Memcached StatefulSet consists of 2 memcached pods (`memcached_image: memcached:1.5-alpine`).

```
apiVersion: mcrouter.example.com/v1alpha3
kind: Mcrouter
metadata:
  name: mcrouter
spec:
  mcrouter_image: devan2502/mcrouter:latest
  mcrouter_port: 5000
  memcached_image: memcached:1.5-alpine
  memcached_pool_size: 2
  memcached_port: 11211
  pool_setup: replicated # or 'sharded'
  debug_fifo_root: '' # set to '/var/mcrouter/fifos' for mcpiper
```

Before applying the Custom Resource (CR), open up a new terminal window and follow the logs for the `ansible` container. This will expose the standard Ansible stdout logs and we should see activity once the CR is created.

```
oc logs deploy/mcrouter-operator -c ansible -f
```{{execute}}
<br>
Run the following to apply the CR:

```
oc apply -f https://raw.githubusercontent.com/geerlingguy/mcrouter-operator/master/deploy/crds/mcrouter_v1alpha3_mcrouter_cr.yaml
```{{execute}}
<br>
Verify the Mcrouter CR now exists:

```
oc get mcrouter
```{{execute}}
<br>
Verify the `mcrouter` deployment pod:

```
oc get pod -l name=mcrouter-operator
```{{execute}}
<br>
The `mcrouter` Deployment Pod is exposed via a Service listening on the default memcached port, `11211`. Mcrouter will connect to the pool via the backend memcached instances residing in the pool via this Service.

```
oc get svc mcrouter-memcached
```{{execute}}
<br>
Verify the two `mcrouter` memcache instances are running:

```
oc get pods -l app=mcrouter-cache
```{{execute}}
