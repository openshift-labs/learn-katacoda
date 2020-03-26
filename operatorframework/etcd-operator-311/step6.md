Let's change the size of the Etcd `example-etcd-cluster` CR. The Etcd Operator pod will detect the CR `spec.size` change and modify the number of pods in the cluster:

```
oc patch etcdcluster example-etcd-cluster --type='json' -p '[{"op": "replace", "path": "/spec/size", "value":5}]'
```{{execute}}
<br>

Let's change the version of our `example-etcd-cluster` CR. The etcd-operator pod will detect the CR `spec.version` change and create a new cluster with the newly specified image:

```
oc patch etcdcluster example-etcd-cluster --type='json' -p '[{"op": "replace", "path": "/spec/version", "value":3.2.13}]'
```{{execute}}
<br>
