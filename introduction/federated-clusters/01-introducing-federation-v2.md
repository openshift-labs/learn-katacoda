[Federation V2](https://github.com/kubernetes-sigs/federation-v2) is a Kubernetes [Operator](https://coreos.com/operators) that provides tools for managing applications and services through multiple Kubernetes clusters tracked by the [Kubernetes Cluster Registry](https://github.com/kubernetes/cluster-registry).

Federation allows users to:

* Distribute workloads across clusters in the cluster registry

* Program DNS with information about those workloads

* Dynamically adjust replicas in the different clusters a workload is deployed in

* Provide disaster recovery for those workloads

As Federation V2 matures, we expect to add features related to storage management, workload placement, etc.

Federation V2 takes advantage of new mechanisms in order to extend the Kubernetes API and provide an easy interface for users to interconnect their Kubernetes clusters without having to deal with network latencies, etcd requirements, etc.

The Federation V2 control plane is composed of an Operator running on one of the federated clusters. This Operator is in charge of some [CRDs](https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/) which will be discussed later on in this course.

|Concept|Definition|
|-------|----------|
|Host Cluster|A cluster which is used to expose the Federation API and run the Federation Control Plane|
|Member Cluster|A cluster which is registered with the Federation API and that Federation controllers have authentication credentials for. The Host Cluster can also be a Member Cluster.|
