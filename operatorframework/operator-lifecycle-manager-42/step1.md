The Operator Lifecycle Manager (OLM) is included with [OpenShift4](https://try.openshift.com) and can easily be installed in non-OpenShift Kubernetes environments by running [this simple command](https://operatorhub.io/how-to-install-an-operator#).

Let's get started exploring OLM by viewing its Custom Resource Definitions (CRDs).

OLM ships with 6 CRDs:

* **CatalogSource**:
    * A collection of Operator metadata (ClusterServiceVersions, CRDs, and PackageManifests). OLM uses CatalogSources to build the list of available operators that can be installed from OperatorHub in the OpenShift web console. In OpenShift4, the web console has added support for managing the out-of-the-box CatalogSources as well as adding your own custom CatalogSources. You can create a custom CatalogSource using the [OLM Operator Registry](https://github.com/operator-framework/operator-registry).
* **Subscription**:
    * Relates an operator to a CatalogSource. Subscriptions describe which channel of an operator package to subscribe to and whether to perform updates automatically or manually. If set to automatic, the Subscription ensures OLM will manage and upgrade the operator to ensure the latest version is always running in the cluster.
* **ClusterServiceVersion (CSV)**:
    * The metadata that accompanies your Operator container image. It can be used to populate user interfaces with info like your logo/description/version and it is also a source of technical information needed to run the Operator. It includes RBAC rules and which Custom Resources it manages or depends on. OLM will parse this and do all of the hard work to wire up the correct Roles and Role Bindings, ensuring that the Operator is started (or updated) within the desired namespace and check for various other requirements, all without the end users having to do anything. You can easily build your own ClusterServiceVersion with [this handy website](htttp://operatorhub.io/packages) and read about the [full CSV architecture in more detail](https://github.com/operator-framework/operator-lifecycle-manager/blob/master/doc/design/architecture.md#what-is-a-clusterserviceversion).
* **PackageManifest**:
    * An entry in the CatalogSource that associates a package identity with sets of CSVs. Within a package, channels point to a particular CSV. Because CSVs explicitly reference the CSV that they replace, a PackageManifest provides OLM with all of the information that is required to update a CSV to the latest version in a channel (stepping through each intermediate version).
* **InstallPlan**:
    * Calculated list of resources to be created in order to automatically install or upgrade a CSV.
* **OperatorGroup**:
    * Configures all Operators deployed in the same namespace as the OperatorGroup object to watch for their Custom Resource (CR) in a list of namespaces or cluster-wide.

Observe the CatalogSources that ship with OLM and OpenShift4:

```
oc get catalogsources -n openshift-marketplace
```{{execute}}
<br>
Here is a brief summary of each CatalogSource:

* **Certified Operators**:
    * All Certified Operators have passed [Red Hat OpenShift Operator Certification] (http://connect.redhat.com/explore/red-hat-openshift-operator-certification), an offering under Red Hat Partner Connect, our technology partner program. In this program, Red Hat partners can certify their Operators for use on Red Hat OpenShift. With OpenShift Certified Operators, customers can benefit from validated, well-integrated, mature and supported Operators from Red Hat or partner ISVs in their hybrid cloud environments.

To view the contents of the Certified Operators CatalogSource, run the following:

```
oc get packagemanifests -l catalog=certified-operators
```{{execute}}
<br>
* **Community Operators**:
    * With access to community Operators, customers can try out Operators at a variety of maturity levels. Delivering the OperatorHub community Operators on OpenShift fosters iterative software development and deployment as developers get self-service access to popular components like databases, message queues or tracing in a managed-service fashion on the platform. These operators are maintained by relevant representatives in the [operator-framework/community-operators GitHub repository](https://github.com/operator-framework/community-operators).

To view the contents of the Certified Operators CatalogSource, run the following:

```
oc get packagemanifests -l catalog=community-operators
```{{execute}}
<br>
* **Red Hat Operators**:
    * These Operators are packaged, shipped, and supported by Red Hat.

To view the contents of the Certified Operators CatalogSource, run the following:

```
oc get packagemanifests -l catalog=redhat-operators
```{{execute}}