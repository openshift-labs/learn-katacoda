Change data capture, or CDC, is a well-established software design pattern for capturing changes to tables in a database.
CDC captures row-level changes that occur in database tables and emits event records for those changes to a Kafka data streaming bus.
You can configure applications that rely on the data in particular tables to consume the change event streams for those tables.
Consuming applications read the streams of event records in the order in which the events occurred.

### What you will learn

In this scenario you will learn about [Debezium](https://debezium.io/), a component of [Red Hat Integration](https://www.redhat.com/en/products/integration) that provides change data capture for the following supported databases:

* Db2
* Microsoft SQL Server
* MongoDB
* MySQL
* PostgreSQL

You will deploy a complete end-to-end solution that captures events from database transaction logs and makes those events available for processing by downstream consumers through an [Apache Kafka](https://kafka.apache.org/) broker.

### What is Debezium?

![Logo](../../../assets/middleware/debezium-getting-started/debezium-logo.png)

[Debezium](https://debezium.io/) is a set of distributed services that capture row-level changes in a database.
Debezium records the change events for each table in a database to a dedicated Kafka topic.
You can configure applications to read from the topics that contain change event records for data in specific tables.
The consuming applications can then respond to the change events with minimal latency.
Applications read event records from a topic in the same order in which the events occurred.

 A Debezium source connector captures change events from a database and uses the [Apache Kafka](https://kafka.apache.org/) streaming platform to distribute and publish the captured event records to a [Kafka broker](https://kafka.apache.org/documentation/#uses_messaging).
Each Debezium source connector is built as a plugin for [Kafka Connect](https://kafka.apache.org/documentation/#connect).

In this scenario we will deploy a Debezium MySQL connector and use it to set up a data flow between a MySQL database and a Kafka broker.
