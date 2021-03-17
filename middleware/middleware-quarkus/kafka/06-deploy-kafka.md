# Deploying Kafka to OpenShift

To deploy Kafka to OpenShift, you'll need to login.

You should already be logged in as an admin user. Click this command to verify:

`oc whoami`{{execute T2}}

It should respond with `admin`.

## Access OpenShift Project

[Projects](https://docs.openshift.com/container-platform/3.6/architecture/core_concepts/projects_and_users.html#projects)
are a top level concept to help you organize your deployments. An
OpenShift project allows a community of users (or a user) to organize and manage
their content in isolation from other communities.

For this scenario, let's create a project that you will use to house Kafka. Click:

`oc new-project kafka --display-name="Apache Kafka"`{{execute T2}}

## Deploy Kafka Operator

To deploy Kafka, we'll use the _Strimzi_ Operator. Strimzi is an open source project that provides an easy way to run an Apache Kafka cluster on Kubernetes in various deployment configurations.

First, click this command to deploy the Operator to our new `kafka` namespace:

`oc create -f 'https://strimzi.io/install/latest?namespace=kafka' -n kafka`{{execute T2}}

Wait for the Operator to be deployed by running this command:

`oc rollout status -w deployment/strimzi-cluster-operator`{{execute T2}}

> If this command seems to be taking a long time, just CTRL-C it and run it again. It make take time to install Kafka depending on system load.

You should eventually see:

```console
deployment "strimzi-cluster-operator" successfully rolled out
```

## Deploy Kafka Cluster

Before deploying the Kafka cluster, make sure you are on the project folder _projects/rhoar-getting-started/quarkus/kafka/_ by executing this command:

`cd /root/projects/rhoar-getting-started/quarkus/kafka`{{execute T2}}

Next, create a new `Kafka` object within Kubernetes that the operator is waiting for. Click this command to create it:

`oc apply -f src/main/kubernetes/kafka-names-cluster.yaml`{{execute T2}}

This command creates a simple Kafka object:

```yaml
apiVersion: kafka.strimzi.io/v1beta1
kind: Kafka
metadata:
  name: names-cluster
spec:
  kafka:
    replicas: 3
    listeners:
      ...
    config:
      ...
    storage:
      type: ephemeral
  zookeeper:
    ...
```

## Deploy Kafka Topic

We’ll need to create a _topic_ for our application to stream to and from. To do so, click the following command to create the _topic_ object:

`oc apply -f src/main/kubernetes/kafka-names-topic.yaml`{{execute T2}}

This creates our `names` topic that our code and Quarkus configuration references.

## Confirm deployment

Look at the list of pods being spun up and look for the Kafka pods for our cluster:

`oc get pods|grep names-cluster`{{execute T2}}

You should see something like:

``` none
names-cluster-entity-operator-6cbfffc465-jthb7   3/3     Running   0          45s
names-cluster-kafka-0                            1/1     Running   0          99s
names-cluster-kafka-1                            1/1     Running   0          99s
names-cluster-kafka-2                            1/1     Running   0          99s
names-cluster-zookeeper-0                        1/1     Running   0          2m31s
names-cluster-zookeeper-1                        1/1     Running   0          2m31s
names-cluster-zookeeper-2                        1/1     Running   0          2m31s
```
If the pods are still spinning up (not all in the _Running_ state with `1/1` or `3/3` containers running), keep clicking the above command until you see 3 _kafka_ pods, 3 _zookeeper_ pods, and the single _entity operator_ pod.

It will take around 2 minutes to get all the Kafka pods up and running.

