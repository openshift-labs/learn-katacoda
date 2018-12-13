Delete your Etcd cluster:

```
kubectl delete etcdcluster example-etcd-cluster
```{{execute}}
<br>
Delete the Etcd Operator:

```
kubectl delete deployment etcd-operator
```{{execute}}
<br>
Delete the Etcd CRD:

```
oc delete crd etcdclusters.etcd.database.coreos.com
```{{execute}}
<br>