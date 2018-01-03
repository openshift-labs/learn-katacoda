The OpenShift metrics is composed by a few pods running on the OpenShift
environment:

* *Heapster*: Heapster scrapes the metrics for CPU, memory and network usage on
every pod, then exports them into Hawkular Metrics.
* *Hawkular Metrics*: A metrics engine that stores the data persistently in a
Cassandra database.
* *Cassandra*: Database where the metrics data is stored.

Metrics components can be customized for longer
data persistence, pods limits, replicas of individual components, custom
certificates, etc. The customization is provided by the `Ansible` variables
as part of the deployment process.

By default, the metrics pods are deployed in the `openshift-infra` namespace.
To see the running pods for metrics components, type the following in the
_Terminal_:

``oc get pods -n openshift-infra``{{execute}}

You should see something similar to:

```
NAME                         READY     STATUS    RESTARTS   AGE
hawkular-cassandra-1-mf900   1/1       Running   0          1d
hawkular-metrics-c0x5w       1/1       Running   0          1d
heapster-xfs3m               1/1       Running   0          1d
```

There are quite a few more objects as part of the metrics components including
secrets, service accounts, replication controllers, etc.

Hawkular metrics is exposed through a route that is used in the web console
to show the pods metrics visually.

``oc get all -n openshift-infra``{{execute}}

The OpenShift metrics components deployed in this katacoda scenario are not
suitable for production environments. It is required to store the metrics in a
persistent volume to avoid data loss and the configuration should fit the
environment. This deployment should be used for learning purposes only.

For more information about the OpenShift metrics components, the deployment
process, etc. see the [official documentation](https://docs.openshift.org/latest/install_config/cluster_metrics.html)
