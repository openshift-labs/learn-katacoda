## Goal

Learn how to use [GitOps practices on OpenShift to deploy an application on multiple clusters][gitops-multi-openshift], configure the application for each cluster, then perform a canary deployment of a new application version.

## Concepts

* GitOps practices from the [Introduction to GitOps on OpenShift][gitops-intro-learn]
* [ArgoCD][argocd] continuous deployment server
* Employing two or more OpenShift clusters
* OpenShift Projects and Applications

## Use case

You can establish an automated GitOps process to deploy and maintain versioned source, container images, and resource specs for an application, with specific variations for each cluster that runs it. For example, you can divide development and production deployments between two OpenShift installations.

These OpenShift clusters will self-destruct in one hour.

[argocd]: https://argoproj.github.io/argo-cd/
[gitops-intro-learn]: https://learn.openshift.com/introduction/gitops-introduction
[gitops-multi-openshift]: https://www.openshift.com/blog/multi-cluster-management-with-gitops
