Finally, retrieve the latest messages from the Kafka Bridge consumer by requesting data from the `/consumers/{groupid}/instances/{name}/records` endpoint.

### Retrieving the latest messages from a Kafka Bridge consumer

Doing an HTTP GET against the above endpoint, actually does a “poll” for getting the messages from the already subscribed topics. The first “poll” operation after the subscription doesn’t always return records because it just starts the join operation of the consumer to the group and the rebalancing in order to get partitions assigned; doing the next poll actually can return messages if there are any in the topic.

Submit a `GET` request to the `records` endpoint:

``curl -k -X GET http://my-bridge.io/consumers/my-group/instances/my-consumer/records -H 'accept: application/vnd.kafka.json.v2+json'``{{execute}}

Repeat step two to retrieve messages from the Kafka Bridge consumer.

``curl -k -X GET http://my-bridge.io/consumers/my-group/instances/my-consumer/records -H 'accept: application/vnd.kafka.json.v2+json'``{{execute}}

The Kafka Bridge returns an array of messages — describing the topic name, key, value, partition, and offset — in the response body, along with a `200` code. Messages are retrieved from the latest offset by default.

You should get an output similar to the following:

```js
HTTP/1.1 200 OK
content-type: application/vnd.kafka.json.v2+json
#...
[
  {
    "topic":"my-topic",
    "key":"key-1",
    "value":"sales-lead-0001",
    "partition":0,
    "offset":0
  },
  {
    "topic":"my-topic",
    "key":"key-2",
    "value":"sales-lead-0003",
    "partition":0,
    "offset":1
  },
#...
```

### Commiting offsets to the log

Next, use the `/consumers/{groupid}/instances/{name}/offsets` endpoint to manually commit offsets to the log for all messages received by the Kafka Bridge consumer. This is required because the Kafka Bridge consumer that you created earlier, was configured with the enable.auto.commit setting as false.

Commit offsets to the log for the `my-consumer`:

``curl -X POST http://localhost:8080/consumers/bridge-quickstart-consumer-group/instances/bridge-quickstart-consumer/offsets`{{execute}}

>Because no request body is submitted, offsets are committed for all the records that have been received by the consumer. Alternatively, the request body can contain an array (OffsetCommitSeekList) that specifies the topics and partitions that you want to commit offsets for.

If the request is successful, the Kafka Bridge returns a `204` code only.

Congratulations! You were able to deploy the AMQ Streams HTTP Bridge to connect application using HTTP to a Kafka cluster. You sent some message to an example topic and then created a consumer to retrieve messages. Finally you commited the offsets of such messages.
