Let's deply our ArgoCD Server by creating the ArgoCD manifest via the CLI. You can also do this on the OpenShift console.

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
Create the ArgoCD Custom Resource:

```
oc create -f argocd-cr.yaml
```{{execute}}
<br>
The ArgoCD Operator should now begin to generate the ArgoCD Operand artifacts. This can take up to a few minutes:

```
oc get deployments
oc get services
oc get secrets
```{{execute}}