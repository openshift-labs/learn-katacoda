A fresh project named `debezium` is prepared with the necessary resources required to execute the deployment.
There are multiple resources created for you in the home directory, the project itself or configured in OpenShift
* an installed [release 0.14.0](https://github.com/strimzi/strimzi-kafka-operator/releases/tag/0.14.0) of [Strimzi](http://strimzi.io) project Kafka operator
* Strimzi Cluster Operator managing Kafka brokers
* MySQL instance containing a small set of data to be streamed
* templates used to deploy components

**1. Run the following commands to switch to `debezium` project and explore it.**
> If you click on command it gets automatically copied it into the terminal and is executed

Switch to `debezium` project

``oc project debezium``{{execute}}

Check that MySQL instance is running

``oc get pods``{{execute}}

and that it is exposed as a service

``oc get svc``{{execute}}

The diagram of deployment now looks like

![Empty deployment](../../assets/middleware/debezium-getting-started/deployment-step-0.png)

**2. Deploy Kafka broker with ZooKeeper.**

The first component to deploy is a Kafka broker.

![Broker deployment](../../assets/middleware/debezium-getting-started/deployment-step-1.png)

This task is delegated to [templates](https://github.com/strimzi/strimzi/tree/0.2.0/examples/templates/cluster-controller) and Cluster Controller provided by [Strimzi](http://strimzi.io/) project.
The templates are already present in the home directory in the cloned repository.

The templates by default deploy Kafka broker and ZooKeeper in a high-available configuration with replication factor `3`.
This is not necessary in the development environment so we reduce the number of nodes and replication factor for system topics to `1`.

We also deploy an *ephemeral* variant of the broker.
You should use *persistent* variant in production.

To deploy the broker issue a command

``oc new-app strimzi-ephemeral -p ZOOKEEPER_NODE_COUNT=1 -p KAFKA_NODE_COUNT=1 -p KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 -p KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1
``{{execute}}

Now let's wait till both ZooKeeper and Kafka broker are deployed

``oc get pods -w``{{execute}}

The final list of pods should be similar to

    NAME                                          READY     STATUS    RESTARTS   AGE
    my-cluster-entity-operator-798b74565c-bkjwh   3/3       Running   1          32s
    my-cluster-kafka-0                            2/2       Running   0          1m
    my-cluster-zookeeper-0                        2/2       Running   0          1m
    mysql-1-w7shk                                 1/1       Running   0          9m
    strimzi-cluster-operator-5658b55c84-89mf5     1/1       Running   0          9m

> Note: Kafka depends on ZooKeeper so intermittent Kafka failures are expected as ZooKeeper might not be initialized at the time of Kafka start.

New services are available

``oc get svc -l app=strimzi-ephemeral``{{execute}}

    NAME                          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
    my-cluster-kafka-bootstrap    ClusterIP   172.30.136.36   <none>        9091/TCP,9092/TCP,9093/TCP   2m
    my-cluster-kafka-brokers      ClusterIP   None            <none>        9091/TCP,9092/TCP,9093/TCP   2m
    my-cluster-zookeeper-client   ClusterIP   172.30.82.207   <none>        2181/TCP                     3m
    my-cluster-zookeeper-nodes    ClusterIP   None            <none>        2181/TCP,2888/TCP,3888/TCP   3m

**3. Verify the broker is up and running.**

> Note: The complete initialization of all components can take a couple of minutes. Please make sure that all pods are in *Running* state and are *Ready* before you try the next steps.

A successful attempt to send a message to (no output expected here)

``echo "Hello world" | oc exec -i -c kafka my-cluster-kafka-0 -- /opt/kafka/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test``{{execute}}

and receive a message from

``oc exec -c kafka my-cluster-kafka-0 -- /opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning --max-messages 1``{{execute}}

the deployed broker indicates that it is available.

## Congratulations

You have now successfully executed the first step in this scenario. 

You have successfully deployed Kafka broker service and made it available to clients to produce and consume messages.

In the next step of this scenario, we will deploy a single instance of Debezium.
