Delete your Etcd cluster:

```
oc delete etcdcluster example-etcd-cluster
```{{execute}}
<br>
Delete the Etcd Operator:

```
oc delete deployment etcd-operator
```{{execute}}
<br>
Delete the Etcd CRD:

```
oc delete crd etcdclusters.etcd.database.coreos.com
```{{execute}}
<br>
