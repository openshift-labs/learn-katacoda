## What you will learn ##

In this scenario you will learn more about [Debezium](http://debezium.io/), a project that provides change data capture for any of supported databases
* MySQL
* PostgreSQL
* MongoDB
* Microsoft SQL Server
* Oracle (incubating)
* Apache Cassandra (incubating)

You will deploy a complete end-to-end solution that will capture events from database transaction logs and make those events available to processing by downstream consumers via an [Apache Kafka](https://kafka.apache.org/) broker.

## What is Debezium? 

![Logo](../../assets/middleware/debezium-getting-started/debezium-logo.png)

[Debezium](http://debezium.io/) is a set of distributed services capture row-level changes in your databases so that your applications can see and respond to those changes.
Debezium records all row-level changes committed to a particular database table in a dedicated message topic.
Each application simply reads the topic(s) they are interested in, and they see all of the events in the same order in which they occurred.

Technically Debezium utilizes the [Apache Kafka](https://kafka.apache.org/) streaming platform to distribute events captured from database.
It is a set of plug-ins for [Kafka Connect](https://kafka.apache.org/documentation/#connect) that publish messages to a [Kafka broker](https://kafka.apache.org/documentation/#uses_messaging).

The minimum components required for skeleton deployment are
* Kafka broker - consisting of a single [Apache ZooKeeper](https://zookeeper.apache.org/) instance for cluster management and a single node of Kafka broker
* Kafka Connect node - containing and configured to stream data from a database
* source database

The following diagram shows the minimal deployment

![Minimal deployment](../../assets/middleware/debezium-getting-started/minimal-deployment.png)

In the next steps we will deploy the components and get dataflow running from a MySQL database to a Kafka broker.
