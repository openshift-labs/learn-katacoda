## Goal

This scenario will get you get familiar with how to use Argo CD to deploy
Helm charts.


## Concepts

[Helm](https://helm.sh/) is a package manager for Kubernetes
applications. You can define, install, and update your pre-packaged
applications. This is a way to bundle up, and deliver prebuilt Kubernetes
applications.


![Helm Logo](../../assets/gitops/helm-logo.png)

[Argo CD](https://argoproj.github.io/argo-cd/) is a declarative, GitOps continuous delivery tool for Kubernetes.

Using Argo CD, you can still use your Helm charts to deploy and manage your Applications.

## Use case

This is a simple guide that takes you through the following steps:

* Use the native Helm integration in Argo CD
* Explore a more GitOps friendly approach to Helm chart deployments

This OpenShift cluster will self-destruct in one hour.
