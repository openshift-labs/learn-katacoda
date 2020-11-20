After setting up a Kafka cluster, you deploy Kafka Connect in a custom container image for Debezium. This service provides a framework for managing the Debezium MySQL connector.

You can create a custom container image by downloading the Debezium MySQL connector archive from the [Red Hat Integration](https://access.redhat.com/jbossnetwork/restricted/listSoftware.html?product=red.hat.integration&downloadType=distributions) download site and extracting to create the directory structure for the connector plug-in.

Then you can create and publish a custom Linux container image using `docker build` or `podman build` from a custom Dockerfile.

> However, to save some time, we have already created and image for you. You can check the [documentation](https://access.redhat.com/documentation/en-us/red_hat_integration/2020-q3/html-single/getting_started_with_debezium/index#deploying-kafka-connect) in detail for more information.

To deploy the Kafka Connect cluster with the custom image execute the following command:

``oc -n debezium apply -f /root/projects/debezium/kafka-connect.yaml``{{execute interrupt}}

The Kafka Connect node should be deployed after a few moments. To watch the pods status run the following command:

``oc get pods -w -l app.kubernetes.io/name=kafka-connect``{{execute}}

You will see the pods changing the status to `running`. It should look similar to the following:

```bash
NAME                                READY   STATUS              RESTARTS   AGE
debezium-connect-6fc5b7f97d-g4h2l   0/1     ContainerCreating   0          3s
debezium-connect-6fc5b7f97d-g4h2l   0/1     ContainerCreating   0          9s
debezium-connect-6fc5b7f97d-g4h2l   0/1     Running             0          25s
debezium-connect-6fc5b7f97d-g4h2l   1/1     Running             0          90s
```

> This step might take a couple minutes.

Hit <kbd>Ctrl</kbd>+<kbd>C</kbd> to stop the process.

`^C`{{execute ctrl-seq}}

## Verify that Connect is up and contains Debezium

When the Connect node is up and running, we can verify the plugins available. AMQ streams allows us to manage most of the Kafka ecosystem components as Kubernetes custom resources. Hence, the information regarding Kafka Connect, is now available as part of the `status` section of the KafkaConnect resource.

List all plug-ins available for use.

``oc get kafkaconnect/debezium -o json | jq .status.connectorPlugins``{{execute interrupt}}

You should see an output similar to the following:

```json
[
  {
    "class": "io.debezium.connector.db2.Db2Connector",
    "type": "source",
    "version": "1.2.4.Final-redhat-00001"
  },
  {
    "class": "io.debezium.connector.mongodb.MongoDbConnector",
    "type": "source",
    "version": "1.2.4.Final-redhat-00001"
  },
  {
    "class": "io.debezium.connector.mysql.MySqlConnector",
    "type": "source",
    "version": "1.2.4.Final-redhat-00001"
  },
  {
    "class": "io.debezium.connector.postgresql.PostgresConnector",
    "type": "source",
    "version": "1.2.4.Final-redhat-00001"
  },
  {
    "class": "io.debezium.connector.sqlserver.SqlServerConnector",
    "type": "source",
    "version": "1.2.4.Final-redhat-00001"
  }
  ...
]
```

> Note: Output formatted for the sake of readability

The Connect node has the Debezium `MySqlConnector` connector plugin available.

You have successfully deployed Kafka Connect node and configured it to contain Debezium.

In next step of this scenario we will finish deployment by creating a connection between database source and Kafka Connect.
