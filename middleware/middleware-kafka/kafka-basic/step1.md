Red Hat AMQ Streams simplifies the process of running Apache Kafka in an OpenShift cluster. This tutorial provides instructions for deploying a working environment of AMQ Streams. 

## Logging in to the Cluster via OpenShift CLI

Before creating any applications, login as admin. This will be required if you want to log in to the web console and use it.

To login to the OpenShift cluster from the _Terminal_ run:

``oc login -u admin -p admin``{{execute}}

This will log you in using the credentials:

* **Username:** ``admin``
* **Password:** ``admin``

Use the same credentials to log into the web console.

## Creating your own namespace

To create a new (project) namespace called ``kafka`` for the AMQ Streams Kafka Cluster Operator run the command:

``oc new-project kafka``{{execute}}

## Install AMQ streams operator

AMQ Streams provides container images and Operators for running Kafka on OpenShift. AMQ Streams Operators are fundamental to the running of AMQ Streams. The Operators provided with AMQ Streams are purpose-built with specialist operational knowledge to effectively manage Kafka.

Deploy the Operator Lifecycle Manager Operator Group and Susbcription to easily install the operator in the previously created namespace:

``oc -n kafka apply -f /opt/operator-install.yaml``{{execute}}

You should see the following result:

```bash
operatorgroup.operators.coreos.com/streams-operatorgroup created
subscription.operators.coreos.com/amq-streams created
```

> You can also deploy the AMQ streams operator from the OpenShift OperatorHub from within the administration console.

## Check operator deployment

Follow up the operator deployment to validate it is running.

To watch the pods status run the following command:

``oc -n kafka get pods -w``{{execute}}

You will see the status of the operator changing until it gets to `running`. It should look similar to the following:

```bash
NAME                                                   READY   STATUS              RESTARTS   AGE
amq-streams-cluster-operator-v1.5.3-59666d98cb-8ptlz   0/1     ContainerCreating   0          10s
amq-streams-cluster-operator-v1.5.3-59666d98cb-8ptlz   0/1     Running             0          18s
amq-streams-cluster-operator-v1.5.3-59666d98cb-8ptlz   1/1     Running             0          34s
```

Hit <kbd>Ctrl</kbd>+<kbd>C</kbd> to stop the process.

`^C`{{execute ctrl-seq}}
