Now we can test our logic by running our Operator outside the cluster via our `kubeconfig` credentials. Once running, the command will block the current session. You can continue interacting with the OpenShift cluster by opening a new terminal window.

```
operator-sdk up local --namespace myproject
```{{execute}}
