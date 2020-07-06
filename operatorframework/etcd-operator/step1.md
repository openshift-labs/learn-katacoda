Let's begin by creating a new project called `myproject`:

```
oc new-project myproject
```{{execute}}
<br>
Create the Custom Resource Definition (CRD) for the Etcd Operator:

```
cat > etcd-operator-crd.yaml<<EOF
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: etcdclusters.etcd.database.coreos.com
spec:
  group: etcd.database.coreos.com
  names:
    kind: EtcdCluster
    listKind: EtcdClusterList
    plural: etcdclusters
    shortNames:
    - etcdclus
    - etcd
    singular: etcdcluster
  scope: Namespaced
  version: v1beta2
  versions:
  - name: v1beta2
    schema:
      openAPIV3Schema:
        type: object
        x-kubernetes-preserve-unknown-fields: true
    served: true
    storage: true
EOF
```{{execute}}
<br>
```
oc create -f etcd-operator-crd.yaml
```{{execute}}
<br>
Verify the CRD was successfully created.

```
oc get crd etcdclusters.etcd.database.coreos.com
```{{execute}}
