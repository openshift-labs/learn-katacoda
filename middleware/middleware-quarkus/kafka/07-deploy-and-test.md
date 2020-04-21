## Install OpenShift extension

Quarkus offers the ability to automatically generate OpenShift resources based on sane default and user supplied configuration. The OpenShift extension is actually a wrapper extension that brings together the [kubernetes](https://quarkus.io/guides/deploying-to-kubernetes) and [container-image-s2i](https://quarkus.io/guides/container-image#s2i) extensions with sensible defaults so that it’s easier for the user to get started with Quarkus on OpenShift.

Run the following command to add it to our project:

`mvn quarkus:add-extension -Dextensions="openshift"`{{execute T2}}

Click **Copy to Editor** to add the following values to the `application.properties` file:

<pre class="file" data-filename="./src/main/resources/application.properties" data-target="append">
# Configure the OpenShift extension options (we write to it)
quarkus.kubernetes-client.trust-certs=true
quarkus.container-image.build=true
quarkus.kubernetes.deploy=true
quarkus.kubernetes.deployment-target=openshift
quarkus.openshift.expose=true
quarkus.openshift.labels.app.openshift.io/runtime=java
</pre>

For more details of the above options:

* `quarkus.kubernetes-client.trust-certs=true` - We are using self-signed certs in this simple example, so this simply says to the extension to trust them.
* `quarkus.container-image.build=true` - Instructs the extension to build a container image
* `quarkus.kubernetes.deploy=true` - Instructs the extension to deploy to OpenShift after the container image is built
* `quarkus.kubernetes.deployment-target=openshift` - Instructs the extension to generate and create the OpenShift resources (like `DeploymentConfig`s and `Service`s) after building the container
* `quarkus.openshift.expose=true` - Instructs the extension to generate an OpenShift `Route`.
* `quarkus.openshift.labels.app.openshift.io/runtime=java` - Adds a nice-looking icon to the app when viewing the OpenShift Developer Toplogy

## Login to OpenShift

We'll deploy our app as the `developer` user. Run the following command to login with the OpenShift CLI:

`oc login -u developer -p developer`{{execute T2}}

You should see

```
Login successful.

You don't have any projects. You can try to create a new project, by running

    oc new-project <projectname>
```

## Create project

Create a new project into which we'll deploy the app:

`oc new-project quarkus-kafka --display-name="Quarkus on Kafka"`{{execute T2}}

## Deploy application to OpenShift

Now let's deploy the application itself. Run the following command which will build and deploy using the OpenShift extension:

`mvn clean package`{{execute T2}}

The output should end with `BUILD SUCCESS`.

Finally, make sure it's actually done rolling out:

`oc rollout status -w dc/people`{{execute T2}}

Wait for that command to report `replication controller "people-1" successfully rolled out` before continuing.

You can also add a Java icon to the app if you don't see it in the OpenShift Developer Toplogy:

`oc label dc/people app.openshift.io/runtime=java --overwrite`{{execute T2}}

You can see the app deployed in the [OpenShift Developer Toplogy](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com/topology/ns/quarkus-kafka):

You'll need to login with the same credentials as before:

* Username: `developer`
* Password: `developer`

![topology](/openshift/assets/middleware/quarkus/peopletopology.png)

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
