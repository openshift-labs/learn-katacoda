Fetch the InstallPlan and observe the Kubernetes objects that will be created once approved:

```
ARGOCD_INSTALLPLAN=`oc get installplan -o jsonpath={$.items[0].metadata.name}`
oc get installplan $ARGOCD_INSTALLPLAN -o yaml
```{{execute}}

You can a better view of the InstallPlan by navigating to the ArgoCD Operator in the [Console](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com/).

Navigate to the Operators section of the UI and select the ArgoCD Operator  under **Installed Operators**. You should now select the `InstallPlan`.

You can install the Operator by approving the InstallPlan via the OpenShift console or with the following command:

```
oc patch installplan $ARGOCD_INSTALLPLAN --type='json' -p '[{"op": "replace", "path": "/spec/approved", "value":true}]'
```{{execute}}
<br>
Once the InstallPlan is approved, you will see the newly provisioned ClusterServiceVersion, ClusterResourceDefinition, Role and RoleBindings, Service Accounts, and Argo-CD Operator Deployment.

```
oc get clusterserviceversion
oc get crd | grep argoproj.io
oc get sa | grep argocd
oc get roles | grep argocd
oc get rolebindings | grep argocd
oc get deployments
```{{execute}}
<br>
When the ArgoCD Operator is finally running, we can observe its logs by running the following:

```
ARGOCD_OPERATOR=`oc get pods -o jsonpath={$.items[0].metadata.name}`
oc logs $ARGOCD_OPERATOR
```{{execute}}