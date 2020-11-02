
This scenario will show how to deploy and connecto to [Apache Kafka on Kubernetes](https://developers.redhat.com/topics/kafka-kubernetes).

## What is Apache Kafka?

Apache Kafka is an alternative enterprise messaging system that moves massive amounts of data—not just from point A to B, but from points A to Z.

Apache Kafka has become the leading platform for building real-time data pipelines. Today, Kafka is heavily used for developing event-driven applications, where it lets services communicate with each other through events. Using Kubernetes for this type of workload requires adding specialized components such as Kubernetes Operators and connectors to bridge the rest of your systems and applications to the Kafka ecosystem.

### Apache Kafka on Kubernetes

Apache Kafka is a distributed data streaming platform that is a popular event processing choice. It can handle publishing, subscribing to, storing, and processing event streams in real-time. Apache Kafka supports a range of use cases where high throughput and scalability are vital, and by minimizing the need for point-to-point integrations for data sharing in certain applications, it can reduce latency to milliseconds.

### Strimzi: Kubernetes Operator for Apache Kafka

Strimzi is a CNCF Sandbox project which provides the leading community Operators to deploy and manage the components to run an Apache Kafka cluster on Kubernetes in various deployment configurations. This includes the Kafka brokers, Apache ZooKeeper, MirrorMaker and Kafka Connect.
