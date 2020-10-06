## Goal

Learn how to deploy an application from its source code using a [Source-to-Image][s2i] build on OpenShift.

## Concepts

* Linux containers and building container images
* OpenShift Source-to-Image (S2I)
* OpenShift Projects and Applications
* OpenShift `oc` command line tool

## Use case

You can have OpenShift build an application from source to deploy it, so you don't have to construct a container by hand with every change. OpenShift can then build and deploy new versions automatically when notified of souce code changes.

This OpenShift cluster will self-destruct in one hour.

[s2i]: https://docs.openshift.com/container-platform/4.4/builds/understanding-image-builds.html#build-strategy-s2i_understanding-image-builds
