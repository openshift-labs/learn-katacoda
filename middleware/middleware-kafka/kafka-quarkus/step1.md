You start this scenario with a basic Maven-based application, which is created using the Quarkus maven plugin.

### Add an extension to integrate with Kafka

The current project needs the extensions to be added to integrate Quarkus with Apache Kafka.

Change to the project folder:

``cd /opt/projects/kafka-quarkus``{{execute}}

Install the extension into the project with the following command:

``mvn quarkus:add-extension -Dextension="quarkus-smallrye-reactive-messaging-kafka"``{{execute}}

>The first time you add the extension will take longer, as Maven downloads new dependencies.

This will add the necessary entries in your `pom.xml`{{open}} to bring in the Kafka extension. You should see a fragment similar to this around line 50:

```xml
...
<dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-smallrye-reactive-messaging-kafka</artifactId>
</dependency>
...
```

### Configure a channel to integrate with the event broker

Next, we need to configure the application to define how are we going to connect to the event broker.

The MicroProfile Reactive Messaging properties are structured as follows:

```properties
mp.messaging.[outgoing|incoming].{channel-name}.property=value
```

The `channel-name` segment must match the value set in the `@Incoming` and `@Outgoing` annotations. To indicate that a channel is managed by the Kafka connector we need:

```properties
mp.messaging.[outgoing|incoming].{channel-name}.connector=smallrye-kafka
```

Open the `src/main/resources/application.properties`{{open}} file to add the following configuration:

<pre class="file" data-filename="./src/main/resources/application.properties" data-target="replace">
# Configuration file
kafka.bootstrap.servers=my-cluster-kafka-bootstrap.kafka.svc.cluster.local:9092

mp.messaging.outgoing.uber.connector=smallrye-kafka
mp.messaging.outgoing.uber.key.serializer=org.apache.kafka.common.serialization.StringSerializer
mp.messaging.outgoing.uber.value.serializer=org.apache.kafka.common.serialization.StringSerializer
</pre>

> You can click **Copy to Editor** to add the values into the file

You can see we added the kafka bootstrap server hostname and port for the broker locations and the configuration for a channel named `uber`. The `key` and `value` serializers are part of the  [Producer configuration](https://kafka.apache.org/documentation/#producerconfigs) and [Consumer configuration](https://kafka.apache.org/documentation/#consumerconfigs) to encode the message payload.

>You don’t need to set the Kafka topic. By default, it uses the channel name (`uber`). You can, however, configure the topic attribute to override it.
