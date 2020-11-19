Change data capture, or CDC, is a well-established software design pattern for monitoring and capturing data changes in a database. CDC captures row-level changes to database tables and passes corresponding change events to a data streaming bus. Applications can read the change-event streams and access change events in the order that they happened.

### What you will learn

In this scenario you will learn more about [Debezium](http://debezium.io/), a component part of [Red Hat Integration](https://www.redhat.com/en/products/integration) that provides change data capture for any of the supported databases:

* MySQL
* PostgreSQL
* MongoDB
* Microsoft SQL Server
* Db2 (Technical Preview)

You will deploy a complete end-to-end solution that will capture events from database transaction logs and make those events available to processing by downstream consumers via an [Apache Kafka](https://kafka.apache.org/) broker.

### What is Debezium?

![Logo](../../../assets/middleware/debezium-getting-started/debezium-logo.png)

[Debezium](http://debezium.io/) is a set of distributed services capture row-level changes in your databases so that your applications can see and respond to those changes.
Debezium records all row-level changes committed to a particular database table in a dedicated message topic.
Each application simply reads the topic(s) they are interested in, and they see all of the events in the same order in which they occurred.

Technically Debezium utilizes the [Apache Kafka](https://kafka.apache.org/) streaming platform to distribute events captured from database.
It is a set of plug-ins for [Kafka Connect](https://kafka.apache.org/documentation/#connect) that publish messages to a [Kafka broker](https://kafka.apache.org/documentation/#uses_messaging).

In the next steps we will deploy the components and get dataflow running from a MySQL database to a Kafka broker.
