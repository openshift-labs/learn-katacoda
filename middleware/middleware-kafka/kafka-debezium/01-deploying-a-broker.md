Debezium uses the Apache Kafka Connect framework. Debezium connectors are implemented as Kafka Connector source connectors.

Debezium connectors capture change events from database tables and emit records of those changes to a [Red Hat AMQ Streams](https://developers.redhat.com/blog/2018/10/29/how-to-run-kafka-on-openshift-the-enterprise-kubernetes-with-amq-streams/) Kafka cluster. Applications can consume event records through AMQ Streams.

In AMQ Streams, you use Kafka Connect custom Kubernetes resources to deploy and manage the Debezium connectors.

### Logging in to the cluster from the OpenShift CLI

Log in to the OpenShift cluster from a _terminal_ with the following command:

``oc login -u developer -p developer``{{execute}}

The command logs you in with the following credentials:

* **Username:** ``developer``
* **Password:** ``developer``

You can use the same credentials to log into the web console.

### Creating a namespace

Create a namespace (project) with the name ``debezium`` for the AMQ Streams Kafka Cluster Operator:

``oc new-project debezium``{{execute}}

### Creating a Kafka cluster

Now we'll create a Kafka cluster named `my-cluster` that has one ZooKeeper node and one Kafka broker node.
To simplify the deployment, the YAML file that we'll use to create the cluster specifies the use of `ephemeral` storage.

> **Note:**
    Red Hat AMQ Streams Operators are pre-installed in the cluster. Because we don't have to install the Operators in this scenario,`admin` permissions are not required to complete the steps that follow. In an actual deployment, to make an Operator available from all projects in a cluster, you must be logged in with `admin` permission before you install the Operator.

Create the Kafka cluster by applying the following command:

`oc -n debezium apply -f /root/projects/debezium/kafka-cluster.yaml`{{execute}}

### Checking the status of the Kafka cluster

Verify that the ZooKeeper and Kafka pods are deployed and running in the cluster.

Enter the following command to check the status of the pods:

``oc -n debezium get pods -w``{{execute}}

After a few minutes, the status of the pods for ZooKeeper, Kafka, and the AMQ Streams Entity Operator change to `running`.
The output of the `get pods` command should look similar to the following example:

```bash
NAME                                         READY  STATUS              
my-cluster-zookeeper-0                       0/1    ContainerCreating    
my-cluster-zookeeper-0                       1/1    Running           
my-cluster-kafka-0                           0/2    Pending                   
my-cluster-kafka-0                           0/2    ContainerCreating   
my-cluster-kafka-0                           0/2    Running           
my-cluster-kafka-0                           1/2    Running             
my-cluster-kafka-0                           2/2    Running             
my-cluster-entity-operator-57bb594d9d-z4gs6  0/2    Pending               
my-cluster-entity-operator-57bb594d9d-z4gs6  0/2    ContainerCreating   
my-cluster-entity-operator-57bb594d9d-z4gs6  0/2    Running            
my-cluster-entity-operator-57bb594d9d-z4gs6  1/2    Running             
my-cluster-entity-operator-57bb594d9d-z4gs6  2/2    Running             
```

> Notice that the Cluster Operator starts the Apache ZooKeeper clusters, as well as the broker nodes and the Entity Operator.
The ZooKeeper and Kafka clusters are based in Kubernetes StatefulSets.

Enter <kbd>Ctrl</kbd>+<kbd>C</kbd> to stop the process.

`^C`{{execute ctrl-seq}}

### Verifying that the broker is running

Enter the following command to send a message to the broker that you just deployed:

``echo "Hello world" | oc exec -i -c kafka my-cluster-kafka-0 -- /opt/kafka/bin/kafka-console-producer.sh --bootstrap-server localhost:9092 --topic test``{{execute interrupt}}

The command does not return any output unless it fails.
If you see warning messages in the following format, you can ignore them:

```
>[DATE] WARN [Producer clientId=console-producer] Error while fetching metadata with correlation id 1 : {test=LEADER_NOT_AVAILABLE} (org.apache.kafka.clients.NetworkClient)
```

The error is generated when the producer requests metadata for the topic, because the producer wants to write to a topic and broker partition leader that does not exit yet.

To verify that the broker is available, enter the following command to retrieve a message from the broker:

``oc exec -c kafka my-cluster-kafka-0 -- /opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning --max-messages 1``{{execute}}

The broker processes the message that you sent in the previous command, and it returns the ``Hello world`` string.

You have successfully deployed the Kafka broker service and made it available to clients to produce and consume messages.

In the next step of this scenario, we will deploy a single instance of Debezium.
