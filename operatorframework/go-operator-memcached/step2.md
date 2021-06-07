Add a new Custom Resource Definition (CRD) API called Memcached with APIVersion `cache.example.com/v1alpha1` and Kind `Memcached`. This command will also create our boilerplate controller logic and [Kustomize](https://kustomize.io) configuration files.

```
operator-sdk create api --group cache --version v1alpha1 --kind Memcached --resource --controller
```{{execute}}
<br>

We should now see the /api, config, and /controllers directories.

**Note:** This guide will cover the default case of a single group API. If you would like to support Multi-Group APIs see the [Single Group to Multi-Group](https://book.kubebuilder.io/migration/multi-group.html) doc.
