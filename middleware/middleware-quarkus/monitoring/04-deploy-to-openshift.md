Now that we have our app built, let's move it into containers and into the cloud where Prometheus can scrape from.

## Install OpenShift extension

Quarkus offers the ability to automatically generate OpenShift resources based on sane default and user supplied configuration. The OpenShift extension is actually a wrapper extension that brings together the [kubernetes](https://quarkus.io/guides/deploying-to-kubernetes) and [container-image-s2i](https://quarkus.io/guides/container-image#s2i) extensions with defaults so that it’s easier for the user to get started with Quarkus on OpenShift.

Run the following command to add it to our project:

`mvn quarkus:add-extension -Dextensions="openshift"`{{execute T1}}

Open here to add OpenShift properties: `primes/src/main/resources/application.properties`{{open}}.

Then click **Copy to Editor** to add the following values to the `application.properties` file:

<pre class="file" data-filename="./src/main/resources/application.properties" data-target="append">
# Configure the OpenShift extension options
quarkus.kubernetes-client.trust-certs=true
quarkus.container-image.build=true
quarkus.kubernetes.deploy=true
quarkus.kubernetes.deployment-target=openshift
quarkus.openshift.expose=true
quarkus.openshift.labels.app.openshift.io/runtime=quarkus

</pre>

For more details of the above options:

* `quarkus.kubernetes-client.trust-certs=true` - We are using self-signed certs in this simple example, so this simply says to the extension to trust them.
* `quarkus.container-image.build=true` - Instructs the extension to build a container image
* `quarkus.kubernetes.deploy=true` - Instructs the extension to deploy to OpenShift after the container image is built
* `quarkus.kubernetes.deployment-target=openshift` - Instructs the extension to generate and create the OpenShift resources (like `DeploymentConfig`s and `Service`s) after building the container
* `quarkus.openshift.route.expose=true` - Instructs the extension to generate an OpenShift `Route`.
* `quarkus.openshift.labels.app.openshift.io/runtime=quarkus` - Adds a nice-looking icon to the app when viewing the OpenShift Developer Toplogy

## Deploy to OpenShift

Now let's deploy the application itself. Run the following command which will build and deploy using the OpenShift extension (it will take a minute or two):

`mvn clean package -DskipTests`{{execute T1}}

> **NOTE**: This command will take a minute or two, as it builds the app, pushes a container image, and finally deploys the container to OpenShift.

The output should end with `BUILD SUCCESS`.

Finally, make sure it's actually done rolling out:

`oc rollout status -w dc/primes`{{execute T1}}

Wait for that command to report `replication controller "primes-1" successfully rolled out` before continuing.

You can also see the app deployed in the [OpenShift Developer Toplogy](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com/topology/ns/quarkus):

You'll need to login with the same credentials as before:

* Username: `developer`
* Password: `developer`

![Deployed App](/openshift/assets/middleware/quarkus/primedep.png)

And now we can access using `curl` once again to test our prime service running on OpenShift. Click the commands to access the app on OpenShift:

`curl http://primes-quarkus.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/is-prime/1`{{execute}}

`curl http://primes-quarkus.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/is-prime/350`{{execute}}

`curl http://primes-quarkus.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/is-prime/629521085409773`{{execute T1}}

With our app rolled out, Prometheus should start collecting metrics. Let's take a look in the next exercise.