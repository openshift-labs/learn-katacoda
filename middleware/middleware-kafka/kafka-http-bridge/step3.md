Before you can perform any consumer operations in the Kafka cluster, you must first create a consumer by using the consumers endpoint.

You create a consumer through the `/consumers/{groupid}` endpoint by sending an HTTP POST with a body containing some of the supported configuration parameters, the name of the consumer and the data format.

### Creating a consumer

We are going to create a Kafka Bridge consumer named `my-consumer` that will join the consumer group `my-group`.

Execute the following command to create the consumer:

``curl -s -k -X POST https://my-bridge-bridge-service-kafka.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/consumers/my-group -H 'content-type: application/vnd.kafka.v2+json' -d '{"name": "my-consumer","format": "json","auto.offset.reset": "earliest","fetch.min.bytes": 512,"enable.auto.commit": false}' | jq``{{execute}}

This will create a Kafka consumer connected to the Kafka cluster. If the request is successful, the bridge will reply back with a `200 OK` HTTP code, and a JSON payload with the consumer ID (`instance_id`) and base URL (`base_uri`).

It should look similar to the following example of the output:

```json
{
   "instance_id":"my-consumer",
   "base_uri":"http://my-bridge-bridge-service-kafka.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/consumers/my-group/instances/my-consumer"
}
```

### Subscribing to a topic

The most common way for a Kafka consumer to get messages from a topic is to subscribe to that topic as part of a consumer group and have partitions assigned automatically.

Using the HTTP bridge, subscription is possible through an HTTP POST to the `/consumers/{groupid}/instances/{name}/subscription` endpoint, providing a list of topics to subscribe to or a topic pattern in a JSON formatted payload.

Subscribe your `my-consumer` consumer to the `my-topic` topic with the following command:

``curl -i -k -X POST https://my-bridge-bridge-service-kafka.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/consumers/my-group/instances/my-consumer/subscription -H 'content-type: application/vnd.kafka.v2+json' -d '{"topics": ["my-topic"]}'``{{execute}}

>This will return a `204 OK` HTTP code with an empty body.

The `topics` array can contain a single topic (as shown here) or multiple topics. If you want to subscribe the consumer to multiple topics that match a regular expression, you can use the `topic_pattern` string instead of the `topics` array.

After subscribing a Kafka Bridge consumer to topics, you can retrieve messages from the consumer.
