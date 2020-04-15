Add a new Controller to the project that will watch and reconcile the PodSet resource:

```
operator-sdk add controller --api-version=app.example.com/v1alpha1 --kind=PodSet
```{{execute}}
<br>

This will scaffold a new Controller implementation under `go/src/github.com/redhat/podset-operator/pkg/controller/podset/podset_controller.go`.