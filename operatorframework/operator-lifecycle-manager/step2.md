Observe the CatalogSources that ship with OLM and OpenShift 4:

```
oc get catalogsources -n openshift-marketplace
```{{execute}}


Here is a brief summary of each CatalogSource:

* **Certified Operators**:
    * All Certified Operators have passed [Red Hat OpenShift Operator Certification](http://connect.redhat.com/explore/red-hat-openshift-operator-certification), an offering under Red Hat Partner Connect, our technology partner program. In this program, Red Hat partners can certify their Operators for use on Red Hat OpenShift. With OpenShift Certified Operators, customers can benefit from validated, well-integrated, mature and supported Operators from Red Hat or partner ISVs in their hybrid cloud environments.

To view the Operators included in the **Certified Operators** CatalogSource, run the following:

```
oc get packagemanifests -l catalog=certified-operators
```{{execute}}

* **Community Operators**:
    * With access to community Operators, customers can try out Operators at a variety of maturity levels. Delivering the OperatorHub community, Operators on OpenShift fosters iterative software development and deployment as Developers get self-service access to popular components like databases, message queues or tracing in a managed-service fashion on the platform. These Operators are maintained by relevant representatives in the [operator-framework/community-operators GitHub repository](https://github.com/operator-framework/community-operators).

To view the Operators included in the **Community Operators** CatalogSource, run the following:

```
oc get packagemanifests -l catalog=community-operators
```{{execute}}

* **Red Hat Operators**:
    * These Operators are packaged, shipped, and supported by Red Hat.

To view the Operators included with the **RedHat Operators** CatalogSource, run the following:

```
oc get packagemanifests -l catalog=redhat-operators
```{{execute}}

* **Red Hat Marketplace**:
    * Built in partnership by Red Hat and IBM, the Red Hat Marketplace helps organizations deliver enterprise software and improve workload portability. Learn more at [marketplace.redhat.com](https://marketplace.redhat.com).

To view the Operators included in the **Red Hat Marketplace** CatalogSource, run the following:

```
oc get packagemanifests -l catalog=redhat-marketplace
```{{execute}}