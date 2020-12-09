In this scenario, you will create a Quarkus application that uses the [MicroProfile Reactive Messaging](https://download.eclipse.org/microprofile/microprofile-reactive-messaging-1.0/microprofile-reactive-messaging-spec.pdf) extension to send events to Apache Kafka.

Kafka is generally used for two broad classes of applications:

- Building real-time streaming data pipelines that reliably get data between systems or applications
- Building real-time streaming applications that transform or react to the streams of data

The Quarkus extension uses [SmallRye Reactive Messaging](https://smallrye.io/smallrye-reactive-messaging/smallrye-reactive-messaging/2/index.html) to implement the connectors to Kafka. SmallRye is a framework for building event-driven, data streaming, and event-sourcing applications using [Context and Dependency Injection](http://www.cdi-spec.org/) (CDI) for Java.

## Channels and Streams

When dealing with event-driven or data streaming application, there are a few concepts and vocabulary to introduce.

In the application, `Messages` transit on a _channel_. A _channel_ is a virtual destination identified by a name. SmallRye Reactive Messaging connects the component to channel they read and to channel they populate. The resulting structure is a stream: Messages flow between components through channels.

## Connectors

The application then interacts with the event broker using _connectors_. A _connector_ is a piece of code that connects to a broker and:

1. subscribe / poll / receive messages from the broker and propagate them to the application
2. send / write / dispatch messages provided by the application to the broker

To achieve this, connectors are configured to map incoming messages to a specific *channel* (consumed by the application) and to collect outgoing messages sent to a specific channel by the application.

Each connector has a name. This name is referenced by the application to indicate that a specific channel is managed by this connector.

## Apache Kafka Connector

The Kafka connector adds support for Kafka to Reactive Messaging. With it you can receive Kafka Records as well as write `message` into Kafka.

The Kafka Connector is based on the [Vert.x Kafka Client](https://vertx.io/docs/vertx-kafka-client/java/).
