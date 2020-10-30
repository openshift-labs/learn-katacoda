The Operator Lifecycle Manager (OLM) is included with [OpenShift 4](https://try.openshift.com) and can easily be installed in a non-OpenShift Kubernetes environment by running [this simple command](https://operatorhub.io/how-to-install-an-operator#).

Let's get started exploring OLM by viewing its Custom Resource Definitions (CRDs).

OLM ships with 6 CRDs:

* **CatalogSource**:
    * A collection of Operator metadata (ClusterServiceVersions, CRDs, and PackageManifests). OLM uses CatalogSources to build the list of available operators that can be installed from OperatorHub in the OpenShift web console. In OpenShift 4, the web console has added support for managing the out-of-the-box CatalogSources as well as adding your own custom CatalogSources. You can create a custom CatalogSource using the [OLM Operator Registry](https://github.com/operator-framework/operator-registry).
* **Subscription**:
    * Relates an operator to a CatalogSource. Subscriptions describe which channel of an operator package to subscribe to and whether to perform updates automatically or manually. If set to automatic, the Subscription ensures OLM will manage and upgrade the operator to ensure the latest version is always running in the cluster.
* **ClusterServiceVersion (CSV)**:
    * The metadata that accompanies your Operator container image. It can be used to populate user interfaces with info like your logo/description/version and it is also a source of technical information needed to run the Operator. It includes RBAC rules and which Custom Resources it manages or depends on. OLM will parse this and do all of the hard work to wire up the correct Roles and Role Bindings, ensuring that the Operator is started (or updated) within the desired namespace and check for various other requirements, all without the end users having to do anything. You can easily build your own CSV with [this handy website](https://operatorhub.io/packages) and read about the [full CSV architecture in more detail](https://github.com/operator-framework/operator-lifecycle-manager/blob/master/doc/design/architecture.md#what-is-a-clusterserviceversion).
* **PackageManifest**:
    * An entry in the CatalogSource that associates a package identity with sets of CSVs. Within a package, channels point to a particular CSV. Because CSVs explicitly reference the CSV that they replace, a PackageManifest provides OLM with all of the information that is required to update a CSV to the latest version in a channel (stepping through each intermediate version).
* **InstallPlan**:
    * Calculated list of resources to be created in order to automatically install or upgrade a CSV.
* **OperatorGroup**:
    * Configures all Operators deployed in the same namespace as the OperatorGroup object to watch for their Custom Resource (CR) in a list of namespaces or cluster-wide.

Observe these CRDs by running the following command:

```
oc get crd | grep -E 'catalogsource|subscription|clusterserviceversion|packagemanifest|installplan|operatorgroup'
```{{execute}}


OLM is powered by controllers that reside within the `openshift-operator-lifecycle-manager` namespace as three Deployments (catalog-operator, olm-operator, and packageserver):

```
oc -n openshift-operator-lifecycle-manager get deploy
```{{execute}}