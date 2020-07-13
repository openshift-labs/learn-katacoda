Let's begin my creating a new project called `myproject`.

```
oc new-project myproject
```{{execute}}
<br>
We should also create an OperatorGroup to ensure the ArgoCD Operator watches for ArgoCD CR(s) within the `myproject` namespace:

```
cat > argocd-operatorgroup.yaml <<EOF
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: argocd-operatorgroup
  namespace: myproject
spec:
  targetNamespaces:
    - myproject
EOF
```{{execute}}
<br>
Create the OperatorGroup:

```
oc create -f argocd-operatorgroup.yaml
```{{execute}}
<br>
Verify the OperatorGroup has been successfully created:

```
oc get operatorgroup argocd-operatorgroup 
```{{execute}}
Create a Subscription manifest for the [ArgoCD Operator](https://github.com/argoproj-labs/argocd-operator). Ensure the `installPlanApproval` is set to `Manual`. This will allow us to review the InstallPlan prior to installing the Operator:

```
cat > argocd-subscription.yaml <<EOF
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: argocd-operator
  namespace: myproject 
spec:
  channel: alpha
  installPlanApproval: Manual
  name: argocd-operator
  source: community-operators
  sourceNamespace: openshift-marketplace
  installPlanApproval: Manual
EOF
```{{execute}}
<br>
Create the Subscription:

```
oc create -f argocd-subscription.yaml
```{{execute}}
<br>
Verify the Subscription and InstallPlan have been created:

```
oc get subscription
oc get installplan
```{{execute}}