Create the argoCD manifest via the CLI or OpenShift console.

```
cat > argocd-cr.yaml <<EOF
apiVersion: argoproj.io/v1alpha1
kind: ArgoCD
metadata:
  name: example-argocd
  namespace: myproject
spec:
  dex:
    image: quay.io/ablock/dex
    openShiftOAuth: true
    version: openshift-connector
  rbac:
    policy: |
      g, system:cluster-admins, role:admin
  server:
    route:
      enabled: true
EOF
```{{execute}}
<br>
Create the etcd-cluster.

```
oc create -f argocd-cr.yaml
```{{execute}}
<br>
The ArgoCD Operator should now begin to generate the ArgoCD Operand artifacts:

```
oc get deployments
oc get services
oc get secrets
```{{execute}}