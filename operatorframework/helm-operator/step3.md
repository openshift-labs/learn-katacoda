
Apply the CockroachDB Custom Resource Definition to the cluster:

```
oc apply -f config/crd/bases/charts.example.com_cockroachdbs.yaml
```{{execute}}
<br>
Now we can run our Helm-based Operator from outside the cluster via our `kubeconfig` credentials.
<br>
Running the command will block the current session so you can continue interacting with the OpenShift cluster by opening a new terminal window.

```
WATCH_NAMESPACE=myproject make run
```{{execute}}
