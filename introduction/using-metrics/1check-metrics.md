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

*NOTE:* For more information about the metrics components see [the official documentation](https://docs.openshift.org/latest/install_config/cluster_metrics.html)

Metrics components such as heapster should gather information from all hosts
therefore they should be protected from regular users. That's why the metrics
components such as pods, secrets, etc. are deployed in the `openshift-infra`
namespace where only the cluster-admin roles can use.

In order to see the running pods for metrics components, it is required to be
logged as the `system:admin` user. The `system:admin` user is a special user
created in OpenShift that doesn't use password for authentication but
certificates.

Type the following in the _Terminal_ to login as `system:admin`:

``oc login -u system:admin``{{execute}}

You should see an output message with a confirmation you are logged as `system:admin` user as:

```
Logged into "https://172.17.0.10:8443" as "system:admin" using existing credentials.
...
```

*NOTE:* If you are curious, explore the `~/.kube/` folder where the user
configuration is stored.

Once logged as the cluster-admin user (`system:admin`), check the pods running
the metrics components using:

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
