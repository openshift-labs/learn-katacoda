Quarkus offers the ability to automatically generate OpenShift resources based on sane default and user supplied configuration. The OpenShift extension is actually a wrapper extension that brings together the [kubernetes](https://quarkus.io/guides/deploying-to-kubernetes) and [container-image-s2i](https://quarkus.io/guides/container-image#s2i) extensions with sensible defaults so that it’s easier for the user to get started with Quarkus on OpenShift.

Run the following command to add it to our project:

`mvn quarkus:add-extension -Dextensions="openshift"`{{execute}}

Get back to the `src/main/resources/application.properties`{{open}} file and click **Copy to Editor** to add the following values to the `application.properties` file:

<pre class="file" data-filename="./src/main/resources/application.properties" data-target="append">
# Configure the OpenShift extension options (we write to it)
quarkus.kubernetes-client.trust-certs=true
quarkus.container-image.build=true
quarkus.kubernetes.deploy=true
quarkus.kubernetes.deployment-target=openshift
quarkus.openshift.labels.app.openshift.io/runtime=quarkus
quarkus.s2i.base-jvm-image=registry.access.redhat.com/ubi8/openjdk-8
</pre>

For more details of the above options:

* `quarkus.kubernetes-client.trust-certs=true` - We are using self-signed certs in this simple example, so this simply says to the extension to trust them.
* `quarkus.container-image.build=true` - Instructs the extension to build a container image
* `quarkus.kubernetes.deploy=true` - Instructs the extension to deploy to OpenShift after the container image is built
* `quarkus.kubernetes.deployment-target=openshift` - Instructs the extension to generate and create the OpenShift resources (like `DeploymentConfig`s and `Service`s) after building the container
* `quarkus.openshift.expose=true` - Instructs the extension to generate an OpenShift `Route`.
* `quarkus.openshift.labels.app.openshift.io/runtime=java` - Adds a nice-looking icon to the app when viewing the OpenShift Developer Toplogy

### Login to OpenShift

We'll deploy our app as the `developer` user. Run the following command to login with the OpenShift CLI:

`oc login -u developer -p developer`{{execute}}

You should see

```sh
Login successful.

You have one project on this server: "kafka"

Using project "kafka".
```

### Deploy application to OpenShift

Now let's deploy the application itself. Run the following command which will build and deploy using the OpenShift extension:

`mvn clean package`{{execute}}

At the end you should see an output similar to the folllowing:

```sh
...
[INFO] [io.quarkus.container.image.openshift.deployment.OpenshiftProcessor] Push successful
[INFO] [io.quarkus.kubernetes.deployment.KubernetesDeployer] Deploying to openshift server: https://openshift:6443/ in namespace: kafka.
[INFO] [io.quarkus.kubernetes.deployment.KubernetesDeployer] Applied: Service kafka-quarkus.
[INFO] [io.quarkus.kubernetes.deployment.KubernetesDeployer] Applied: ImageStream kafka-quarkus.
[INFO] [io.quarkus.kubernetes.deployment.KubernetesDeployer] Applied: ImageStream openjdk-11.
[INFO] [io.quarkus.kubernetes.deployment.KubernetesDeployer] Applied: BuildConfig kafka-quarkus.
[INFO] [io.quarkus.kubernetes.deployment.KubernetesDeployer] Applied: DeploymentConfig kafka-quarkus.
[INFO] [io.quarkus.kubernetes.deployment.KubernetesDeployer] Applied: Route kafka-quarkus.
[INFO] [io.quarkus.kubernetes.deployment.KubernetesDeployer] The deployed application can be accessed at: http://kafka-quarkus-kafka.2886795273-80-host19nc.environments.katacoda.com
[INFO] [io.quarkus.deployment.QuarkusAugmentor] Quarkus augmentation completed in 87529ms
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  01:32 min
[INFO] Finished at: 2020-12-10T18:11:03Z
[INFO] ------------------------------------------------------------------------
```

>The process should take a few moments to complete.

We are now ready to check the Kafka records.
