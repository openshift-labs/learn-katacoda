Apache Kafka uses a custom protocol on top of TCP/IP for communication between applications and the Kafka cluster. Clients are supported in many different programming languages, but there are certain scenarios where it is not possible to use such clients. In this situation, you can use the standard HTTP/1.1 protocol to access Kafka instead.

The Red Hat AMQ Streams Kafka Bridge provides an API for integrating HTTP-based clients with a Kafka cluster running on AMQ Streams. Applications can perform typical operations such as:

* Sending messages to topics
* Subscribing to one or more topics
* Receiving messages from the subscribed topics
* Committing offsets related to the received messages
* Seeking to a specific position

As with AMQ Streams, the Kafka Bridge is deployed into an OpenShift cluster using the AMQ Streams Cluster Operator, or installed on Red Hat Enterprise Linux using downloaded files.

![HTTP integration](https://access.redhat.com/webassets/avalon/d/Red_Hat_AMQ-7.7-Using_AMQ_Streams_on_OpenShift-en-US/images/750556a6bc4af4daeca4b1df0fd24835/kafka-bridge.png)

In the following tutorial, you will deploy the Kafka Bridge and use it to connect to your Apache Kafka cluster using HTTP.
