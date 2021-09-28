## Goal

This guide helps you get started with ArgoCD and GitOps with OpenShift.


## Concepts

[GitOps](https://www.openshift.com/learn/topics/gitops/) is a set of practices that leverages Git workflows to manage infrastructure and application configurations.
By using Git repositories as the source of truth, it allows the DevOps team to store the entire state of the cluster configuration in Git so that the trail of changes are visible and auditable. 

**GitOps** simplifies the propagation of infrastructure and application 
configuration changes across multiple clusters by defining your infrastructure and applications definitions as “code”.

* Ensure that the clusters have similar states for configuration, monitoring, or storage.
* Recover or recreate clusters from a known state.
* Create clusters with a known state.
* Apply or revert configuration changes to multiple clusters.
* Associate templated configuration with different environments.


![ArgoCD Logo](../../assets/gitops/argocd-logo.png)

[Argo CD](https://argoproj.github.io/argo-cd/) is a declarative, GitOps continuous delivery tool for Kubernetes.

It follows the GitOps pattern of using Git repositories as the source of truth for defining the desired application state.

It automates the deployment of the desired application states in the specified target environments. Application deployments can track updates to branches, tags, or pinned to a specific version of manifests at a Git commit.


## Use case

This is a simple guide that takes you through the following steps:

* Exploring the OpenShift GitOps Operator
* Accessing Argo CD via CLI and Web UI
* Deploying A Sample Application

This OpenShift cluster will self-destruct in one hour.
