Consuming messages is not so simple as producing because there are several steps to do which involve different endpoints. First of all, you create a consumer through the `/consumers/{groupid}` endpoint by sending an HTTP POST with a body containing some of the supported configuration parameters, the name of the consumer and the data format (JSON or binary). 

### Create the consumer

We are going to create a consumer named `my-consumer` that will join the consumer group `my-group`.

Execute the following command to create the consumer:

``curl -k -X POST https://my-bridge-bridge-service-kafka.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/consumers/my-group -H 'content-type: application/vnd.kafka.v2+json' -d '{"name": "my-consumer","format": "json","auto.offset.reset": "earliest","enable.auto.commit": false}'``{{execute}}

This will create a Kafka consumer connected to the Kafka cluster. The bridge should reply back with a `200 OK` HTTP code and a JSON payload similar to the following:

```json
{ 
   "instance_id":"my-consumer",
   "base_uri":"http://my-bridge.io:80/consumers/my-group/instances/my-consumer"
}
```

### Topic subscription

The most common way for a Kafka consumer to get messages from a topic is to subscribe to that topic as part of a consumer group and have partitions assigned automatically.

Using the HTTP bridge, it’s possible through an HTTP POST to the `/consumers/{groupid}/instances/{name}/subscription` endpoint providing in a JSON formatted payload the list of topics to subscribe to or a topics pattern.

Subscribe your `my-consumer` consumer to the `my-topic` topic with the following command:

``curl -k -X POST http://my-bridge.io/consumers/my-group/instances/my-consumer/subscription -H 'content-type: application/vnd.kafka.v2+json' -d '{"topics": ["my-topic"]}'``{{execute}}

>This will return a `200 OK` HTTP code with an empty body.

Now is time to receive some messages.
