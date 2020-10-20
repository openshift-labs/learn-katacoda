In order to run this tutorial, you will need access to an OpenShift environment.
And we also have access to Kafka cluster in the environment. Let's setup the fundamentals.

This tutorial is an simple *Managed File Transfer* scenario, where a laboratory uploads medical reports to an online object store, and we will need to transfer the file from the cloud object store to our local FTP server in order for the legacy system to consume.

![overview](/openshift/assets/middleware/middleware-camelk/camel-kafka-connector/camel-kafka-step01-overview.png)

## Logging in to the Cluster via CLI

Before creating any applications, login as admin. This will be required if you want to log in to the web console and
use it.

To login to the OpenShift cluster from the _Terminal_ run:

``oc login -u admin -p admin``{{execute}}

This will log you in using the credentials:

* **Username:** ``admin``
* **Password:** ``admin``

Use the same credentials to log into the web console.

(OPTIONAL): Click the [Console](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com) tab to open the dashboard.

## Create a new namespace for this tutorial

To create a new project called ``camel-kafka`` run the command:

``oc project camel-kafka``{{execute}}

## Start up the Kafka Cluster and the Kafka Connect

AMQ Streams simplifies the process of running Apache Kafka in an Openshift cluster.
Now let's deploy a Kafka broker cluster, the AMQ Streams Operator is already subscribed in the cluster,
simply create the cluster by defining the resource definition:

``oc create -f strimzi/kafka-cluster.yaml``{{execute}}

Below indicates AMQ Streams has accept the configuration, and now starting to process.
```
kafka.kafka.strimzi.io/my-cluster created
```

If everything goes right, you will be able to see the pods initiated in the namespace:
``oc get pod -w``{{execute}}

```
amq-streams-cluster-operator-v1.5.3-7bbf5cdfdc-4kq7q   1/1     Running   0          3m15s
my-cluster-entity-operator-59cf586599-vdmk5            0/3     Running   0          7s
my-cluster-kafka-0                                     2/2     Running   0          40s
my-cluster-kafka-1                                     2/2     Running   0          40s
my-cluster-kafka-2                                     2/2     Running   0          40s
my-cluster-zookeeper-0                                 1/1     Running   0          71s
my-cluster-zookeeper-1                                 1/1     Running   0          71s
my-cluster-zookeeper-2                                 1/1     Running   0          71s
```
Ctrl+C to exit the mode.
