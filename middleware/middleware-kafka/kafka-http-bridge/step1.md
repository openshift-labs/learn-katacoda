
Deploying the bridge on OpenShift is really easy using the new `KafkaBridge` custom resource provided by the Red Hat AMQ Streams Cluster Operator.

### Logging in to the Cluster using the OpenShift CLI

Before creating any applications, log in as admin. This is required if you want to log in to the web console and use it.

To log in to the OpenShift cluster from the _Terminal_ run:

``oc login -u developer -p developer``{{execute}}

This will log you in using the credentials:

* **Username:** ``developer``
* **Password:** ``developer``

Use the same credentials to log in to the web console.

### Switch your own namespace

Switch to the (project) namespace called ``kafka`` where the Cluster Operator manages the Kafka resources:

``oc project kafka``{{execute}}

### Deploying Kafka Bridge to your OpenShift cluster

The deployment uses a YAML file to provide the specification to create a `KafkaBridge` resource.

Click the link below to open the custom resource (CR) definition for the bridge:

* `kafka-bridge.yaml`{{open}}

The bridge has to connect to the Apache Kafka cluster. This is specified in the `bootstrapServers` property. The bridge then uses a native Apache Kafka consumer and producer for interacting with the cluster.

>For information about configuring the KafkaBridge resource, see [Kafka Bridge configuration](https://access.redhat.com/documentation/en-us/red_hat_amq/2020.q4/html-single/using_amq_streams_on_openshift/index#assembly-config-kafka-bridge-str).

Deploy the Kafka Bridge with the custom image:

``oc -n kafka apply -f /root/projects/http-bridge/kafka-bridge.yaml``{{execute interrupt}}

The Kafka Bridge node should be deployed after a few moments. To watch the pods status run the following command:

``oc get pods -w -l app.kubernetes.io/name=kafka-bridge``{{execute}}

You will see the pods changing the status to `running`. It should look similar to the following:

```bash
NAME                                READY   STATUS              RESTARTS   AGE
my-bridge-bridge-6b6d9f785c-dp6nk   0/1     ContainerCreating   0          5s
my-bridge-bridge-6b6d9f785c-dp6nk   0/1     ContainerCreating   0          12s
my-bridge-bridge-6b6d9f785c-dp6nk   0/1     Running             0          27s
my-bridge-bridge-6b6d9f785c-dp6nk   1/1     Running             0          45s
```

> This step might take a couple minutes.

Press <kbd>Ctrl</kbd>+<kbd>C</kbd> to stop the process.

`^C`{{execute ctrl-seq}}

### Creating an OpenShift route

After deployment, the Kafka Bridge can only be accessed by applications running in the same OpenShift cluster. If you want to make the Kafka Bridge accessible to applications running outside of the OpenShift cluster, you can expose it manually by using one of the following features:

* Services of types LoadBalancer or NodePort
* Kubernetes Ingress
* OpenShift Routes

An OpenShift `route` is an OpenShift resource for allowing external access through HTTP/HTTPS to internal services such as the Kafka bridge. We will use this approach for our example.

Run the following command to expose the bridge service as an OpenShift route:

``oc expose svc my-bridge-bridge-service``{{execute interrupt}}

When the route is created, the Kafka Bridge is reachable through the `https://my-bridge-bridge-service-kafka.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com` host. You can now use any HTTP client to interact with the REST API exposed by the bridge to send and receive messages without needing to use the native Kafka protocol.
