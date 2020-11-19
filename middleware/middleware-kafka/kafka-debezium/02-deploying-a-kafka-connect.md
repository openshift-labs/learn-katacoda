After setting up a Kafka cluster, you deploy Kafka Connect in a custom container image for Debezium. This service provides a framework for managing the Debezium MySQL connector.

You can create a custom container image by downloading the Debezium MySQL connector archive from the [Red Hat Integration](https://access.redhat.com/jbossnetwork/restricted/listSoftware.html?product=red.hat.integration&downloadType=distributions) download site and extracting to create the directory structure for the connector plug-in.

Then you can create and publish a custom Linux container image using `docker build` or `podman build` from a custom Dockerfile.

> However, to save some time, we have already created and image for you. You can check the [documentation](https://access.redhat.com/documentation/en-us/red_hat_integration/2020-q3/html-single/getting_started_with_debezium/index#deploying-kafka-connect) in detail for more information.

To deploy the Kafka Connect cluster with the custom image execute the following command:

``oc -n debezium apply -f /root/projects/debezium/kafka-connect.yaml``{{execute interrupt}}

The Kafka Connect node should be deployed after a few moments. To watch the pods status run the following command:

``oc get pods -w -l app=strimzi-connect``{{execute}}

You will see the pods changing the status to `running`. It should look similar to the following:

    NAME                                 READY     STATUS        RESTARTS   AGE
    my-connect-cluster-connect-1-wktnt   0/1       Terminating   0          50s
    my-connect-cluster-connect-2-lqqht   0/1       Running       0          26s

**3. Verify that Connect is up and contains Debezium**

Wait till the Connect node is ready

    NAME                                 READY     STATUS    RESTARTS   AGE
    my-connect-cluster-connect-2-lpnd2   1/1       Running   0          1m

and list all plug-ins available for use.

``oc exec -c kafka my-cluster-kafka-0 -- curl -s http://my-connect-cluster-connect-api:8083/connector-plugins``{{execute}}

    [
        {"class":"io.debezium.connector.mysql.MySqlConnector","type":"source","version":"0.10.0.Final"},
        {"class":"org.apache.kafka.connect.file.FileStreamSinkConnector","type":"sink","version":"2.3.0"},
        {"class":"org.apache.kafka.connect.file.FileStreamSourceConnector","type":"source","version":"2.3.0"}
    ]

The Connect node has the Debezium `MySqlConnector` connector plugin available.

## Congratulations

You have now successfully executed the second step in this scenario. 

You have successfully deployed Kafka Connect node and configured it to contain Debezium.

In next step of this scenario we will finish deployment by creating a connection between database source and Kafka Connect.
