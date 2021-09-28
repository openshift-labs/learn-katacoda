In a new terminal, inspect the Custom Resource manifest:

```
cd $HOME/projects/memcached-operator
cat config/samples/cache_v1alpha1_memcached.yaml
```{{execute}}
<br>
Ensure your `kind: Memcached` Custom Resource (CR) is updated with `spec.size`

<pre class="file">
apiVersion: cache.example.com/v1alpha1
kind: Memcached
metadata:
  name: memcached-sample
spec:
  size: 3
</pre>

You can easily update this file by running the following command:

```
\cp /tmp/cache_v1alpha1_memcached.yaml config/samples/cache_v1alpha1_memcached.yaml
```{{execute}}
<br>
Ensure you are currently scoped to the `myproject` Namespace:

```
oc project myproject
```{{execute}}
<br>
Deploy your PodSet Custom Resource to the live OpenShift Cluster:

```
oc create -f config/samples/cache_v1alpha1_memcached.yaml
```{{execute}}
<br>
Verify the memcached exists:

```
oc get memcached
```{{execute}}
<br>
Verify the Memcached operator has created 3 pods:

```
oc get pods
```{{execute}}
<br>
Verify that status shows the name of the pods currently owned by the Memcached:

```
oc get memcached memcached-sample -o yaml
```{{execute}}
<br>
Increase the number of replicas owned by the Memcached:

```
oc patch memcached memcached-sample --type='json' -p '[{"op": "replace", "path": "/spec/size", "value":5}]'
```{{execute}}
<br>

Verify that we now have 5 running pods
```
oc get pods
```{{execute}}
