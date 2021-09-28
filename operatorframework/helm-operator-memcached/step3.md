Apply the Memcached Custom Resource Definition to the cluster:

```
oc apply -f config/crd/bases/charts.example.com_memcacheds.yaml
```{{execute}}
<br>
Once the CRD is registered, there are two ways to run the Operator:

* As a Pod inside a Kubernetes cluster
* As a Go program outside the cluster using Operator-SDK. This is great for local development of your Operator.

For the sake of this tutorial, we will run the Operator as a Go program outside the cluster using Operator-SDK and our `kubeconfig` credentials

Once running, the command will block the current session. You can continue interacting with the OpenShift cluster by opening a new terminal window. You can quit the session by pressing `CTRL + C`.

```
WATCH_NAMESPACE=myproject make run
```{{execute}}
