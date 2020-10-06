## Goal

Learn how to apply [GitOps principles][gitops-openshift-intro] to build and deploy an application on OpenShift.

## Concepts

* GitOps declarative, versioned and automated continuous deployment
* [ArgoCD][argocd] continuous deployment controller on OpenShift
* `git` file version management

## Use case

You can establish an automated GitOps process to deploy an application and maintain its source, configuration, and infrastructure resource specs in versioned files, with OpenShift automatically building, testing, and deploying new versions when changes are committed.

This OpenShift cluster will self-destruct in one hour.

[argocd]: https://argoproj.github.io/argo-cd/
[gitops-openshift-intro]: https://blog.openshift.com/introduction-to-gitops-with-openshift/ "Introduction to GitOps with OpenShift"
