In this self-paced tutorial, you will learn how to work with the etcd operator, used to manage etcd clusters deployed to Kubernetes and automates tasks related to operating an etcd cluster.

In this tutorial, you will gain an understanding of:
- [Create and Destroy](https://github.com/coreos/etcd-operator#create-and-destroy-an-etcd-cluster)
- [Resize](https://github.com/coreos/etcd-operator#resize-an-etcd-cluster)
- [Failover](https://github.com/coreos/etcd-operator#failover)
- [Rolling upgrade](https://github.com/coreos/etcd-operator#upgrade-an-etcd-cluster)
- [Backup and Restore](https://github.com/coreos/etcd-operator#backup-and-restore-an-etcd-cluster)

## Getting started

The etcd operator manages etcd clusters deployed to Kubernetes and automates tasks related to operating an etcd cluster. Read [Best Practices](https://github.com/coreos/etcd-operator/blob/master/doc/best_practices.md) for more information on how to better use etcd operator. Read [RBAC docs](https://github.com/coreos/etcd-operator/blob/master/doc/user/rbac.md) for how to setup RBAC rules for etcd operator if RBAC is in place. Finally the [Resources and Labels](https://github.com/coreos/etcd-operator/blob/master/doc/user/resource_labels.md) doc for an overview of the resources created by the etcd-operator.

In the following sections, you will go through each of the above topics to automate tasks related to operating an etcd cluster. Let's get started!