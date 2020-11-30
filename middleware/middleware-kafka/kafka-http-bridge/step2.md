In order to verify that the Ingress is working properly, try to hit the /healthy endpoint of the bridge with the following curl command:

``curl -v GET https://my-bridge-bridge-service-kafka.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/healthy``{{execute interrupt}}

If the bridge is reachable through the OpenShift route, it will return an HTTP response with status code `200 OK` but an empty body. 

It should look similat to the following example of the output:

```sh
*   Trying 35.201.124.219...
* TCP_NODELAY set
* Connected to my-bridge-bridge-service-kafka.2886795276-80-kota02.environments.katacoda.com (35.201.124.219) port 80 (#0)
> GET /healthy HTTP/1.1> Host: my-bridge-bridge-service-kafka.2886795276-80-kota02.environments.katacoda.com
> User-Agent: curl/7.61.1
> Accept: */*
>
< HTTP/1.1 200 OK
< Server: nginx/1.15.0
< Date: Wed, 25 Nov 2020 20:38:54 GMT
< Content-Length: 0
< Cache-Control: private
< Set-Cookie: 93b1d08256cbf837e3463c0bba903028=9460d6ac7471246f5fed015cbe95a63b; Path=/; HttpOnly; Secure; SameSite=None
< Via: 1.1 google
<
* Connection #0 to host my-bridge-bridge-service-kafka.2886795276-80-kota02.environments.katacoda.com left intact
```

### Producing messages

The Kafka cluster we are working with has topic autocreation enabled, so we can start immediately to send messages through the `/topics/example` endpoint exposed by the HTTP bridge.

The bridge exposes two main REST endpoints in order to send messages:

* /topics/{topicname}
* /topics/{topicname}/partitions/{partitionid}

The first one is used to send a message to a topic topicname while the second one allows the user to specify the partition via partitionid. Actually, even using the first endpoint the user can specify the destination partition in the body of the message.

The HTTP request payload is always a JSON but the message values can be JSON or binary (encoded in base64 because you are sending binary data in a JSON payload so encoding in a string format is needed).
