The `watches.yaml` file maps a Group, Version, and Kind to a specific Helm Chart. Observe the contents of the `watches.yaml`:

```
cat watches.yaml
```{{execute}}
<br>
Create a symlink that targets the Cockroachdb Helm chart in the cockroachdb-operator project directory.

```
mkdir -p /opt/helm/helm-charts
ln -s /root/tutorial/go/src/github.com/redhat/cockroachdb-operator/helm-charts/cockroachdb/ /opt/helm/helm-charts/
```{{execute}}
