Fetch the InstallPlan and observe the Kubernetes objects that will be created once approved:

```
ARGOCD_INSTALLPLAN=`oc get installplan -o jsonpath={$.items[0].metadata.name}`
oc get installplan $ARGOCD_INSTALLPLAN -o yaml
```{{execute}}

You can a better view of the `InstallPlan` by navigating to the ArgoCD Operator in the [Console](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com/.

Navigate to the Operators section of the UI and find the ArgoCD InstallPlan under **Installed Operators**.

Once reviewed, you can install the Operator by approving the InstallPlan via the OpenShift console or with the following command:

```
oc patch installplan $ARGOCD_INSTALLPLAN --type='json' -p '[{"op": "replace", "path": "/spec/approved", "value":true}]'
```
<br>
Once the InstallPlan is approved, you will see the newly provisioned ClusterServiceVersion, ClusterResourceDefinition, Role and RoleBindings, Service Accounts, and argocd-operator Deployment.

```
oc get clusterserviceversion
oc get crd | grep argocd
oc get sa
oc get roles
oc get rolebindings
oc get deployments
```{{execute}}
