
This scenario will introduce [Camel Kafka Connector ](https://camel.apache.org/camel-kafka-connector/latest/index.html).

## What is Camel Kafka Connector?


![Logo](https://upload.wikimedia.org/wikipedia/commons/1/11/Apache_Camel_Logo.svg)


### Kafka Connector with a Camel twist -- connect to ALMOST anything

Camel Kafka Connector enables you to use standard Camel components as Kafka Connect connectors. This widens the scope of possible integrations beyond the external systems supported by Kafka Connect connectors alone. Camel Kafka Connector works as an adapter that makes the popular Camel component ecosystem available in Kafka-based AMQ Streams on OpenShift.

Camel Kafka Connector provides a user-friendly way to configure Camel components directly in the Kafka Connect framework. Using Camel Kafka Connector, you can leverage Camel components for integration with different systems by connecting to or from Camel Kafka sink or source connectors. You do not need to write any code, and can include the appropriate connector JARs in your Kafka Connect image and configure connector options using custom resources.


### AMQ Streams - Kubernetes-native Apache Kafka

The Red Hat AMQ streams component is a massively scalable, distributed, and high-performance data streaming platform based on the Apache Kafka project. It offers a distributed backbone that allows microservices and other applications to share data with high throughput and low latency.

As more applications move to Kubernetes and Red Hat OpenShift , it is increasingly important to be able to run the communication infrastructure on the same platform. Red Hat OpenShift, as a highly scalable platform, is a natural fit for messaging technologies such as Kafka. The AMQ streams component makes running and managing Apache Kafka OpenShift native through the use of powerful operators that simplify the deployment, configuration, management, and use of Apache Kafka on Red Hat OpenShift.
