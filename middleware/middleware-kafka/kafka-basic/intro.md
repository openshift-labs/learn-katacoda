
This scenario will show how to deploy and connecto to [Apache Kafka on Kubernetes](https://developers.redhat.com/topics/kafka-kubernetes).

### What is Apache Kafka?

[Apache Kafka](https://www.redhat.com/en/topics/integration/what-is-apache-kafka) has become the leading platform for building real-time data pipelines. Today, Kafka is heavily used for developing event-driven applications, where it lets services communicate with each other through events. Using Kubernetes for this type of workload requires adding specialized components such as Kubernetes Operators and connectors to bridge the rest of your systems and applications to the Kafka ecosystem.

Apache Kafka is a distributed data streaming platform that is a popular event processing choice. It can handle publishing, subscribing to, storing, and processing event streams in real-time. Apache Kafka supports a range of use cases where high throughput and scalability are vital, and by minimizing the need for point-to-point integrations for data sharing in certain applications, it can reduce latency to milliseconds.

### Strimzi: Kubernetes Operator for Apache Kafka

[Strimzi](https://strimzi.io/) simplifies the process of running Apache Kafka in a Kubernetes cluster.
Strimzi is a CNCF Sandbox project which provides the leading community Operators for deploying and managing the components to run an Apache Kafka cluster on Kubernetes in various deployment configurations. This includes the Kafka brokers, Apache ZooKeeper, MirrorMaker and Kafka Connect.

### Red Hat Integration

To respond to business demands quickly and efficiently, you need a way to integrate applications and data spread across your enterprise. [Red Hat AMQ](https://www.redhat.com/en/technologies/jboss-middleware/amq) — based on open source communities like Apache ActiveMQ and Apache Kafka — is a flexible messaging platform that delivers information reliably, enabling real-time integration, and connecting the Internet of Things (IoT).

AMQ streams is a [Red Hat Integration](https://www.redhat.com/en/products/integration) component that supports Apache Kafka on OpenShift. Through AMQ Streams, Kafka operates as an “OpenShift-native” platform through the use of powerful AMQ Streams Operators that simplify the deployment, configuration, management, and use of Apache Kafka on OpenShift.

![Operators within the AMQ Streams architecture](https://access.redhat.com/webassets/avalon/d/Red_Hat_AMQ-7.7-Evaluating_AMQ_Streams_on_OpenShift-en-US/images/320e68d6e4b4080e7469bea094ec8fbf/operators.png)

* **Cluster Operator**
Deploys and manages Apache Kafka clusters, Kafka Connect, Kafka MirrorMaker, Kafka Bridge, Kafka Exporter, and the Entity Operator
* **Entity Operator**
Comprises the Topic Operator and User Operator
* **Topic Operator**
Manages Kafka topics
* **User Operator**
Manages Kafka users
