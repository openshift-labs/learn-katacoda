
## Add and build the Camel Kafka Connector binary to the connector

Take a look at the plugin folder, you will find two folders named

``ls ./plugin/``{{execute}}

- camel-minio-kafka-connector
- camel-sftp-kafka-connector

They are the libraries needed for the connectors. Now let's use Source2Image to add these connectors libraries to the existing images. We now need to build the connectors and add them to the image.

``oc start-build my-connect-cluster-connect --from-dir=./plugin/ --follow``{{execute}}


Wait for the rollout of the new image to finish and the replica set with the new connector to become ready. Once it is done, we can check that the connectors are available in our Kafka Connect cluster. Since AMQ Streams is running Kafka Connect in a distributed mode. We will use HTTP to interact with it. To check the available connector plugins, you can run the following command:

``oc exec -i `oc get pods --field-selector status.phase=Running -l strimzi.io/name=my-connect-cluster-connect -o=jsonpath='{.items[0].metadata.name}'` -- curl -s http://my-connect-cluster-connect-api:8083/connector-plugins``{{execute}}


You will find the two connectors that we are have added in the image.

```
[
   ........
   {
      "class":"org.apache.camel.kafkaconnector.minio.CamelMinioSinkConnector",
      "type":"sink",
      "version":"0.5.0"
   },
   {
      "class":"org.apache.camel.kafkaconnector.minio.CamelMinioSourceConnector",
      "type":"source",
      "version":"0.5.0"
   },
   {
      "class":"org.apache.camel.kafkaconnector.sftp.CamelSftpSinkConnector",
      "type":"sink",
      "version":"0.6.0-SNAPSHOT"
   },
   {
      "class":"org.apache.camel.kafkaconnector.sftp.CamelSftpSourceConnector",
      "type":"source",
      "version":"0.6.0-SNAPSHOT"
   }
   .........
]
```

## Create Source Connector Instance

Now we can create an instance connector that reads files from the AWS S3 liked object store (Minio). Go to the text editor on the right, under the folder /root/camel-kafka. Right click on the directory and choose New -> File and name it `minio-connector.yaml`.

Paste the following code into the application.

<pre class="file" data-filename="minio-connector.yaml" data-target="replace">
apiVersion: kafka.strimzi.io/v1alpha1
kind: KafkaConnector
metadata:
  name: minio-source-connector
  labels:
    strimzi.io/cluster: my-connect-cluster
spec:
  class: org.apache.camel.kafkaconnector.minio.CamelMinioSourceConnector
  tasksMax: 1
  config:
    key.converter: org.apache.kafka.connect.storage.StringConverter
    value.converter: org.apache.kafka.connect.storage.StringConverter
    topics: demo-topic
    camel.source.path.bucketName: camel-kafka
    camel.source.endpoint.initialDelay: 20000
    camel.source.endpoint.endpoint: http://minio:9000
    camel.component.minio.accessKey: minio
    camel.component.minio.secretKey: minio123
    camel.component.minio.operation: getObject
</pre>

This points the connector to listen to the camel-kafka in the Minio object store, when detected content from the Minio source, the connector will capture it and place it in the Kafka topic _*demo-topic*_ and ready to be subscribed by the consumers. Execute following command to create the source connector.

``oc create -f camel-kafka/minio-connector.yaml``{{execute}}

Now, let's go ahead and place a file in the object store. This is going to copy the healthcare related files that we have prepared into the object store.

``oc rsync ./file/ `oc get pod -l app=minio -o=jsonpath='{.items[0].metadata.name}'`:/data/camel-kafka``{{execute}}

Note the name of the two files.

```
WARNING: cannot use rsync: rsync not available in container
sample01.json
```

You will find the file in the Kafka Topic _*demo-topic*_

``oc exec -i `oc get pods --field-selector status.phase=Running -l strimzi.io/name=my-connect-cluster-connect -o=jsonpath='{.items[0].metadata.name}'` -- bin/kafka-console-consumer.sh --topic demo-topic --from-beginning --bootstrap-server my-cluster-kafka-bootstrap:9092``{{execute}}


With content starting like following:

```
OpenJDK 64-Bit Server VM warning: If the number of processors is expected to increase from one, then you should configure the number of parallel GC threads appropriately using -XX:ParallelGCThreads=N
{
  "resourceType": "Observation",
  "id": "ekg",
  "text": {
    "status": "generated",
    "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative with Details</b></p><p><b>id</b>: ekg</p><p><b>status</b>: final</p><p><b>category</b>: Procedure <span>(Details : {http://terminology.hl7.org/CodeSystem/observation-category code 'procedure' = 'Procedure', given as 'Procedure'})</span></p><p><b>code</b>: MDC_ECG_ELEC_POTL <span>(Details : {urn:oid:2.16.840.1.113883.6.24 code '131328' = '131328', given as 'MDC_ECG_ELEC_POTL'})</span></p><p><b>subject</b>: <a>P. van de Heuvel</a></p><p><b>effective</b>: 19/02/2015 9:30:35 AM</p><p><b>performer</b>: <a>A. Langeveld</a></p><p><b>device</b>: 12 lead EKG Device Metric</p><blockquote><p><b>component</b></p><p><b>code</b>: MDC_ECG_ELEC_POTL_I <span>(Details : {urn:oid:2.16.840.1.113883.6.24 code '131329' = '131329', given as 'MDC_ECG_ELEC_POTL_I'})</span></p><p><b>value</b>: Origin: (system = '[not stated]' code null = 'null'), Period: 10, Factor: 1.612, Lower: -3300, Upper: 3300, Dimensions: 1, Data: 2041 2043 2037 2047 2060 2062 2051 2023 2014 2027 2034 2033 2040 2047 2047 2053 2058 2064 2059 2063 2061 2052 2053 2038 1966 1885 1884 2009 2129 2166 2137 2102 2086 2077 2067 2067 2060 2059 2062 2062 2060 2057 2045 2047 2057 2054 2042 2029 2027 2018 2007 1995 2001 2012 2024 2039 2068 2092 2111 2125 2131 2148 2137 2138 2128 2128 2115 2099 2097 2096 2101 2101 2091 2073 2076 2077 2084 2081 2088 2092 2070 2069 2074 2077 2075 2068 2064 2060 2062 2074 2075 2074 2075 2063 2058 2058 2064 2064 2070 2074 2067 2060 2062 2063 2061 2059 2048 2052 2049 2048 2051 2059 2059 2066 2077 2073</p></blockquote><blockquote><p><b>component</b></p><p><b>code</b>: MDC_ECG_ELEC_POTL_II <span>(Details : {urn:oid:2.16.840.1.113883.6.24 code '131330' = '131330', given as 'MDC_ECG_ELEC_POTL_II'})</span></p><p><b>value</b>: Origin: (system = '[not stated]' code null = 'null'), Period: 10, Factor: 1.612, Lower: -3300, Upper: 3300, Dimensions: 1, Data: 2041 2043 2037 2047 2060 2062 2051 2023 2014 2027 2034 2033 2040 2047 2047 2053 2058 2064 2059 2063 2061 2052 2053 2038 1966 1885 1884 2009 2129 2166 2137 2102 2086 2077 2067 2067 2060 2059 2062 2062 2060 2057 2045 2047 2057 2054 2042 2029 2027 2018 2007 1995 2001 2012 2024 2039 2068 2092 2111 2125 2131 2148 2137 2138 2128 2128 2115 2099 2097 2096 2101 2101 2091 2073 2076 2077 2084 2081 2088 2092 2070 2069 2074 2077 2075 2068 2064 2060 2062 2074 2075 2074 2075 2063 2058 2058 2064 2064 2070 2074 2067 2060 2062 2063 2061 2059 2048 2052 2049 2048 2051 2059 2059 2066 2077 2073</p></blockquote><blockquote><p><b>component</b></p><p><b>code</b>: MDC_ECG_ELEC_POTL_III <span>(Details : {urn:oid:2.16.840.1.113883.6.24 code '131389' = '131389', given as 'MDC_ECG_ELEC_POTL_III'})</span></p><p><b>value</b>: Origin: (system = '[not stated]' code null = 'null'), Period: 10, Factor: 1.612, Lower: -3300, Upper: 3300, Dimensions: 1, Data: 2041 2043 2037 2047 2060 2062 2051 2023 2014 2027 2034 2033 2040 2047 2047 2053 2058 2064 2059 2063 2061 2052 2053 2038 1966 1885 1884 2009 2129 2166 2137 2102 2086 2077 2067 2067 2060 2059 2062 2062 2060 2057 2045 2047 2057 2054 2042 2029 2027 2018 2007 1995 2001 2012 2024 2039 2068 2092 2111 2125 2131 2148 2137 2138 2128 2128 2115 2099 2097 2096 2101 2101 2091 2073 2076 2077 2084 2081 2088 2092 2070 2069 2074 2077 2075 2068 2064 2060 2062 2074 2075 2074 2075 2063 2058 2058 2064 2064 2070 2074 2067 2060 2062 2063 2061 2059 2048 2052 2049 2048 2051 2059 2059 2066 2077 2073</p></blockquote></div>"
  },
  "status": "final",
  "category": [
    {
      "coding": [
        {
   ............
```
