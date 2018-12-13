Now we can test our logic by running our Operator outside the cluster via our `kubeconfig` credentials:

```
operator-sdk up local --namespace myproject
```{{execute}}