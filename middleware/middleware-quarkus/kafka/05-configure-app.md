# Configure the app

We need to configure our app to define how our app can connect to Kafka. Click: `src/main/resources/application.properties`{{open}} to open this file. This file contains Quarkus configuration and is empty. The names of the properties for the Kafka extension are structured as follows:

`mp.messaging.[outgoing|incoming].{channel-name}.property=value`

  - The `channel-name` segment must match the value set in the `@Incoming` and `@Outgoing` annotation:

  - `generated-price` → sink in which we write the prices

  - `prices` → source in which we read the prices

Click **Copy to Editor** to add the following values to the `application.properties` file:

<pre class="file" data-filename="./src/main/resources/application.properties" data-target="replace">
# Configure the Kafka sink (we write to it)
mp.messaging.outgoing.generated-name.bootstrap.servers=names-cluster-kafka-bootstrap.kafka.svc.cluster.local:9092
mp.messaging.outgoing.generated-name.connector=smallrye-kafka
mp.messaging.outgoing.generated-name.topic=names
mp.messaging.outgoing.generated-name.value.serializer=org.apache.kafka.common.serialization.StringSerializer

# Configure the Kafka source (we read from it)
mp.messaging.incoming.names.bootstrap.servers=names-cluster-kafka-bootstrap.kafka.svc.cluster.local:9092
mp.messaging.incoming.names.connector=smallrye-kafka
mp.messaging.incoming.names.value.deserializer=org.apache.kafka.common.serialization.StringDeserializer
</pre>

The hostnames used above refer to the in-cluster hostnames that resolve to our running Kafka cluster on OpenShift.

More details about this configuration is available on the [Producer
configuration](https://kafka.apache.org/documentation/#producerconfigs) and [Consumer
configuration](https://kafka.apache.org/documentation/#consumerconfigs) section from the Kafka documentation.

> **Note**
>
> What about `my-data-stream`? This is an in-memory stream, not connected to a message broker.

# Compilation Test

To make sure you've got a compilable app and code is in its proper place, let's test the build. Run this command to compile and package the app:

`mvn clean package`{{execute}}
