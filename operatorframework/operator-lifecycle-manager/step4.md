Let's begin my creating a new project called `myproject`.

```
oc new-project myproject
```{{execute}}


We should first create an [OperatorGroup](https://operator-framework.github.io/olm-book/docs/operator-scoping.html) to ensure Operators installed to this namespace will be capable of watching for Custom Resources within the `myproject` namespace:

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


Create the OperatorGroup:

```
oc create -f argocd-operatorgroup.yaml
```{{execute}}


Verify the OperatorGroup has been successfully created:

```
oc get operatorgroup argocd-operatorgroup 
```{{execute}}
Create a Subscription manifest for the [ArgoCD Operator](https://github.com/argoproj-labs/argocd-operator). Ensure the `installPlanApproval` is set to `Manual`. This will allow us to review the InstallPlan before choosing to install the Operator:

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
EOF
```{{execute}}


Create the Subscription:

```
oc create -f argocd-subscription.yaml
```{{execute}}


Verify the Subscription was created:

```
oc get subscription
```{{execute}}


The creation of the subscription will also trigger OLM to automatically generate an InstallPlan:

```
oc get installplan
```{{execute}}