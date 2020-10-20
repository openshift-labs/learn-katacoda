## Create Sink Connector Instance
Finally, we need to read the file from the Kafka Topic, rename it into something our system understand and place it into the SFTP server.
We need an instance of Camel Kafka connector that move files from the updated topic to sink -- SFTP server. Go to the text editor on the right, under the folder /root/camel-kafka. Right click on the directory and choose New -> File and name it `sftp-connector.yaml`.

Paste the following code into the application.

<pre class="file" data-filename="minio-connector.yaml" data-target="replace">
apiVersion: kafka.strimzi.io/v1alpha1
kind: KafkaConnector
metadata:
  name: sftp-source-connector
  labels:
    strimzi.io/cluster: my-connect-cluster
spec:
  class: org.apache.camel.kafkaconnector.sftp.CamelSftpSinkConnector
  tasksMax: 1
  config:
    key.converter: org.apache.kafka.connect.storage.StringConverter
    value.converter: org.apache.kafka.connect.storage.StringConverter
    topics: demo-topic
    camel.sink.path.host: ftpserver
    camel.sink.path.port: 22
    camel.sink.path.directoryName: upload
    camel.sink.endpoint.fileName: ${date:now:yyyyMMddhhmmss}.json
    camel.sink.endpoint.username: foo
    camel.sink.endpoint.password: pass
    camel.sink.endpoint.useUserKnownHostsFile: false
    camel.sink.endpoint.privateKeyFile: /opt/kafka/external-configuration/sftp-ssh-key/demo_rsa
</pre>

This points the connector to the Kafka topic _*demo-topic*_ and write the incoming event data into the SFTP server under the upload folder as configured, with the name of the file changed to the yyyyMMddhhmmss format. Also points to the keyfile that we have configured earlier in the secrets.

Run command to create the sink connector.
``oc create -f camel-kafka/sftp-connector.yaml``{{execute}}

Check if the file appears in the SFTP server.
``oc exec -i ftpserver-2-g2rxb -- ls /home/foo/upload/``{{execute}}

## Congratulations

In this scenario you got to play with Camel Kafka Connector. You have initiated an AMQ Streams (Kafka) cluster on Openshift, created an object store, sftp server. Then started a Kafka Connect with your own build of image including the libraries needed. Then you created a source Camel Kafka connector that loads
