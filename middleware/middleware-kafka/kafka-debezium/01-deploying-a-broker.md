Debezium connectors record all events to a [Red Hat AMQ Streams](https://developers.redhat.com/blog/2018/10/29/how-to-run-kafka-on-openshift-the-enterprise-kubernetes-with-amq-streams/) Kafka cluster. Applications then consume those events through AMQ Streams. Debezium uses the Apache Kafka Connect framework, which makes all of Debezium’s connectors into Kafka Connector source connectors. As such, they can be deployed and managed using AMQ Streams’ Kafka Connect custom Kubernetes resources.

### Logging in to the Cluster via OpenShift CLI

Before creating any applications, login as admin. This will be required if you want to log in to the web console and use it.

To login to the OpenShift cluster from the _Terminal_ run:

``oc login -u developer -p developer``{{execute}}

This will log you in using the credentials:

* **Username:** ``developer``
* **Password:** ``developer``

Use the same credentials to log into the web console.

### Creating your own namespace

To create a new (project) namespace called ``debezium`` for the AMQ Streams Kafka Cluster Operator run the command:

``oc new-project debezium``{{execute}}

### Creating a Kafka cluster

Create a new Kafka cluster named `my-cluster` with 1 Zookeeper and 1 broker node using `ephemeral` storage to simplify the deployment. The Red Hat AMQ streams operator is already installed in the cluster.

Create the Kafka cluster by issuing the following command:

`oc -n debezium apply -f /root/projects/debezium/kafka-cluster.yaml`{{execute}}

### Check Kafka cluster deployment

Follow up the Zookeeper and Kafka deployment to validate it is running.

To watch the pods status run the following command:

``oc -n debezium get pods -w``{{execute}}

You will see the pods for Zookeeper, Kafka and the Entity Operator changing the status to `running`. It should look similar to the following:

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

> You can notice the Cluster Operator starts the Apache Zookeeper cluster as well as the broker nodes and the Entity Operator. The Zookeeper and Kafka cluster are based in Kubernetes StatetulSets.

Hit <kbd>Ctrl</kbd>+<kbd>C</kbd> to stop the process.

`^C`{{execute ctrl-seq}}

### Verify the broker is up and running

A successful attempt to send a message to (no output expected here)

``echo "Hello world" | oc exec -i -c kafka my-cluster-kafka-0 -- /opt/kafka/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test``{{execute interrupt}}

and receive a message from

``oc exec -c kafka my-cluster-kafka-0 -- /opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning --max-messages 1``{{execute}}

the deployed broker indicates that it is available.

You have successfully deployed Kafka broker service and made it available to clients to produce and consume messages.

In the next step of this scenario, we will deploy a single instance of Debezium.
