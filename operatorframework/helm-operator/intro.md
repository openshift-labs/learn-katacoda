In the previous learning modules, we covered how to easily create the following types of Operators with the Operator SDK:

* **Go**:
Ideal for traditional software development teams that want to get to a fully auto-pilot Operator. It gives you the ability to leverage the same Kubernetes libraries the upstream projects uses under the hood. Check out the [Go Getting Started guide](https://github.com/operator-framework/operator-sdk/blob/master/doc/user-guide.md).

* **Ansible**:
Useful for infrastructure-focused teams that have investment in Ansible modules but want to use them in a Kubernetes-native way. Also great for using Ansible to configure off-cluster objects like hardware load balancers. Check out the [Ansible Getting Started guide](https://github.com/operator-framework/operator-sdk/blob/master/doc/ansible/user-guide.md).

We will now focus on the easiest way to get started developing an Operator:

* **Helm**:
Useful for securely running Helm charts without [Tiller](https://helm.sh/docs/glossary/#tiller) and  it doesn’t rely on manual invocation of Helm to reconfigure your apps. Check out the [Helm Operator Getting Started guide](https://github.com/operator-framework/operator-sdk/blob/master/doc/helm/user-guide.md) for more information.

## Creating a CockroachDB Operator from a Helm Chart

In this tutorial, we will create a CockroachDB Operator from an existing [CockroachDB Helm Chart](https://github.com/helm/charts/tree/master/stable/cockroachdb).

[CockroachDB](https://www.cockroachlabs.com) is a distributed SQL database built on a transactional and strongly-consistent key-value store. It can:

* Scale horizontally.
* Survive disk, machine, rack, and even datacenter failures with minimal latency disruption and no manual intervention.
* Supports strongly-consistent ACID transactions and provides a familiar SQL API for structuring, manipulating, and querying data.

Let's begin!