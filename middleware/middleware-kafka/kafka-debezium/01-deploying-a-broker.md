Debezium uses the Apache Kafka Connect framework, and Debezium connectors are implemented as Kafka Connector source connectors.

Debezium connectors capture change events from database tables and emit records of those changes to a [Red Hat AMQ Streams](https://developers.redhat.com/blog/2018/10/29/how-to-run-kafka-on-openshift-the-enterprise-kubernetes-with-amq-streams/) Kafka cluster.
Applications can consume event records through AMQ Streams.

In AMQ Streams, you use Kafka Connect custom Kubernetes resources to deploy and manage the Debezium connectors.

### Logging in to the cluster from the OpenShift CLI

To log in to the OpenShift cluster from a _terminal_, enter the following command:

``oc login -u developer -p developer``{{execute}}

The preceding command logs you in with the following credentials:

* **Username:** ``developer``
* **Password:** ``developer``

You can use the same credentials to log into the web console.

### Creating a namespace

Let's create a namespace (project) with the name ``debezium`` for the AMQ Streams Kafka Cluster Operator.
Enter the following command:

``oc new-project debezium``{{execute}}

### Creating a Kafka cluster

Now we'll create a Kafka cluster named `my-cluster` that has one ZooKeeper node and one broker node.
To simplify the deployment, the YAML file that we'll use to create the cluster specifies the use of `ephemeral` storage.

> **Note:**
    The Red Hat AMQ Streams Operator is pre-installed in the cluster. Because we don't have to install the Operators in this scenario,`admin` permissions are not required to complete the steps that follow. In an actual deployment, to make an Operator available from all projects in a cluster, you must be logged in with `admin` permission before you install the Operator.

Enter the following command to create the Kafka cluster:

`oc -n debezium apply -f /root/projects/debezium/kafka-cluster.yaml`{{execute}}

### Checking the status of the Kafka cluster

Verify that the ZooKeeper and Kafka pods are deployed and running in the cluster.

Enter the following command to check the status of the pods:

``oc -n debezium get pods -w``{{execute}}

After a few minutes, the status of the pods for ZooKeeper, Kafka, and the Entity Operator change to `running`.
The output of the `get pods` command should look similar to the following example:

```bash
NAME                                                   READY   STATUS              RESTARTS   AGE
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

> Notice that the Cluster Operator starts the Apache ZooKeeper clusters, as well as the broker nodes and the Entity Operator.
The ZooKeeper and Kafka clusters are based in Kubernetes StatefulSets.

Enter <kbd>Ctrl</kbd>+<kbd>C</kbd> to stop the process.

`^C`{{execute ctrl-seq}}

### Verifying that the broker is running

Enter the following command to send a message to the broker that you just deployed:

``echo "Hello world" | oc exec -i -c kafka my-cluster-kafka-0 -- /opt/kafka/bin/kafka-console-producer.sh --bootstrap-server localhost:9092 --topic test``{{execute interrupt}}

>The command does not return any output unless it fails.
If you see warning messages in the the following format, you can ignore them:

```
>[2021-01-11 20:37:29,491] WARN [Producer clientId=console-producer] Error while fetching metadata with correlation id 1 : {test=LEADER_NOT_AVAILABLE} (org.apache.kafka.clients.NetworkClient)
```

These warnings result because the producer requests metadata from the topic that it wants to write to, but that topic and the broker partition leader don't exist yet in the cluster.

To verify that the broker is available, enter the following command to retrieve a message from the broker:

``oc exec -c kafka my-cluster-kafka-0 -- /opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning --max-messages 1``{{execute}}

The broker processes the message that you sent in the previous command, and it returns the ``Hello world`` string.

You have successfully deployed the Kafka broker service and made it available to clients to produce and consume messages.

In the next step of this scenario, we will deploy a single instance of Debezium.
