<br>
# What is Argo CD?

Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes.

# How it works

Argo CD follows the GitOps pattern, a Git repository will be used as the source of truth for the definition of our applications. 

Our applications will be defined using Kubernetes manifests in several ways:

* [Kustomize](https://kustomize.io/) Applications 
* [Helm](https://helm.sh/) Charts
* [Ksonnet](https://ksonnet.io/) Applications
* [Jsonnet](https://jsonnet.org/) Files
* Plain directory of YAML/JSON Manifests
* Any custom config management tool configured as a config management plugin

> **NOTE:** In this lab we are going to use plain directories and yaml files to define our application.

# Argo CD Under the Hood

Argo CD is implemented as a Kubernetes Controller which compares the desired application state defined in Git against the current, live state in Kubernetes.

In case there is a deviation from the state defined in Git, Argo CD will move the live state towards the desired state in Git. The remediation will be automatically or manual depending on the application configuration.

# Resources

* [ArgoCD Official Docs](https://argoproj.github.io/argo-cd/)
