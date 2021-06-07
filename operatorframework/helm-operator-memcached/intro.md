In the previous learning modules, we covered how to easily create the following types of Operators with the Operator SDK:

* **Go**:
Ideal for traditional software development teams that want to get to a fully auto-pilot Operator. It gives you the ability to leverage the same Kubernetes libraries the upstream projects uses under the hood. Check out the [Go Getting Started guide](https://sdk.operatorframework.io/docs/building-operators/golang/).

* **Ansible**:
Useful for infrastructure-focused teams that have investment in Ansible modules but want to use them in a Kubernetes-native way. Also great for using Ansible to configure off-cluster objects like hardware load balancers. Check out the [Ansible Getting Started guide](https://sdk.operatorframework.io/docs/building-operators/ansible/).

We will now focus on the easiest way to get started developing an Operator:

* **Helm**:
Useful for securely running Helm charts without [Tiller](https://helm.sh/docs/glossary/#tiller) and  it doesn’t rely on manual invocation of Helm to reconfigure your apps. Check out the [Helm Operator Getting Started guide](https://sdk.operatorframework.io/docs/building-operators/helm/) for more information.

## Creating a Memcached Operator from a Helm Chart

In this tutorial, we will create a Memcached Operator from an existing [Memcached Helm Chart](https://github.com/helm/charts/blob/master/stable/memcached/Chart.yaml).

[Memcached](https://memcached.org/) is a Free & open source, high-performance, distributed memory object caching system, generic in nature, but intended for use in speeding up dynamic web applications by alleviating database load.

Let's begin!