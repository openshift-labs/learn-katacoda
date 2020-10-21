## Setup the Minio generic object datastore

Lets start Minio, it provide a S3 compatible protocol for storing the objects.
To create the minio backend, just apply the provided file:

``oc apply -f minio/minio.yaml``{{execute}}

And now, you have a working generic object datastore.


## Setup the SFTP Server for the file store

Run the following script to start up the SFTP Server in the system:

``bash sftp/sftp.sh``{{execute}}

If everything goes as planned, you should see the following message:
```
clusterrole.rbac.authorization.k8s.io/system:openshift:scc:anyuid added: "default"
--> Found container image d87b9ff (10 hours old) from Docker Hub for "atmoz/sftp"

    * An image stream tag will be created as "ftpserver:latest" that will track this image
    * This image will be deployed in deployment config "ftpserver"
    * Port 22/tcp will be load balanced by service "ftpserver"
      * Other containers can access this service through the hostname "ftpserver"
    * WARNING: Image "atmoz/sftp" runs as the 'root' user which may not be permitted by your cluster administrator

--> Creating resources ...
    imagestream.image.openshift.io "ftpserver" created
    deploymentconfig.apps.openshift.io "ftpserver" created
    service "ftpserver" created
--> Success
    Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
     'oc expose service/ftpserver'
    Run 'oc status' to view your app.
secret/ftp-users created
secret/sftp-ssh-key created
info: Generated volume name: volume-dpt6b
deploymentconfig.apps.openshift.io/ftpserver volume updated
info: Generated volume name: volume-mrld4
deploymentconfig.apps.openshift.io/ftpserver volume updated
```

Take note at the secret/sftp-ssh-key, we will be using this secret for configuring our sink connector.

``oc get secret/sftp-ssh-key``{{execute}}

Waiting until the _RUNNING_ status

``oc get pod -w | grep ftpserver``{{execute}}

Hit Ctrl+C to exit the mode.

Take a look at the folder, and it should be empty at the moment. This is where we want our file files to be at.

``oc exec -i `oc get pod -l deploymentconfig=ftpserver -o=jsonpath='{.items[0].metadata.name}'` -- ls /home/foo/upload/``{{execute}}


## Setup Source2Image

For the Kafka Connect image, we will need the connector libraries to run.
Source2Image will be used to setup and build the connectors.Go to the text editor on the right, under the folder /root/camel-kafka. Right click on the directory and choose New -> File and name it `kafka-connect-s2i.yaml`.

Paste the following code into the application.

<pre class="file" data-filename="kafka-connect-s2i.yaml" data-target="replace">
apiVersion: kafka.strimzi.io/v1beta1
kind: KafkaConnectS2I
metadata:
 name: my-connect-cluster
spec:
  bootstrapServers: 'my-cluster-kafka-bootstrap:9093'
  config:
    config.storage.replication.factor: 1
    config.storage.topic: connect-cluster-configs
    group.id: connect-cluster
    offset.storage.replication.factor: 1
    offset.storage.topic: connect-cluster-offsets
    status.storage.replication.factor: 1
    status.storage.topic: connect-cluster-status
  externalConfiguration:
    volumes:
      - name: sftp-ssh-key
        secret:
          secretName: sftp-ssh-key
  replicas: 1
  tls:
    trustedCertificates:
      - certificate: ca.crt
        secretName: my-cluster-cluster-ca-cert
  version: 2.5.0
</pre>

Notice here it connects to the Kafka cluster that we initiated in the previous step, and also points to the secret in the SFTP server (we will need this later) as an external configuration. Go ahead execute the command to setup the KafkaConnect Source2Image.

``oc apply -f camel-kafka/kafka-connect-s2i.yaml``{{execute}}


Enable Kafka Connectors to be able to instantiated via custom resource:
``oc annotate kafkaconnects2is my-connect-cluster strimzi.io/use-connector-resources=true``{{execute}}
