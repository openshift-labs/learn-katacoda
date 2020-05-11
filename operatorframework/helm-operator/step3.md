Apply the CockroachDB Custom Resource Definition to the cluster:

```
oc apply -f deploy/crds/charts.helm.k8s.io_cockroachdbs_crd.yaml
```{{execute}}
<br>
Now we can run our Helm-based Operator from outside the cluster via our `kubeconfig` credentials.
<br>
Running the command will block the current session so you can continue interacting with the OpenShift cluster by opening a new terminal window.

```
operator-sdk run --local --namespace myproject
```{{execute}}
