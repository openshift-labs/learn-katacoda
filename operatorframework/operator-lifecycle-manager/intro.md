![Operator Lifecycle Manager](../../assets/operatorframework/operator-lifecycle-manager/olm-logo.png)

The [Operator Lifecycle Manager](https://github.com/operator-framework/operator-lifecycle-manager) project is a component of the Operator Framework, an open source toolkit to manage Kubernetes native applications, called Operators, in an effective, automated, and scalable way.

OLM extends Kubernetes to provide a declarative way to install, manage, and upgrade operators and their dependencies in a cluster. It also enforces some constraints on the components it manages in order to ensure a good user experience.

OLM enables users to do the following:

# Over-the-Air Updates and Catalogs

Kubernetes clusters are being kept up to date using elaborate update mechanisms today, more often automatically and in the background. Operators, being cluster extensions, should follow that. OLM has a concept of catalogs from which Operators are available to install and being kept up to date. In this model OLM allows maintainers granular authoring of the update path and gives commercial vendors a flexible publishing mechanism using channels.

# Dependency Model

With OLM's packaging format, Operators can express dependencies on the platform and on other Operators. They can rely on OLM to respect these requirements as long as the cluster is up. In this way, OLM's dependency model ensures Operators stay working during their long lifecycle across multiple updates of the platform or other Operators.

# Discoverability

OLM advertises installed Operators and their services into the namespaces of tenants. They can discover which managed services are available and which Operator provides them. Administrators can rely on catalog content projected into a cluster, enabling discovery of Operators available to install.

# Cluster Stability

Operators must claim ownership of their APIs. OLM will prevent conflicting Operators owning the same APIs being installed, ensuring cluster stability.

# Declarative UI controls

Operators can behave like managed service providers. Their user interface on the command line are APIs. For graphical consoles OLM annotates those APIs with descriptors that drive the creation of rich interfaces and forms for users to interact with the Operator in a natural, cloud-like way.