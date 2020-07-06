![Operator Lifecycle Manager](https://raw.githubusercontent.com/madorn/learn-katacoda/master/operatorframework/operator-lifecycle-manager/assets/images/olm-logo.png)

The [Operator Lifecycle Manager](https://github.com/operator-framework/operator-lifecycle-manager) project is a component of the Operator Framework, an open source toolkit to manage Kubernetes native applications, called Operators, in an effective, automated, and scalable way.

OLM extends Kubernetes to provide a declarative way to install, manage, and upgrade operators and their dependencies in a cluster.

It also enforces some constraints on the components it manages in order to ensure a good user experience.

OLM enables users to do the following:

* Define applications as a single Kubernetes resource that encapsulates requirements and metadata.
* Install applications automatically with dependency resolution or manually with nothing but kubectl.
* Upgrade applications automatically with different approval policies.