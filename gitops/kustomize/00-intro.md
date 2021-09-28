## Goal

This guide helps you get familiar with how to use Kustomize on Argo CD on OpenShift.


## Concepts

[Kustomize](https://kustomize.io/) traverses a Kubernetes manifest to add, remove or update configuration options without forking. It is available both as a standalone binary and as a native feature of `kubectl` (and by extension `oc`). 

The principals of `kustomize` are:

* Purely declarative approach to configuration customization 
* Manage an arbitrary number of distinctly customized Kubernetes configurations 
* Every artifact that kustomize uses is plain YAML and can be validated and processed as such 
* As a "templateless" templating system; it encourages using YAML without forking the repo it.

![Kustomize Logo](../../assets/gitops/kustomize_logo.png)

## Use case

This is a simple guide that takes you through the following steps:

* Exploring the Kustomize syntax
* Deploying a Kustomized application

This OpenShift cluster will self-destruct in one hour.
