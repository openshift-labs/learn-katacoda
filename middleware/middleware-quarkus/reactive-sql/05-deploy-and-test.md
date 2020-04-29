## Install OpenShift extension

Quarkus offers the ability to automatically generate OpenShift resources based on sane default and user supplied configuration. The OpenShift extension is actually a wrapper extension that brings together the [kubernetes](https://quarkus.io/guides/deploying-to-kubernetes) and [container-image-s2i](https://quarkus.io/guides/container-image#s2i) extensions with defaults so that it’s easier for the user to get started with Quarkus on OpenShift.

Run the following command to add it to our project:

`mvn quarkus:add-extension -Dextensions="openshift"`{{execute}}

Open here to add OpenShift properties: `./src/main/resources/application.properties`{{open}}.

Then click **Copy to Editor** to add the following values to the `application.properties` file:

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

## Deploy to OpenShift

Now let's deploy the application itself. Run the following command which will build and deploy using the OpenShift extension:

`mvn clean package`{{execute}}

The output should end with `BUILD SUCCESS`.

Finally, make sure it's actually done rolling out:

`oc rollout status -w dc/reactive-sql`{{execute}}

Wait for that command to report `replication controller "reactive-sql-1" successfully rolled out` before continuing.


So now our app is deployed to OpenShift. Finally, let's confirm that its working as expected.

[Open up the web UI](http://reactive-sql-reactive-sql.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com). You should see the front web page load with the List of Coffee

![Reactive SQL app UI](/openshift/assets/middleware/quarkus/reactive-sql-ui.png)

## Congratulations!

You now have your first running reactive sql application with Quarkus. In this tutorial we also used JAX-RS and deployed our application to the Openshift Container platform. 

To read more about Quarkus and Reactive sql head off to [QuarkusIO](http://www.quarkus.io) for more details. 
