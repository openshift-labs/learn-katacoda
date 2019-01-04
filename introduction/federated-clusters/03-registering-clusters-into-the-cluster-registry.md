Currently, we have two OpenShift clusters, one of them (`cluster1`) is running the Federation Control Plane. Now it is time to register each cluster into the `Kubernetes Cluster Registry` using the `kubefed2` tool which has already been installed on the environment for your convenience.

`kubefed2` resides in the [upstream repo]( https://github.com/kubernetes-sigs/federation-v2/) and can be downloaded from the [releases section](https://github.com/kubernetes-sigs/federation-v2/releases/).

Before registering both clusters we are going to check that no clusters are registered yet.

``oc --context=cluster1 get federatedclusters -n federation-system``{{execute HOST1}}

``oc --context=cluster1 get clusters --all-namespaces``{{execute HOST1}}

The 'No resources found' message means there are no clusters registered yet, so it is time to register both clusters.

*NOTE:* Cluster names (cluster1 and cluster2) in the commands below are a reference to the contexts configured in the oc client. This has been already configured for you, otherwise you would need to make sure that the client contexts have been properly configured with the right access levels and context names. See [here](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/) for more information on contexts.

To register the clusters the `kubefed2` tool is used as:

``kubefed2 join <CLUSTER_NAME> --host-cluster-context <HOST_CLUSTER_CONTEXT> --cluster-context <MEMBER_CLUSTER_CONTEXT> --add-to-registry --v=2 --federation-namespace=<FEDERATION_NAMESPACE>``

The --cluster-context option for `kubefed2 join` can be used to override the reference to the client context configuration. When the option is not present, like in the commands below, `kubefed2` uses the cluster name to identify the client context.

The --federation-namespace option for `kubefed2 join` can be used to override the reference to the namespace where the Federation V2 Control Plane is running, it defaults to `federation-namespace`.

``kubefed2 join cluster1 --host-cluster-context cluster1 --add-to-registry --v=2``{{execute HOST1}}

Now it is time to register `cluster2`.

``kubefed2 join cluster2 --host-cluster-context cluster1 --add-to-registry --v=2``{{execute HOST1}}

The above command will register `cluster2` into the `Kubernetes Cluster Registry` and will be treated as `Member Cluster`.

Now we can verify both clusters have been registered:

``oc --context=cluster1 describe federatedclusters -n federation-system``{{execute HOST1}}

If everything went okay, you should see both clusters registered and reporting a healthy status by the API (it can take some time):

```
<OMMITED OUTPUT>
Spec:
  Cluster Ref:
    Name:  cluster1
  Secret Ref:
    Name:  cluster1-rrlzf
Status:
  Conditions:
    Last Probe Time:       2019-01-30T11:11:55Z
    Last Transition Time:  2019-01-30T11:09:55Z
    Message:               /healthz responded with ok
    Reason:                ClusterReady
    Status:                True
    Type:                  Ready

<OMMITED OUTPUT>
Spec:
  Cluster Ref:
    Name:  cluster2
  Secret Ref:
    Name:  cluster2-h5xgh
Status:
  Conditions:
    Last Probe Time:       2019-01-30T11:11:55Z
    Last Transition Time:  2019-01-30T11:11:15Z
    Message:               /healthz responded with ok
    Reason:                ClusterReady
    Status:                True
    Type:                  Ready
```
