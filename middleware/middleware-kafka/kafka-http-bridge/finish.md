In this quickstart, you have used the AMQ Streams Kafka Bridge to perform several common operations on a Kafka cluster.

Exposing the Apache Kafka cluster to clients using HTTP enables scenarios where use of the native clients is not desirable. Such situations include resource constrained devices, network availability and security considerations. Interaction with the bridge is similar to the native Apache Kafka clients but using the semantics of an HTTP REST API.

The general availability of the HTTP Bridge in Red Hat Integration enhances the options available to developers when building applications with Apache Kafka.

## Additional Resources

To learn more about and getting started:

* [Red Hat AMQ](https://www.redhat.com/en/technologies/jboss-middleware/amq)
* [Red Hat Developer's Site](http://developers.redhat.com/products/amq)
* [POST /consumers/{groupid}/instances/{name}/positions](https://strimzi.io/docs/bridge/latest/#_seek) in the API reference documentation.
* [POST /consumers/{groupid}/instances/{name}/positions/beginning](https://strimzi.io/docs/bridge/latest/#_seektobeginning) in the API reference documentation.
* [POST /consumers/{groupid}/instances/{name}/positions/end](https://strimzi.io/docs/bridge/latest/#_seektoend) in the API reference documentation.
