Let's begin my creating a new project called `myproject`.

```
oc new-project myproject
```{{execute}}
<br>
Create a Subscription manifest for the Etcd Operator. Ensure the Approval is set to `Manual`.

```
cat > etcd-alpha-subscription.yaml <<EOF
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: etcd
  namespace: myproject 
spec:
  channel: alpha
  name: etcd
  source: rh-operators
  installPlanApproval: Manual
EOF
```{{execute}}
<br>
Create the Subscription.

```
oc create -f etcd-alpha-subscription.yaml
```{{execute}}
<br>
Verify the Subscription and InstallPlan have been created.

```
oc get subscription
oc get installplan
```{{execute}}
