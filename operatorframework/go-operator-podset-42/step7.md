In a new terminal, inspect the Custom Resource manifest:

```
cd $GOPATH/src/github.com/redhat/podset-operator
cat deploy/crds/app.example.com_v1alpha1_podset_cr.yaml
```{{execute}}
<br>
Ensure your `kind: PodSet` Custom Resource (CR) is updated with `spec.replicas`

<pre class="file">
apiVersion: app.example.com/v1alpha1
kind: PodSet
metadata:
  name: example-podset
spec:
  replicas: 3
</pre>

You can easily update this file by running the following command:

```
wget -q https://raw.githubusercontent.com/openshift-labs/learn-katacoda/master/operatorframework/go-operator-podset/assets/app.example.com_v1alpha1_podset_cr.yaml -O deploy/crds/app.example.com_v1alpha1_podset_cr.yaml
```{{execute}}
<br>
Deploy your PodSet Custom Resource to the live OpenShift Cluster:

```
oc create -f deploy/crds/app.example.com_v1alpha1_podset_cr.yaml
```{{execute}}
<br>
Verify the PodSet operator has created 3 pods:

```
oc get pods
```{{execute}}
<br>
Verify that status shows the name of the pods currently owned by the PodSet:

```
oc get podset example-podset -o yaml
```{{execute}}
<br>
Increase the number of replicas owned by the PodSet:

```
oc patch podset example-podset --type='json' -p '[{"op": "replace", "path": "/spec/replicas", "value":5}]'
```{{execute}}
