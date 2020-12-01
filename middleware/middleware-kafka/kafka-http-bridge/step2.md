In order to verify that the Ingress is working properly, try to hit the /healthy endpoint of the bridge with the following curl command:

``curl -ik https://my-bridge-bridge-service-kafka.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/healthy``{{execute interrupt}}

If the bridge is reachable through the OpenShift route, it will return an HTTP response with status code `200 OK` but an empty body.

It should look similat to the following example of the output:

```sh
HTTP/2 200
server: nginx/1.15.0
date: Tue, 01 Dec 2020 15:01:22 GMT
content-length: 0
cache-control: private
set-cookie: 93b1d08256cbf837e3463c0bba903028=0e558f788ca3bde0c6204c8d9bc783e0; Path=/; HttpOnly; Secure; SameSite=None
via: 1.1 google
alt-svc: clear
```

### Producing messages

The Kafka cluster we are working with has topic autocreation enabled, so we can start immediately to send messages through the `/topics/my-topic` endpoint exposed by the HTTP bridge.

The bridge exposes two main REST endpoints in order to send messages:

* /topics/{topicname}
* /topics/{topicname}/partitions/{partitionid}

The first one is used to send a message to a topic `topicname` while the second one allows the user to specify the partition via `partitionid`. Actually, even using the first endpoint the user can specify the destination partition in the body of the message.

The HTTP request payload is always a JSON but the message values can be JSON or binary (encoded in base64 because you are sending binary data in a JSON payload so encoding in a string format is needed).

When performing producer operations, `POST` requests must provide `Content-Type` headers specifying the desired _embedded data format_, either `json` or `binary`. In this scenario we will be using the **json** format.

Let's send a couple of messages to the `my-topic` topic:

``curl -s -k -X POST https://my-bridge-bridge-service-kafka.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/topics/my-topic -H 'content-type: application/vnd.kafka.json.v2+json' -d '{ "records": [ {"key": "key-1","value": "sales-lead-0001"}, {"key": "key-2","value": "sales-lead-0002"} ] }' | jq``{{execute}}

If the request is successful, the Kafka Bridge returns an `200 OK` with a JSON paylod describing the `offsets` array in which partition and at which offset the messages are written.

In this case, the auto-created topic has just one partition, so the response will look something like this:

```json
{
   "offsets":[
      {
         "partition":0,
         "offset":0
      },
      {
         "partition":0,
         "offset":1
      }
   ]
}
```

Excellent! You have send your first messages to your Kafka topic through the HTTP Bridge. Now you are set to start consuming those messages.
