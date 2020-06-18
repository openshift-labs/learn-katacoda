## Goal

Learn how to copy files to and from a running container without rebuilding the container image. Augment this with a watch function that automatically applies local changes to a running container so you can immediately see the effects in your application.

## Concepts

* Rapid inner-loop development by modifying a running container
* OpenShift Projects and Applications
* OpenShift `oc` tool’s `new-app` subcommand

## Use case

You can modify an application in a container to develop and test before building a new version of the container's immutable image. Automatatically synchronizing the container with local changes speeds the "inner loop" of develop and test cycles, especially with interpreted programming languages.

This OpenShift cluster will self-destruct in one hour.
