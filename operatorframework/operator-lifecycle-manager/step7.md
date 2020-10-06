Let's access the ArgoCD Dashboard via an OpenShift Route:

```
ARGOCD_ROUTE=`oc get routes example-argocd-server -o jsonpath={$.spec.host}`
echo $ARGOCD_ROUTE
```{{execute}}

Select **Login via OpenShift** to use OpenShift as our identity provider.

For more information on getting started with ArgoCD on OpenShift 4, check out [this video](https://www.youtube.com/watch?v=xYCX2EejSMc).