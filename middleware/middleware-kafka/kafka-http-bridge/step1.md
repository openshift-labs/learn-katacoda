
Deploying the bridge on OpenShift is really easy using the new KafkaBridge custom resource provided by the Red Hat AMQ Streams Cluster Operator.

### Logging in to the Cluster via OpenShift CLI

Before creating any applications, login as admin. This will be required if you want to log in to the web console and use it.

To login to the OpenShift cluster from the _Terminal_ run:

``oc login -u developer -p developer``{{execute}}

This will log you in using the credentials:

* **Username:** ``developer``
* **Password:** ``developer``

Use the same credentials to log into the web console.

### Creating your own namespace

To change to the (project) namespace called ``kafka`` where AMQ Streams Kafka Cluster Operator manages the Kafka resources, run the following command:

``oc project kafka``{{execute}}
