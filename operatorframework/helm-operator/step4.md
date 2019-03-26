Before applying the Cockroachdb Custom Resource, observe the Cockroachdb Helm Chart values yaml.

```
[CockroachDB Helm Chart Values.yaml file](https://github.com/helm/charts/blob/master/stable/cockroachdb/values.yaml)
```

Update the Cockroach Custom Resource (`deploy/crds/db_v1alpha1_cockroachdb_cr.yaml`) with the `spec.Replicas: 1`, `spec.Storage: 1Gi`, and `spec.StorageClass: localstorage` values (found in the original Helm Chart `values.yaml`):

<pre class="file"
 data-filename="/root/tutorial/go/src/github.com/cockroachdb-operator/deploy/crds/db_v1alpha1_cockroachdb_cr.yaml"
  data-target="replace">
apiVersion: db.example.org/v1alpha1
kind: Cockroachdb
metadata:
  name: example
spec:
  # Add fields here
  Replicas: 1
  Storage: "1Gi"
  StorageClass: local-storage
</pre>

After updating the Cockroachdb Custom Resource, create it:

```
oc create -f deploy/crds/db_v1alpha1_cockroachdb_cr.yaml
```{{execute}}
<br>
Confirm that the Custom Resource was properly created:

```
oc get cockroachdb
```{{execute}}
<br>
Confirm that the Cockroachdb StatefulSet was created:

```
oc get statefulset
```{{execute}}

Confirm that the Cockroachdb Internal and Public ClusterIP service were created:

```
oc get services
```{{execute}}