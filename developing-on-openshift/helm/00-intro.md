## Goal

Learn how to use the [Helm](https://helm.sh/), a package manager that helps you managing and deploying applications on OpenShift.

![Logo](../../assets/developing-on-openshift/helm/logo.png)

[Helm](https://www.openshift.com/learn/topics/helm) is a package manager for Kubernetes which helps users create templated packages called Helm Charts to include all Kubernetes resources that are required to deploy a particular application.  Helm then assists with installing the Helm Chart on Kubernetes, and afterwards it can upgrade or rollback the installed package when new versions are available. 

## Concepts

* Helm core concepts
* Exploring `helm` command line tool
* Deploying and managing `Helm Charts`
* Creating your own `Chart`
* Managing applications lifecycle with Helm `Upgrade` and `Rollback` of releases.
* Helm integrations with OpenShift UI

## Use case

Be able to provide a great experience for both Developers and System Administrators to manage and deploy applications using Helm Charts on top of OpenShift. 

Helm Charts are particularly useful for installation and upgrade of stateless applications given that the Kubernetes resources and the application image can simply be updated to newer versions. The follow-up for this Day 1 experience, is to convert Helm Charts into an Operator, using [Operator Framework](https://github.com/operator-framework) for a complete Day 2 experience for your apps.

This OpenShift cluster will self-destruct in one hour.

Let's get started!


