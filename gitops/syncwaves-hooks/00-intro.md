## Goal

This scenario will get you get familiar with syncwaves and hook phases.


## Concepts

[Syncwaves](https://argoproj.github.io/argo-cd/user-guide/sync-waves/)
are used in Argo CD to order how manifests
are applied to the cluster. Whereas [resource hooks](https://argoproj.github.io/argo-cd/user-guide/resource_hooks/)
breaks up the delivery of these manifests in different phases.

![ArgoCD Logo](../../assets/gitops/argocd-logo.png)

[Argo CD](https://argoproj.github.io/argo-cd/) is a declarative, GitOps continuous delivery tool for Kubernetes.

Using a combination of syncwaves and resource hooks, you can control how your application rolls out.

## Use case

This is a simple guide that takes you through the following steps:

* Using Syncwaves to order deployment
* Exploring Resource Hooks
* Using Syncwaves and Hooks together

This OpenShift cluster will self-destruct in one hour.
