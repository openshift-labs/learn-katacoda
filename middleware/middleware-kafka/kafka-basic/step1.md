Red Hat AMQ Streams simplifies the process of running Apache Kafka in an OpenShift cluster. This tutorial provides instructions for deploying a working environment of AMQ Streams.

### Logging in to the Cluster via OpenShift CLI

Before creating any applications, login as admin. This is required if you want to log in to the web console and use it.

To log in to the OpenShift cluster from the _Terminal_ run:

``oc login -u admin -p admin``{{execute}}

This will log you in using the credentials:

* **Username:** ``admin``
* **Password:** ``admin``

Use the same credentials to log into the web console.

### Creating your own namespace

To create a new (project) namespace called ``kafka`` for the AMQ Streams Kafka Cluster Operator run the command:

``oc new-project kafka``{{execute}}

### Install AMQ Streams Operators

AMQ Streams provides container images and Operators for running Kafka on OpenShift. AMQ Streams Operators are fundamental to the running of AMQ Streams. The Operators provided with AMQ Streams are purpose-built with specialist operational knowledge to effectively manage Kafka.

Deploy the Operator Lifecycle Manager Operator Group and Susbcription to install the Operator in the previously created namespace:

``oc -n kafka apply -f /opt/operator-install.yaml``{{execute}}

You will see the following result:

```bash
operatorgroup.operators.coreos.com/streams-operatorgroup created
subscription.operators.coreos.com/amq-streams created
```

> You can also deploy the AMQ streams Operator from the OpenShift OperatorHub from within the OpenShift administration console.

### Check the Operator deployment

Check the Operator deployment is running.

To watch the status of the pods run the following command:

``oc -n kafka get pods -w``{{execute}}

You will see the status of the pod for the Cluster Operator changing to `Running`:

```bash
NAME                                                   READY   STATUS              RESTARTS   AGE
amq-streams-cluster-operator-v1.5.3-59666d98cb-8ptlz   0/1     ContainerCreating   0          10s
amq-streams-cluster-operator-v1.5.3-59666d98cb-8ptlz   0/1     Running             0          18s
amq-streams-cluster-operator-v1.5.3-59666d98cb-8ptlz   1/1     Running             0          34s
```

Press <kbd>Ctrl</kbd>+<kbd>C</kbd> to stop the process.

`^C`{{execute ctrl-seq}}
