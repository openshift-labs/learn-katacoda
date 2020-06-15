Ensure you are currently scoped to the `myproject` Namespace:

```
oc project myproject
```{{execute}}

Create an Etcd cluster by referring to the new Custom Resource, `EtcdCluster`, defined in the Custom Resource Definition on Step 1:

```
cat > etcd-operator-cr.yaml<<EOF
apiVersion: etcd.database.coreos.com/v1beta2
kind: EtcdCluster
metadata:
  name: example-etcd-cluster
spec:
  size: 3
  version: 3.1.10
EOF
```{{execute}}
<br>
```
oc create -f etcd-operator-cr.yaml
```{{execute}}
<br>
Verify the cluster object was created:

```
oc get etcdclusters
```{{execute}}
<br>
Watch the pods in the Etcd cluster get created:

```
oc get pods -l etcd_cluster=example-etcd-cluster -w
```{{execute}}
<br>
Verify the cluster has been exposed via a ClusterIP service:

```
oc get services -l etcd_cluster=example-etcd-cluster
```{{execute}}
<br>
