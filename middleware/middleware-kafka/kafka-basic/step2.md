With AMQ Streams installed, you create a Kafka cluster, then a topic within the cluster.

When you create a cluster, the Cluster Operator you deployed when installing AMQ Streams watches for new Kafka resources.

## Creating a cluster

Create a new Kafka cluster named `my-cluster` with 1 Zookeeper and 1 broker node. Use `ephemeral` storage to simplify the deployment. In production case scenarios, you will want to increase the amount of nodes and use a more persistent approach.

Issue the following command:

```cat << EOF | oc create -f -
apiVersion: kafka.strimzi.io/v1beta1
kind: Kafka
metadata:
  name: my-cluster
spec:
  kafka:
    replicas: 1
    listeners:
      plain: {}
    storage:
      type: ephemeral
  zookeeper:
    replicas: 1
    storage:
      type: ephemeral
  entityOperator:
    topicOperator: {}
EOF
```{{execute}}

Wait for the cluster to be deployed:

``oc -n kafka wait kafka/my-cluster --for=condition=Ready --timeout=300s``{{execute}}

When your cluster is ready, create a topic to publish and subscribe from your external client.

Create the following `my-topic` custom resource definition with 1 replicas and 1 partitions in the `my-cluster` Kafka cluster:

```cat << EOF | oc create -f -
apiVersion: kafka.strimzi.io/v1beta1
kind: KafkaTopic
metadata:
  name: my-topic
  labels:
    strimzi.io/cluster: "my-cluster"
spec:
  partitions: 1
  replicas: 1
EOF
```{{execute}}

This will create a Kafka Topic resource in the cluster where we will be sending and receiving events.
