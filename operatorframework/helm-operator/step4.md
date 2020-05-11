Open a new terminal window and navigate to the `cockroachdb-operator` top-level directory:

```
cd $GOPATH/src/github.com/redhat/cockroachdb-operator
```{{execute}}
Before applying the CockroachDB Custom Resource, observe the CockroachDB Helm Chart `values.yaml`:

[CockroachDB Helm Chart Values.yaml file](https://github.com/helm/charts/blob/master/stable/cockroachdb/values.yaml)

Update the CockroachDB Custom Resource at `go/src/github.com/redhat/cockroachdb-operator/deploy/crds/charts.helm.k8s.io_v1alpha1_cockroachdb_cr.yaml` with the following values:

* `spec.statefulset.replicas: 1`
* `spec.storage.persistentVolume.size: 1Gi`
* `spec.storage.persistentVolume.storageClass: local-storage`

<pre class="file">
apiVersion: charts.helm.k8s.io/v1alpha1
kind: Cockroachdb
metadata: 
  name: example
spec: 
  statefulset: 
    replicas: 1
  storage: 
    persistentVolume: 
      size: 1Gi
      storageClass: local-storage
</pre>

You can easily update this file by running the following command:

```
wget -q https://raw.githubusercontent.com/openshift-labs/learn-katacoda/master/operatorframework/helm-operator/assets/charts.helm.k8s.io_v1alpha1_cockroachdb_cr.yaml -O deploy/crds/charts.helm.k8s.io_v1alpha1_cockroachdb_cr.yaml
```{{execute}}
<br>
After updating the CockroachDB Custom Resource with our desired spec, apply it to the cluster:

```
oc apply -f deploy/crds/charts.helm.k8s.io_v1alpha1_cockroachdb_cr.yaml
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
