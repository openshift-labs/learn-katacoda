Open a new terminal window and navigate to the `cockroachdb-operator` top-level directory:

```
cd $GOPATH/src/github.com/redhat/cockroachdb-operator
```{{execute}}
Before applying the CockroachDB Custom Resource, observe the CockroachDB Helm Chart `values.yaml`:

[CockroachDB Helm Chart Values.yaml file](https://github.com/helm/charts/blob/master/stable/cockroachdb/values.yaml)

Update the CockroachDB Custom Resource at `go/src/github.com/redhat/cockroachdb-operator/deploy/crds/charts_v1alpha1_cockroachdb_cr.yaml` with the following values:

* `spec.Replicas: 1`
* `spec.Storage: 1Gi`
* `spec.StorageClass: local-storage`

<pre class="file"
 data-filename="/root/tutorial/go/src/github.com/redhat/cockroachdb-operator/deploy/crds/charts_v1alpha1_cockroachdb_cr.yaml"
  data-target="replace">
apiVersion: charts.helm.k8s.io/v1alpha1
kind: Cockroachdb
metadata:
  name: example
spec:
  Replicas: 1
  Storage: "1Gi"
  StorageClass: local-storage
</pre>

After updating the CockroachDB Custom Resource with our desired spec, apply it to the cluster:

```
oc apply -f deploy/crds/charts_v1alpha1_cockroachdb_cr.yaml
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
oc get pods -l chart=cockroachdb-2.1.11
```{{execute}}
<br>
Confirm that the CockroachDB "internal" and "public" ClusterIP Service were created:

```
oc get services
```{{execute}}
