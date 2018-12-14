Let's begin my creating a new project called `myproject`:

```
oc new-project myproject
```{{execute}}
<br>
We will now deploy the Operator Lifecycle Manager to our OpenShift environment.

It consists of the following objects:

* **CustomResourceDefinitions**:
    * `Subscription`, `InstallPlan`, `CatalogSource`, `ClusterServiceVersion`
* **Namespace**:
    * `openshift-operator-lifecycle-manager`
* **Service Account**:
    * `olm-operator-serviceaccount`
* **ClusterRole**:
    * `system:controller:operator-lifecycle-manager`
* **ClusterRoleBinding**:
    * `olm-operator-binding-openshift-operator-lifecycle-manager`
* **CatalogSource**:
    * `rh-operators`
* **ConfigMap**:
    * `rh-operators`
* **Deployments**:
    * `olm-operator`, `catalog-operator`, `package-server`

Let's get started by cloning the official Operator Lifecycle Manager repository:

```
git clone https://github.com/operator-framework/operator-lifecycle-manager
```{{execute}}
<br>
We can now install all the required objects:

```
oc create -f operator-lifecycle-manager/deploy/okd/manifests/0.7.2/
```{{execute}}
<br>
Verify all four OLM CRDs are present:

```
oc get crds
```{{execute}}
<br>
Verify the Operators are currently running within the `openshift-operator-lifecycle-manager` namespace:

```
oc -n openshift-operator-lifecycle-manager get deploy
```{{execute}}
<br>
Verify the CatalogSource and CatalogSource ConfigMap exist:

```
oc get -n openshift-operator-lifecycle-manager catalogsource
```{{execute}}
```
oc get -n openshift-operator-lifecycle-manager configmap
```{{execute}}
