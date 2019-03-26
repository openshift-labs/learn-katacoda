## The Helm-based Operator from the Operator SDK

In the previous learning modules, we covered how to easily create the following types of Operators:

* **Go**:
Ideal for traditional software development teams that want to get to a fully auto-pilot Operator. It gives you the ability to leverage the same Kubernetes libraries the upstream projects uses under the hood. Check out the [Go Getting Started guide](https://github.com/operator-framework/operator-sdk/blob/master/doc/user-guide.md).

* **Ansible**:
Useful for infrastructure-focused teams that have investment in Ansible modules but want to use them in a Kubernetes-native way. Also great for using Ansible to configure off-cluster objects like hardware load balancers. Check out the [Ansible Getting Started guide](https://github.com/operator-framework/operator-sdk/blob/master/doc/ansible/user-guide.md).

We will now focus on the easiest way to get started developing an Operator:

* **Helm**:
Useful for securely running Helm charts without [Tiller](https://helm.sh/docs/glossary/#tiller) and  doesn’t rely on manual invocation of Helm to reconfigure your apps. Check out the [Helm Operator Getting Started guide](https://github.com/operator-framework/operator-sdk/blob/master/doc/helm/user-guide.md) for more information.


## Comparing Helm to a Helm-based Operator from the Operator SDK

Creating a Helm-based Operator with the Operator SDK is useful because any changes to your Custom Resources can be picked up immediately. You no longer need to run Helm CLI commands to modify your applications because Tiller is removed from the cluster.

A Helm-based Operator is also designed to excel at stateless applications because changes should be applied to the Kubernetes objects that are generated as part of the chart. This sounds limiting, but can be sufficient for a surprising amount of use-cases as shown by the proliferation of Helm charts built by the Kubernetes community.

## Comparing a Helm-based Operator to a Go-based Operator

A powerful feature of an Operator is to enable the desired state to be reflected in your application. As your application gets more complicated and has more components, detecting these changes can be harder for a human, but easier for a computer.

The Helm-based Operator built from the Operator SDK is designed to be simple: it listens for changes to your custom resources and pushes that configuration down to the objects via the chart and the templated values. Because this action is top down, the Operator is not taking a deep look at each individual object field, such as the labels on a specific Pod or a value within a ConfigMap. If one of these is changed manually, the Operator should not overwrite that value with the desired state until the next time the custom resource is changed. Most of the time this should not be an issue, and can be controlled with RBAC policy.

A Go-based Operator built from the Operator SDK is written with a programming language at your disposal to help power deeper introspection into not just the Custom Resource, but the Pods, Services, Deployments and ConfigMaps that make up your app. As an Operator author, you can check how any field from your desired state matches with the running configuration and reset it as part of the Operator’s reconciliation loop. A G-based Operator can also quickly revert change that is core to the operation of the application.

## Creating a CockroachDB Operator from a Helm Chart

In this tutorial, we will create a CockroachDB Operator from an existing [CockroachDB Helm Chart](https://github.com/helm/charts/tree/master/stable/cockroachdb).

[CockroachDB](https://www.cockroachlabs.com) is a distributed SQL database built on a transactional and strongly-consistent key-value store. It can:

* Scale horizontally.
* Survive disk, machine, rack, and even datacenter failures with minimal latency disruption and no manual intervention.
* Supports strongly-consistent ACID transactions and provides a familiar SQL API for structuring, manipulating, and querying data.

Let's begin!