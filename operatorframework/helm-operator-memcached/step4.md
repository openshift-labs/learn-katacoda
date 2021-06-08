Open a new terminal window and navigate to the `memcached-operator` top-level directory:

```
cd projects/memcached-operator
```{{execute}}
Before applying the Memcached Custom Resource, observe the Memcached Helm Chart `values.yaml`:

[Memcached Helm Chart Values.yaml file](https://github.com/helm/charts/blob/master/stable/memcached/values.yaml)

Update the Memcached Custom Resource at `config/samples/charts_v1alpha1_memcached.yaml` with the following values:

* `spec.replicaCount: 3`

<pre class="file">
apiVersion: charts.example.com/v1alpha1
kind: Memcached
metadata:
  name: memcached-sample
spec:
  # Default values copied from <project_dir>/helm-charts/memcached/values.yaml
  AntiAffinity: soft
  affinity: {}
  extraContainers: ""
  extraVolumes: ""
  image: memcached:1.5.20
  kind: StatefulSet
  memcached:
    extendedOptions: modern
    extraArgs: []
    maxItemMemory: 64
    verbosity: v
  metrics:
    enabled: false
    image: quay.io/prometheus/memcached-exporter:v0.6.0
    resources: {}
    serviceMonitor:
      enabled: false
      interval: 15s
  nodeSelector: {}
  pdbMinAvailable: 2
  podAnnotations: {}
  replicaCount: 3
  resources:
    requests:
      cpu: 50m
      memory: 64Mi
  securityContext:
    enabled: false 
    fsGroup: 1001
    runAsUser: 1001
  serviceAnnotations: {}
  tolerations: {}
  updateStrategy:
    type: RollingUpdate
</pre>

You can easily update this file by running the following command:

```
\cp /tmp/charts_v1alpha1_memcached.yaml config/samples/charts_v1alpha1_memcached.yaml
```{{execute}}
<br>
After updating the Memcached Custom Resource with our desired spec, apply it to the cluster. Ensure you are currently scoped to the `myproject` Namespace:

```
oc project myproject
```{{execute}}

```
oc apply -f config/samples/charts_v1alpha1_memcached.yaml
```{{execute}}
<br>
Confirm that the Custom Resource was created:

```
oc get memcached
```{{execute}}
<br>
It may take some time for the environment to pull down the Memcached container image. Confirm that the Stateful Set was created:

```
oc get statefulset
```{{execute}}
<br>
Confirm that the Stateful Set's pod is currently running:

```
oc get pods
```{{execute}}
<br>
Confirm that the Memcached "internal" and "public" ClusterIP Service were created:

```
oc get services
```{{execute}}
