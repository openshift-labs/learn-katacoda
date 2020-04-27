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

`oc new-project quarkus-spring --display-name="Sample Quarkus App using Spring APIs"`{{execute T1}}

Before we deploy the application we need to deploy the Postgres database.

## Deploy Postgres

When running in production, we'll need a Postgres database on OpenShift. Click the next command to deploy Postgres to your new project:

`oc new-app \
    -e POSTGRESQL_USER=sa \
    -e POSTGRESQL_PASSWORD=sa \
    -e POSTGRESQL_DATABASE=fruits \
    -e POSTGRESQL_MAX_CONNECTIONS=200 \
    --name=postgres-database \
    openshift/postgresql`{{execute T1}}`

## Configure Quarkus

Since we are now deploying this to Openshift our database will no longer be on localhost. And our production is running Postgres. How do we handle these multiple configurations? Quarkus has a neat feature where we can create different profiles. So we will use the %dev profile for our local environment.

Click: `fruit-taster/src/main/resources/application.properties`{{open}} to open this file. This file contains Quarkus configuration.

Click **Copy to Editor** to add the following values to the `application.properties` file:

<pre class="file" data-filename="./fruit-taster/src/main/resources/application.properties" data-target="replace">
%dev.quarkus.datasource.url=jdbc:h2:mem:rest-crud
%dev.quarkus.datasource.driver=org.h2.Driver
%dev.quarkus.datasource.max-size=8
%dev.quarkus.datasource.min-size=2
%dev.quarkus.hibernate-orm.database.generation=drop-and-create
%dev.quarkus.hibernate-orm.log.sql=true

quarkus.datasource.url=jdbc:postgresql://postgres-database:5432/fruits
quarkus.datasource.driver=org.postgresql.Driver
quarkus.datasource.username=sa
quarkus.datasource.password=sa
quarkus.hibernate-orm.database.generation=drop-and-create
quarkus.hibernate-orm.sql-load-script = import.sql

taste.message = tastes great
taste.suffix = (if you like fruit!)
</pre>

## Deploy application to OpenShift

Now let's deploy the application itself. Run the following command which will build and deploy the Quarkus app in Openshift:

`mvn clean package \
-Dquarkus.kubernetes-client.trust-certs=true \
-Dquarkus.container-image.build=true \
-Dquarkus.kubernetes.deploy=true \
-Dquarkus.kubernetes.deployment-target=openshift \
-Dquarkus.openshift.expose=true \
-DskipTests \
-Dquarkus.openshift.labels.app.openshift.io/runtime=java`{{execute T1}}`

The output should end with `BUILD SUCCESS`.

For more details of the above options:

* `quarkus.kubernetes-client.trust-certs=true` - We are using self-signed certs in this simple example, so this simply says to the extension to trust them.
* `quarkus.container-image.build=true` - Instructs the extension to build a container image
* `quarkus.kubernetes.deploy=true` - Instructs the extension to deploy to OpenShift after the container image is built
* `quarkus.kubernetes.deployment-target=openshift` - Instructs the extension to generate and create the OpenShift resources (like `DeploymentConfig`s and `Service`s) after building the container
* `quarkus.openshift.expose=true` - Instructs the extension to generate an OpenShift `Route`.
* `quarkus.openshift.labels.app.openshift.io/runtime=java` - Adds a nice-looking icon to the app when viewing the OpenShift Developer Toplogy

Finally, make sure it's actually done rolling out:

`oc rollout status -w dc/fruit-taster`{{execute T1}}

Wait (about 30 seconds) for that command to report `replication controller "fruit-taster-1" successfully rolled out` before continuing.

> If the `oc rollout` command appears to not finish, just `CTRL-C` it and run it again.

And now we can access using `curl` once again:

`curl -s http://fruit-taster-quarkus-spring.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/taster | jq`{{execute T1}}

You should see the same fruits being tasted:

```console
[
  {
    "fruit": {
      "color": "red",
      "id": 1,
      "name": "cherry"
    },
    "result": "CHERRY: TASTES GREAT (IF YOU LIKE FRUIT!)"
  },
  ...
```


You can also see the app deployed in the [OpenShift Developer Toplogy](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com/topology/ns/quarkus-spring)


## Scale the app

With that set, let's see how fast our app can scale up to 10 instances:

`oc scale --replicas=10 dc/fruit-taster`{{execute T1}}

Back in the [OpenShift Developer Toplogy](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com/topology/ns/quarkus-spring) you'll see the app scaling dynamically up to 10 pods:

![Scaling](/openshift/assets/middleware/quarkus/scaling_spring_.png)

We now have 10 instances running providing better performance. Make sure it still works:

`curl -s http://fruit-taster-quarkus-spring.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/taster | jq`{{execute T1}}

**10 not enough? Try 100!** Click the command to scale this app to 100 instances:

`oc scale --replicas=50 dc/fruit-taster`{{execute T1}}


It will take a bit longer to scale that much. In the meantime the app continues to respond:

`curl -s http://fruit-taster-quarkus-spring.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/taster | jq`{{execute T1}}

You can watch the 50 pods spinning up:

`oc get pods -w -l app=fruit-taster`{{execute T1}}

Watch as long as you like, then `CTRL-C` the pod watcher.

Finally, scale it back down:

`oc scale --replicas=1 dc/fruit-taster`{{execute T1}}

## Congratulations!

This step covered the deployment of a Quarkus application on OpenShift. To try out the native features, try the Getting Started tutorial. There is much more, and the integration with these environments has been tailored to make Quarkus applications execution very smooth. For instance, the health extension can be used for [health check](https://access.redhat.com/documentation/en-us/openshift_container_platform/3.11/html/developer_guide/dev-guide-application-health); the configuration support allows mounting the application configuration using [config maps](https://access.redhat.com/documentation/en-us/openshift_container_platform/3.11/html/developer_guide/dev-guide-configmaps), the metric extension produces data _scrape-able_ by [Prometheus](https://prometheus.io/) and so on.
