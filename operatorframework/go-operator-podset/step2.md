Add a new Custom Resource Definition (CRD) API called PodSet with APIVersion `app.example.com/v1alpha1` and Kind `PodSet`. This command will also create our boilerplate controller logic and [Kustomize](https://kustomize.io) configuration files.

```
operator-sdk create api --group=app --version=v1alpha1 --kind=PodSet --resource --controller
```{{execute}}
<br>
We should now see the `/api`, `config`, and `/controllers` directories.