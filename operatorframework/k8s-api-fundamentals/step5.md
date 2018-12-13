Begin by running a proxy to the Kubernetes API server:

```
oc proxy --port=8001
```{{execute}}
<br>
Open up another terminal by clicking the **+** button and select `Open New Terminal`.
<br>
<br>

Let's create a new Custom Resource Definition (CRD) object manifest for Postgres:

```
cat >> postgres-crd.yaml <<EOF
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
  name: postgreses.rd.example.com
spec:
  group: rd.example.com
  names:
    kind: Postgres
    listKind: PostgresList
    plural: postgreses
    singular: postgres
    shortNames:
    - pg
  scope: Namespaced
  version: v1alpha1
EOF
```{{execute}}
<br>
Create the ***CRD*** resource object:

```
oc create -f postgres-crd.yaml
```{{execute}}
<br>
You should now see the Kubernetes API reflect a brand new *api group* called **rd.example.com**:

```
curl http://localhost:8001/apis | jq .groups[].name
```{{execute}}
<br>
This will also be reflected in the `oc api-versions` command:

```
oc api-versions
```{{execute}}
<br>
Within the `rd.example.com` group there will be an *api version* **v1alpha1** (per our CRD resource object). The database resource resides here.

```
curl http://localhost:8001/apis/rd.example.com/v1alpha1 | jq
```{{execute}}
<br>
Notice how `oc` now recognize postgres as a present resource (although there will be no current resource objects at this time).

```
oc get postgres
```{{execute}}
<br>
Let's create a new Custom Resource (CR) object manifest for the database:

```
cat >> wordpress-database.yaml <<EOF
apiVersion: "rd.example.com/v1alpha1"
kind: Postgres
metadata:
  name: wordpressdb
spec:
  user: postgres
  password: postgres
  database: primarydb
  nodes: 3
EOF
```{{execute}}
<br>
Create the new object:

```
oc create -f wordpress-database.yaml
```{{execute}}
<br>
Verify the resource was created:

```
oc get postgres
```{{execute}}
<br>
View the details about the wordpressdb object:

```
oc get postgres wordpressdb -o yaml
```{{execute}}