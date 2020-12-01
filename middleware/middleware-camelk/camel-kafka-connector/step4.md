## Create Sink Connector Instance
Finally, we need to read the file from the Kafka Topic, rename it into something our system understand and place it into the SFTP server.
We need an instance of Camel Kafka connector that move files from the updated topic to sink -- SFTP server. Go to the text editor on the right, under the folder /root/camel-kafka. Right click on the directory and choose New -> File and name it `sftp-connector.yaml`.

Paste the following code into the application.

<pre class="file" data-filename="sftp-connector.yaml" data-target="replace">
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

``oc exec -i `oc get pod -l deploymentconfig=ftpserver -o=jsonpath='{.items[0].metadata.name}'` -- ls /home/foo/upload/``{{execute}}

You should be seeing the same file that was updloaded!
``oc exec -i `oc get pod -l deploymentconfig=ftpserver -o=jsonpath='{.items[0].metadata.name}'` -- find /home/foo/upload/ -type f -exec cat {} \;``{{execute}}


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

![overview](/openshift/assets/middleware/middleware-camelk/camel-kafka-connector/camel-kafka-step01-overview.png)

## Congratulations

In this scenario you got to play with Camel Kafka Connector. You have initiated an AMQ Streams (Kafka) cluster on openshift, created an object store, sftp server. Then started a Kafka Connect with your own build of image including the libraries needed. Then you created a source Camel Kafka connector that loads files from the _AWS2 S3_ like storage, place the file in the kafka topic, and created another Camel Kafka connector that listens to the input from the kafka topic and place the file in the SFTP server.
