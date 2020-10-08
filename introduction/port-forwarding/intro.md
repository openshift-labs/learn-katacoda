## Goal

Learn how to run a database with persistent storage on OpenShift. Access the database server in the cluster with a command-line shell, then use port forwarding to temporarily expose the database service outside of OpenShift so you can access it with any database API tool, like a graphical database manager.

## Concepts

* Persistent Volumes storage on OpenShift clusters
* Provisional routing of external traffic to cluster services
* OpenShift Projects and Applications
* OpenShift `oc` command line deployment tool

## Use case

You can deploy your application's underlying database server on an OpenShift cluster, growing through development toward a production database packaged in an automating [Operator][operator].

This OpenShift cluster will self-destruct in one hour.

[operator]: https://www.openshift.com/learn/topics/operators
