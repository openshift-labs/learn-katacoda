With AMQ Streams installed, you create a Kafka cluster, then a topic within the cluster.

When you create a cluster, the Cluster Operator you deployed when installing AMQ Streams watches for new Kafka resources.

## Creating a cluster

Create a new Kafka cluster named `my-cluster` with 1 Zookeeper and 1 broker node. Use `ephemeral` storage to simplify the deployment. In production case scenarios, you will want to increase the amount of nodes and use a more persistent approach.

Check the contents of the file:

`cat /opt/kafka-cluster.yaml`{{execute}}

Then create the Kafka cluster by issuing the following command:

`oc -n kafka apply -f /opt/kafka-cluster.yaml`{{execute}}

## Check Kafka cluster deployment

Follow up the Zookeeper and Kafka deployment to validate it is running.

To watch the pods status run the following command:

``oc -n kafka get pods -w``{{execute}}

You will see the pods for Zookeeper, Kafka and the Entity Operator changing the status to `running`. It should look similar to the following:

```bash
NAME                                                   READY   STATUS              RESTARTS   AGE
amq-streams-cluster-operator-v1.5.3-59666d98cb-8ptlz   0/1     ContainerCreating   0          10s
amq-streams-cluster-operator-v1.5.3-59666d98cb-8ptlz   0/1     Running             0          18s
amq-streams-cluster-operator-v1.5.3-59666d98cb-8ptlz   1/1     Running             0          34s
```

`Hit Ctrl + C to stop the process.`{{execute interrupt}}

## Create a Kafka Topic

When your cluster is ready, create a topic to publish and subscribe from your external client.

Create the following `my-topic` custom resource definition with 1 replicas and 1 partitions in the `my-cluster` Kafka cluster.

Check the content of the file:

`cat /opt/kafka-topic.yaml`{{execute}}

Then apply the custom resource for the operator to pick it up:

`oc -n kafka apply -f /opt/kafka-topic.yaml`{{execute}}

This will create a Kafka Topic resource in the cluster where we will be sending and receiving events. Now we can interact with the cluster.
