Now that we have our app built, let's move it into containers and into the cloud.

## Install OpenShift extension

Quarkus offers the ability to automatically generate OpenShift resources based on sane default and user supplied configuration. The OpenShift extension is actually a wrapper extension that brings together the [kubernetes](https://quarkus.io/guides/deploying-to-kubernetes) and [container-image-s2i](https://quarkus.io/guides/container-image#s2i) extensions with defaults so that it’s easier for the user to get started with Quarkus on OpenShift.

Run the following command to add it to our project:

`mvn quarkus:add-extension -Dextensions="openshift"`{{execute T1}}

## Login to OpenShift

We'll deploy our app as the `developer` user. Run the following command to login with the OpenShift CLI:

`oc login -u developer -p developer`{{execute T1}}

You should see

```
Login successful.

You don't have any projects. You can try to create a new project, by running

    oc new-project <projectname>
```

## Create project

For this scenario, let's create a project that you will use to house your applications. Click:

`oc new-project quarkus --display-name="Sample Quarkus App"`{{execute T1}}

## Deploy application to OpenShift

Now let's deploy the application itself. Run the following command which will build and deploy a Quarkus native application using the OpenShift extension (this will take a few minutes to complete as it rebuilds the native executable, generates a container image and pushes it into OpenShift):

`mvn clean package -Pnative \
-Dquarkus.kubernetes-client.trust-certs=true \
-Dquarkus.container-image.build=true \
-Dquarkus.kubernetes.deploy=true \
-Dquarkus.kubernetes.deployment-target=openshift \
-Dquarkus.openshift.expose=true \
-Dquarkus.openshift.labels.app.openshift.io/runtime=quarkus`{{execute T1}}`

The output should end with `BUILD SUCCESS`.

For more details of the above options:

* `quarkus.kubernetes-client.trust-certs=true` - We are using self-signed certs in this simple example, so this simply says to the extension to trust them.
* `quarkus.container-image.build=true` - Instructs the extension to build a container image
* `quarkus.kubernetes.deploy=true` - Instructs the extension to deploy to OpenShift after the container image is built
* `quarkus.kubernetes.deployment-target=openshift` - Instructs the extension to generate and create the OpenShift resources (like `DeploymentConfig`s and `Service`s) after building the container
* `quarkus.openshift.expose=true` - Instructs the extension to generate an OpenShift `Route`.
* `quarkus.openshift.labels.app.openshift.io/runtime=quarkus` - Adds a nice-looking icon to the app when viewing the OpenShift Developer Topology

Finally, make sure it's actually done rolling out:

`oc rollout status -w dc/getting-started`{{execute T1}}

Wait for that command to report following before continuing.
`replication controller "getting-started-1" successfully rolled out`

You can also see the app deployed in the [OpenShift Developer Toplogy](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com/topology/ns/quarkus):

You'll need to login with the same credentials as before:

* Username: `developer`
* Password: `developer`

![topology](/openshift/assets/middleware/quarkus/greetingtopology.png)

So now our app is deployed to OpenShift

And now we can access using `curl` once again:

`curl http://getting-started-quarkus.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/hello/greeting/quarkus-on-openshift`{{execute T1}}

You should see:

```console
hello quarkus-on-openshift from getting-started-1-9sgsm
```

> Your pod's name will be different from the above.

## Congratulations!

This step covered the deployment of a Quarkus application on OpenShift. However, there is much more, and the integration with these environments has been tailored to make Quarkus applications execution very smooth. For instance, the health extension can be used for [health check](https://docs.openshift.com/container-platform/4.6/applications/application-health.html); the configuration support allows mounting the application configuration using [config maps](https://docs.openshift.com/container-platform/4.6/authentication/configmaps.html), the metric extension produces data _scrape-able_ by [Prometheus](https://prometheus.io/) and so on.

But we'll move to the final chapter around scaling and try a few things.


