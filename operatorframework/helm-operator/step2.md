The `watches.yaml` file maps a Group, Version, and Kind to a specific Helm Chart. Observe the contents of the `watches.yaml`:

```
cat watches.yaml
```{{execute}}
<br>
Fetch the Cockroachdb Helm chart:

```
wget https://storage.googleapis.com/kubernetes-charts/cockroachdb-2.1.1.tgz
```{{execute}}
<br>
Unpack the Cockroachdb Helm chart to the current directory:

```
tar -xvzf cockroachdb-2.1.1.tgz
```{{execute}}
<br>
Update the `watches.yaml` file at `go/src/github.com/cockroachdb-operator/watches.yaml` to reflect the path to the top-level Cockroachdb Helm chart directory:

<pre class="file"
 data-filename="/root/tutorial/go/src/github.com/cockroachdb-operator/watches.yaml"
  data-target="replace">
---
- version: v1alpha1
  group: db.example.org
  kind: Cockroachdb
  chart: /root/tutorial/go/src/github.com/redhat/cockroachdb-operator/cockroachdb
</pre>