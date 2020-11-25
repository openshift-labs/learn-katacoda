Apache Kafka uses a custom protocol on top of TCP/IP for communication between applications and the cluster. Clients are available for many different programming languages, but there are many scenarios in which a standard protocol such as HTTP/1.1 is more appropriate.

The Red Hat AMQ Streams Kafka Bridge provides an API for integrating HTTP-based clients with a Kafka cluster running on AMQ Streams. Applications can perform typical operations such as:

* Sending messages to topics.
* Subscribing to one or more topics.
* Receiving messages from the subscribed topics.
* Committing offsets related to the received messages.
* Seeking to a specific position.

Users can deploy the Kafka Bridge into an OpenShift cluster by using the AMQ Streams Operator or similar to an AMQ Streams installation, and users can download the Kafka Bridge files for installation on Red Hat Enterprise Linux.

In the following tutorial, you will deploy the bridge and use it to connect using HTTP with your Apache Kafka cluster.
