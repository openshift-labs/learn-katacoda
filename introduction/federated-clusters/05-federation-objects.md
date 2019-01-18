Federation V2 gives us the ability to change our federated applications placement, so in the event we want to delete/create our application in one of our clusters we can do it modifying its placement.

## Federated Deployment

This object instructs the Federation Control Plane to federate a deployment named `test-deployment`.

```yaml
apiVersion: v1
kind: List
items:
- apiVersion: primitives.federation.k8s.io/v1alpha1
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
```

## Federated Deployment Placement

This object instructs the Federation Control Plane to place our `test-deployment` into `test-namespace` on both `cluster1` and `cluster2`.

```yaml
apiVersion: v1
kind: List
items:
- apiVersion: primitives.federation.k8s.io/v1alpha1
  kind: FederatedDeploymentPlacement
  metadata:
    name: test-deployment
    namespace: test-namespace
  spec:
    clusterNames:
    - cluster2
    - cluster1
```

## Federated Deployment Override

This object instructs the Federation Control Plane to override the number of replicas for our `test-deployment` from the default of 3 (defined in FederatedDeployment) to 5 on `cluster2`.

```yaml
apiVersion: v1
kind: List
items:
- apiVersion: primitives.federation.k8s.io/v1alpha1
  kind: FederatedDeploymentOverride
  metadata:
    name: test-deployment
    namespace: test-namespace
  spec:
    overrides:
    - clusterName: cluster2
      clusterOverrides:
      - path: spec.replicas
        value: 5
```
