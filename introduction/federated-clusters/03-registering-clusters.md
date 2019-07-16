Currently, we have two OpenShift clusters, one of them (`cluster1`) is running the KubeFed Control Plane. Now it is time to register each cluster using the `kubefedctl` tool which has already been installed on the environment for your convenience.

`kubefedctl` resides in the [upstream repo]( https://github.com/kubernetes-sigs/kubefed/) and can be downloaded from the [releases section](https://github.com/kubernetes-sigs/kubefed/releases/).

Before registering both clusters we are going to check that no clusters are registered yet.

``oc --context=cluster1 get kubefedclusters -n test-namespace``{{execute HOST1}}

The 'No resources found' message means there are no clusters registered yet, so it is time to register both clusters.

*NOTE:* Cluster names (cluster1 and cluster2) in the commands below are a reference to the contexts configured in the oc client. This has been already configured for you, otherwise you would need to make sure that the client contexts have been properly configured with the right access levels and context names. See [here](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/) for more information on contexts.

To register the clusters the `kubefedctl` tool is used as:

``kubefedctl join <CLUSTER_NAME> --host-cluster-context <HOST_CLUSTER_CONTEXT> --v=2``

The --cluster-context option for `kubefedctl join` can be used to override the reference to the client context configuration. When the option is not present, like in the commands below, `kubefedctl` uses the cluster name to identify the client context.

The --kubefed-namespace option for `kubefedctl join` can be used to override the reference to the namespace where the KubeFed Control Plane is running, it defaults to `federation-namespace`.

``kubefedctl join cluster1 --host-cluster-context cluster1 --v=2 --kubefed-namespace=test-namespace``{{execute HOST1}}

Now it is time to register `cluster2`.

``kubefedctl join cluster2 --host-cluster-context cluster1 --v=2 --kubefed-namespace=test-namespace``{{execute HOST1}}

The above command will register `cluster2` and will be treated as `Member Cluster`.

Now we can verify both clusters have been registered:

``oc --context=cluster1 get kubefedclusters -n test-namespace``{{execute HOST1}}

If everything went okay, you should see both clusters registered and reporting a healthy status by the API (it can take some time):

```
NAME       READY     AGE
cluster1   True      28s
cluster2   True      21s
```