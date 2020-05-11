Add a new Custom Resource Definition(CRD) API called PodSet, with APIVersion `app.example.com/v1alpha1` and Kind `PodSet`:

```
operator-sdk add api --api-version=app.example.com/v1alpha1 --kind=PodSet
```{{execute}}
<br>
This will scaffold the PodSet resource API under `pkg/apis/app/v1alpha1/...`.

The Operator-SDK automatically creates the following manifests for you under the `/deploy` directory.

* Custom Resource Definition
* Custom Resource
* Service Account
* Role
* RoleBinding
* Deployment

Inspect the Custom Resource Definition manifest:

```
cat deploy/crds/app_v1alpha1_podset_crd.yaml
```{{execute}}
