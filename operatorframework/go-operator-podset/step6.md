In a new terminal, inspect the Custom Resource manifest:

```
cd $HOME/projects/podset-operator
cat config/samples/app_v1alpha1_podset.yaml
```{{execute}}
<br>
Ensure your `kind: PodSet` Custom Resource (CR) is updated with `spec.replicas`

<pre class="file">
apiVersion: app.example.com/v1alpha1
kind: PodSet
metadata:
  name: podset-sample
spec:
  replicas: 3
</pre>

You can easily update this file by running the following command:

```
\cp /tmp/app_v1alpha1_podset.yaml config/samples/app_v1alpha1_podset.yaml
```{{execute}}
<br>
Ensure you are currently scoped to the `myproject` Namespace:

```
oc project myproject
```{{execute}}
<br>
Deploy your PodSet Custom Resource to the live OpenShift Cluster:

```
oc create -f config/samples/app_v1alpha1_podset.yaml
```{{execute}}
<br>
Verify the Podset exists:

```
oc get podset
```{{execute}}
<br>
Verify the PodSet operator has created 3 pods:

```
oc get pods
```{{execute}}
<br>
Verify that status shows the name of the pods currently owned by the PodSet:

```
oc get podset podset-sample -o yaml
```{{execute}}
<br>
Increase the number of replicas owned by the PodSet:

```
oc patch podset podset-sample --type='json' -p '[{"op": "replace", "path": "/spec/replicas", "value":5}]'
```{{execute}}
<br>

Verify that we now have 5 running pods
```
oc get pods
```{{execute}}
