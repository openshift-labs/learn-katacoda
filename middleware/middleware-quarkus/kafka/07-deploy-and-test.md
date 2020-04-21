## Install OpenShift extension

Quarkus offers the ability to automatically generate OpenShift resources based on sane default and user supplied configuration. The OpenShift extension is actually a wrapper extension that brings together the [kubernetes](https://quarkus.io/guides/deploying-to-kubernetes) and [container-image-s2i](https://quarkus.io/guides/container-image#s2i) extensions with sensible defaults so that it’s easier for the user to get started with Quarkus on OpenShift.

Run the following command to add it to our project:

`mvn quarkus:add-extension -Dextensions="openshift"`{{execute T2}}

## Create project

Create a new project into which we'll deploy the app:

`oc new-project quarkus-kafka --display-name="Quarkus on Kafka"`{{execute T2}}

## Deploy application to OpenShift

Now let's deploy the application itself. Run the following command which will build and deploy using the OpenShift extension:

`mvn clean package -Dquarkus.kubernetes-client.trust-certs=true -Dquarkus.container-image.build=true -Dquarkus.kubernetes.deploy=true -Dquarkus.kubernetes.deployment-target=openshift -Dquarkus.openshift.expose=true -Dquarkus.openshift.labels.app.openshift.io/runtime=java`{{execute T2}}

The output should end with `BUILD SUCCESS`.

Finally, make sure it's actually done rolling out:

`oc rollout status -w dc/people`{{execute T2}}

Wait for that command to report `replication controller "people-1" successfully rolled out` before continuing.

And now we can access using `curl` once again to confirm the app is up:

`curl http://people-quarkus-kafka.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/hello`{{execute T2}}

So now our app is deployed to OpenShift. Finally, let's confirm our streaming Kafka app is working.

[Open up the web UI](http://people-quarkus-kafka.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com). You should see a word cloud being updated every 5 seconds:

> It takes a few seconds to establish the connection to Kafka. If you don’t see new names generated every 5 seconds reload the browser page to re-initialize the SSE stream.

![kafka](/openshift/assets/middleware/quarkus/wordcloud.png)

## Congratulations!

This guide has shown how you can interact with Kafka using Quarkus. It utilizes MicroProfile Reactive Messaging to build
data streaming applications.

If you want to go further check the documentation of [SmallRye Reactive
Messaging](https://smallrye.io/smallrye-reactive-messaging), the implementation used in Quarkus.
