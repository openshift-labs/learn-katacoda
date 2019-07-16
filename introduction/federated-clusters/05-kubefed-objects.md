## Federated Deployment

This object instructs the KubeFed Control Plane to federate a deployment named `test-deployment`. 

The placement policy within the object instructs the KubeFed Control Plane to place our `test-deployment` on both `cluster1` and `cluster2`. 

The overrides policy within the object instructs the KubeFed Control Plane to override the number of replicas for our `test-deployment` from the default of 3 (defined in the FederatedDeployment template) to 5 on `cluster2`.

```yaml
apiVersion: types.federation.k8s.io/v1alpha1
kind: FederatedDeployment
metadata:
  name: test-deployment
  namespace: test-namespace
spec:
  template:
    metadata:
      labels:
        app: nginx
    spec:
      replicas: 3
      selector:
        matchLabels:
          app: nginx
      template:
        metadata:
          labels:
            app: nginx
        spec:
          containers:
          - image: nginx
            name: nginx
  placement:
    clusters:
    - name: cluster1
    - name: cluster2
  overrides:
  - clusterName: cluster2
    clusterOverrides:
    - path: "/spec/replicas"
      value: 5
```
