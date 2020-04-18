Now that we have deployed our Operator, let's create a CR and deploy an instance
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
using our Operator:

## Create a Memcached CR instance

Inspect `deploy/crds/cache_v1alpha1_memcached_cr.yaml`, and then use it to create a `Memcached` custom resource:

```yaml
# deploy/crds/cache_v1alpha1_memcached_cr.yaml
apiVersion: cache.example.com/v1alpha1
kind: Memcached
metadata:
  name: example-memcached
spec:
  size: 3
```

`oc create -f deploy/crds/cache_v1alpha1_memcached_cr.yaml`{{execute}}

## Check that the Memcached Operator works as intended 
Ensure that the memcached-operator creates the deployment for the CR:

<small>
```sh
$ oc get deployment
NAME                 DESIRED CURRENT UP-TO-DATE AVAILABLE AGE
memcached-operator   1       1       1          1         2m
example-memcached    3       3       3          3         1m
```
</small>

Check the pods to confirm 3 replicas were created:

<small>
```sh
$ oc get pods
NAME                                READY STATUS   RESTARTS AGE
example-memcached-6cc844747c-2hbln  1/1   Running  0        1m
example-memcached-6cc844747c-54q26  1/1   Running  0        1m
example-memcached-6cc844747c-7jfhc  1/1   Running  0        1m
memcached-operator-68b5b558c5-dxjwh 1/1   Running  0        2m
```
</small>

## Change the Memcached CR to deploy 4 replicas

Change the `spec.size` field in `deploy/crds/cache_v1alpha1_memcached_cr.yaml` from 3 to 4 and apply the
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

`oc apply -f deploy/crds/cache_v1alpha1_memcached_cr.yaml`{{execute}}

Confirm that the Operator changes the deployment size:

<small>
```sh
$ oc get deployment
NAME                DESIRED CURRENT  UP-TO-DATE  AVAILABLE  AGE
example-memcached   4       4        4           4          53s
memcached-operator  1       1        1           1          5m
```
</small>

Inspect the YAML list of 'memcached' resources in your project, noting that the 'spec.size' field is now set to 4.

`oc get memcached  -o yaml`{{execute}}

## Removing Memcached from the cluster 

First, delete the 'memcached' CR, which will remove the 4 Memcached pods and the associated deployment.

`oc delete -f deploy/crds/cache_v1alpha1_memcached_cr.yaml`{{execute}}

<small>
```sh
$ oc get pods
NAME                                 READY STATUS  RESTARTS AGE
memcached-operator-7cc7cfdf86-vvjqk  1/1   Running 0        8m
```
</small>

Then, delete the memcached-operator deployment.

`oc delete -f deploy/operator.yaml`{{execute}}

Finally, verify that the memcached-operator is no longer running.

`oc get deployment`{{execute}}

Now let's take a look at using the built-in 'local install' functionality of the SDK.  
