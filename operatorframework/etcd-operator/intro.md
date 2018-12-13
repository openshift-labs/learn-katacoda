The etcd operator manages etcd clusters deployed to Kubernetes and automates tasks related to operating an etcd cluster.

- [Create and Destroy](#create-and-destroy-an-etcd-cluster)
- [Resize](#resize-an-etcd-cluster)
- [Failover](#failover)
- [Rolling upgrade](#upgrade-an-etcd-cluster)
- [Backup and Restore](#backup-and-restore-an-etcd-cluster)

There are [more spec examples](./doc/user/spec_examples.md) on setting up clusters with different configurations

Read [Best Practices](./doc/best_practices.md) for more information on how to better use etcd operator.

Read [RBAC docs](./doc/user/rbac.md) for how to setup RBAC rules for etcd operator if RBAC is in place.

Read [Developer Guide](./doc/dev/developer_guide.md) for setting up a development environment if you want to contribute.

See the [Resources and Labels](./doc/user/resource_labels.md) doc for an overview of the resources created by the etcd-operator.