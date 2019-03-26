Apply the Cockroachdb Custom Resource Definition to the cluster:

```
oc apply -f deploy/crds/db_v1alpha1_cockroachdb_crd.yaml
```{{execute}}
<br>
Now we can run our Helm-based Operator from outside the cluster via our `kubeconfig` credentials. Once running the command will block the current session. You can continue interacting with the OpenShift cluster by opening a new terminal window.

```
operator-sdk up local --namespace myproject
```{{execute}}