In a new terminal, inspect the Custom Resource manifest:

```
cat deploy/crds/app_v1alpha1_podset_cr.yaml
```{{execute}}
<br>
Ensure your `kind: PodSet` Custom Resource (CR) is updated with `spec.replicas`:

<pre class="file"
 data-filename="/root/tutorial/go/src/github.com/podset-operator/deploy/crds/app_v1alpha1_podset_cr.yaml"
  data-target="replace">
apiVersion: app.example.com/v1alpha1
kind: PodSet
metadata:
  name: example-podset
spec:
  # Add fields here
  replicas: 3
</pre>

Deploy your PodSet Custom Resource to the live OpenShift Cluster:

```
oc create -f deploy/crds/app_v1alpha1_podset_cr.yaml
```{{execute}}
<br>
