Create the etcdCluster manifest.

```
cat > etcd-cluster.yaml <<EOF
apiVersion: etcd.database.coreos.com/v1beta2
kind: EtcdCluster
metadata:
  name: example-etcd-cluster
spec:
  size: 3
EOF
```{{execute}}
<br>
Create the etcd-cluster.

```
oc create -f etcd-cluster.yaml
```{{execute}}
<br>

Confirm the cluster has been created:

```
oc get etcdcluster
oc get pods
```{{execute}}
<br>