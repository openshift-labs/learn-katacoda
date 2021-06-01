Open a new terminal window and navigate to the `memcached-operator` top-level directory:

```
cd projects/memcached-operator
```{{execute}}
Before applying the Memcached Custom Resource, observe the Memcached Helm Chart `values.yaml`:

[Memcached Helm Chart Values.yaml file](https://github.com/helm/charts/blob/master/stable/memcached/values.yaml)

Update the Memcached Custom Resource at `go/src/github.com/redhat/cockroachdb-operator/deploy/crds/charts.helm.k8s.io_v1alpha1_memcached_cr.yaml` with the following values:

* `spec.replicaCount: 5`

<pre class="file">
apiVersion: charts.example.com/v1alpha1
kind: Memcached
metadata: 
  name: memcached-sample
spec: 
  statefulset: 
    replicas: 1
</pre>

You can easily update this file by running the following command:

```
\cp /tmp/charts_v1alpha1_cockroachdb.yaml config/samples/charts_v1alpha1_cockroachdb.yaml
```{{execute}}
<br>
After updating the CockroachDB Custom Resource with our desired spec, apply it to the cluster. Ensure you are currently scoped to the `myproject` Namespace:

```
oc project myproject
```{{execute}}

```
oc apply -f config/samples/charts_v1alpha1_cockroachdb.yaml
```{{execute}}
<br>
Confirm that the Custom Resource was created:

```
oc get cockroachdb
```{{execute}}
<br>
It may take some time for the environment to pull down the CockroachDB container image. Confirm that the Stateful Set was created:

```
oc get statefulset
```{{execute}}
<br>
Confirm that the Stateful Set's pod is currently running:

```
oc get pods -l app.kubernetes.io/component=cockroachdb
```{{execute}}
<br>
Confirm that the CockroachDB "internal" and "public" ClusterIP Service were created:

```
oc get services
```{{execute}}
