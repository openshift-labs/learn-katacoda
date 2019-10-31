# Deploying Kafka to OpenShift

To deploy Kafka to OpenShift, you'll need to login.

You should already be logged in as an admin user. Click this command to verify:

`oc whoami`{{execute T2}}

It should respond with `system:admin`.

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

`curl -s -L https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.13.0/strimzi-cluster-operator-0.13.0.yaml | sed 's/namespace: .*/namespace: kafka/' | oc apply -f -`{{execute T2}}

Wait for the Operator to be deployed by running this command:

`oc rollout status -w deployment/strimzi-cluster-operator`{{execute T2}}

You should see:

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
  name: my-cluster
spec:
  kafka:
    version: 2.3.0
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
names-cluster-entity-operator-7fb67dc54d-pxw6t   3/3     Running   0          20s
names-cluster-kafka-0                            2/2     Running   0          48s
names-cluster-kafka-1                            2/2     Running   0          48s
names-cluster-kafka-2                            2/2     Running   0          48s
names-cluster-zookeeper-0                        2/2     Running   0          1m
names-cluster-zookeeper-1                        2/2     Running   0          1m
names-cluster-zookeeper-2                        2/2     Running   0          1m
```
If the pods are still spinning up (not all in the _Running_ state), keep clicking the above command until you see 3 _kafka_ pods, 3 _zookeeper_ pods, and the single _entity operator_ pod.

It will take around 2 minutes to get all the Kafka pods up and running.

## Test Locally

With Kafka deployed, let's test our locally running app (it should still be running in the first Terminal).

We'll use `curl` to access the same streaming endpoint that our web page will eventually access. To access this endpoint, click on the following command:

`curl -i http://localhost:8080/names/stream`{{execute T2}}

This command will connect to the endpoint, recognize it as a streaming endpoint, and begin showing the names from our name generator, with the added honorific. You should see:

```console
HTTP/1.1 200 OK
Connection: keep-alive
Transfer-Encoding: chunked
Content-Type: text/event-stream
Date: Mon, 12 Aug 2019 18:50:28 GMT



data: Mrs. Zest Stealer

data: Sir Sunrise Kitten

data: Lord Mulberry Donkey
```
This shows the names coming from our SSE-enabled endpoint. After a few more names, press CTRL-C to end the stream. In the final step we'll deploy our Quarkus app to OpenShift and see these same names as part of a web page visualization. On with the show!
