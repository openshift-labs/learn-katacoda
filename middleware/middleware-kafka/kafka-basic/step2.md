With AMQ Streams installed, create a Kafka cluster, then a topic within the cluster.

When you create a cluster, the Cluster Operator you deployed when installing AMQ Streams watches for new Kafka resources.

### Creating a Kafka cluster

Create a new Kafka cluster named `my-cluster`, with 1 ZooKeeper, 1 broker node, and `ephemeral` storage to simplify the deployment. In production case scenarios, you will want to increase the amount of nodes and use persistent storage.

Check the configuration for the `Kafka` custom resource:

`cat /opt/kafka-cluster.yaml`{{execute interrupt}}

Then create the Kafka cluster by applying the configuration:

`oc -n kafka apply -f /opt/kafka-cluster.yaml`{{execute}}

### Checking the Kafka cluster deployment

Check the ZooKeeper and Kafka deployment is running.

To watch the status of the pods run the following command:

``oc -n kafka get pods -w``{{execute}}

You will see the status of the pods for ZooKeeper, Kafka, and the Entity Operator changing to `Running`:

```bash
NAME                                                   READY   STATUS              RESTARTS   AGE
amq-streams-cluster-operator-v1.5.3-59666d98cb-frcv9   1/1     Running             0          4m27s
my-cluster-zookeeper-0                                 0/1     ContainerCreating   0          3s
my-cluster-zookeeper-0                                 0/1     ContainerCreating   0          5s
my-cluster-zookeeper-0                                 0/1     Running             0          23s
my-cluster-zookeeper-0                                 1/1     Running             0          38s
my-cluster-kafka-0                                     0/2     Pending             0          0s
my-cluster-kafka-0                                     0/2     Pending             0          0s
my-cluster-kafka-0                                     0/2     ContainerCreating   0          0s
my-cluster-kafka-0                                     0/2     ContainerCreating   0          2s
my-cluster-kafka-0                                     0/2     Running             0          4s
my-cluster-kafka-0                                     1/2     Running             0          20s
my-cluster-kafka-0                                     2/2     Running             0          27s
my-cluster-entity-operator-57bb594d9d-z4gs6            0/2     Pending             0          0s
my-cluster-entity-operator-57bb594d9d-z4gs6            0/2     Pending             0          0s
my-cluster-entity-operator-57bb594d9d-z4gs6            0/2     ContainerCreating   0          1s
my-cluster-entity-operator-57bb594d9d-z4gs6            0/2     ContainerCreating   0          3s
my-cluster-entity-operator-57bb594d9d-z4gs6            0/2     Running             0          4s
my-cluster-entity-operator-57bb594d9d-z4gs6            1/2     Running             0          18s
my-cluster-entity-operator-57bb594d9d-z4gs6            2/2     Running             0          21s
```

The Entity Operator contains the Topic Operator.

> You can notice the Cluster Operator starts the Apache ZooKeeper cluster as well as the broker nodes and the Entity Operator. The Zookeeper and Kafka cluster are based on Kubernetes StatetulSets.

Press <kbd>Ctrl</kbd>+<kbd>C</kbd> to stop the process.

`^C`{{execute ctrl-seq}}

### Create a Kafka Topic to store your events

When your cluster is ready, create a topic to subscribe and publish to from your external client.

Create a `my-topic` custom resource definition with 1 replica and 1 partition in the `my-cluster` Kafka cluster.

Check the configuration for the `KafkaTopic` custom resource:

`cat /opt/kafka-topic.yaml`{{execute interrupt}}

Then apply the custom resource for the Topic Operator to pick up:

`oc -n kafka apply -f /opt/kafka-topic.yaml`{{execute}}

This creates a Kafka topic in the cluster for sending and receiving events. Now we are ready to interact with the cluster.
