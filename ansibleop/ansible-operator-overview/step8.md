Now that we have deployed our operator, let's create a CR and deploy an instance
of memcached.

There is a sample CR in the scaffolding created as part of the Operator SDK:

```YAML
apiVersion: cache.example.com/v1alpha1
kind: Memcached
metadata:
  name: example-memcached
spec:
  # Add fields here
  size: 3
```

Let's go ahead and apply this in our Tutorial project to deploy 3 memcached pods,
using our operator:

## Create a Memcached CR

Modify `deploy/crds/cache_v1alpha1_memcached_cr.yaml` as shown and create a `Memcached` custom resource:

<pre class="file" data-filename="/root/tutorial/memcached-operator/deploy/crds/cache_v1alpha1_memcached_cr.yaml" data-target="replace">
apiVersion: cache.example.com/v1alpha1
kind: Memcached
metadata:
  name: example-memcached
spec:
  size: 3
</pre>

`oc create -f deploy/crds/cache_v1alpha1_memcached_cr.yaml --as system:admin`{{execute}}

Ensure that the memcached-operator creates the deployment for the CR:

<small>
```sh
$ oc get deployment --as system:admin
NAME                 DESIRED CURRENT UP-TO-DATE AVAILABLE AGE
memcached-operator   1       1       1          1         2m
example-memcached    3       3       3          3         1m
```
</small>

Check the pods to confirm 3 replicas were created:

<small>
```sh
$ oc get pods
NAME                                 READY STATUS  RESTARTS AGE
example-memcached-6fd7c98d8-7dqdr    1/1   Running 0        1m
example-memcached-6fd7c98d8-g5k7v    1/1   Running 0        1m
example-memcached-6fd7c98d8-m7vn7    1/1   Running 0        1m
memcached-operator-7cc7cfdf86-vvjqk  1/1   Running 0        2m
```
</small>

## Update the size

Change the `spec.size` field in the memcached CR from 3 to 4 and apply the
change:

<pre class="file"
 data-filename="/root/tutorial/memcached-operator/deploy/crds/cache_v1alpha1_memcached_cr.yaml"
  data-target="replace">
apiVersion: cache.example.com/v1alpha1
kind: Memcached
metadata:
  name: example-memcached
spec:
  size: 4
</pre>

`oc apply -f deploy/crds/cache_v1alpha1_memcached_cr.yaml --as system:admin`{{execute}}

Confirm that the operator changes the deployment size:

<small>
```sh
$ oc get deployment --as system:admin
NAME               DESIRED CURRENT UP-TO-DATE AVAILABLE AGE
example-memcached  4       4       4          4         5m
```
</small>

### Cleanup

Clean up the resources:

`oc delete -f deploy/crds/cache_v1alpha1_memcached_cr.yaml --as system:admin`{{execute}}

`oc delete -f deploy/operator.yaml`{{execute}}

Verify that the memcached-operator is no longer running:

`oc get deployment`{{execute}}

Now let's take a look at using the built-in local install functionality of the SDK.  
