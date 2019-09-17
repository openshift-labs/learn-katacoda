# Deploy App to OpenShift
Now that we have our app built, let's move it into containers and into the cloud.

## Login to OpenShift

**Red Hat OpenShift Container Platform** is the preferred container orchestration platform for Quarkus. OpenShift is based on **Kubernetes** which is the most used Orchestration
for containers running in production.

OpenShift also ships with a feature rich web console as well as command line tools to provide users with a nice
interface to work with applications deployed to the platform.

In order to login, we will use the **oc** command and then specify the server that we
want to authenticate to:

`oc login [[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com --insecure-skip-tls-verify=true`{{execute T1}}

Enter your username and password:
* Username: **developer**
* Password: **developer**

Congratulations, you are now authenticated to the OpenShift server.

> If the above `oc login` command doesn't seem to do anything, you may have forgotten to stop the application from the previous
step. Click in the first terminal and press CTRL-C to stop the application and try to `oc login` again!

## Access OpenShift Project

[Projects](https://docs.openshift.com/container-platform/3.11/architecture/core_concepts/projects_and_users.html#projects)
are a top level concept to help you organize your deployments. An
OpenShift project allows a community of users (or a user) to organize and manage
their content in isolation from other communities.

For this scenario, let's create a project that you will use to house your applications. Click:

`oc new-project quarkus-spring --display-name="Sample Quarkus App using Spring APIs"`{{execute T1}}

**3. Open the OpenShift Web Console**

OpenShift ships with a web-based console that will allow users to
perform various tasks via a browser. To get a feel for how the web console
works, click on the "OpenShift Console" tab next to the "Local Web Browser" tab.

![OpenShift Console Tab](/openshift/assets/middleware/quarkus/openshift-console-tab.png)

> Note you will get a security certificate error due to the use of self-signed security certificates. You will need to accept the exception in your browser to continue to the OpenShift console.

The first screen you will see is the authentication screen. Enter the same username and password as before (`developer`/`developer`) and then log in:

![Web Console Login](/openshift/assets/middleware/quarkus/login.png)

After you have authenticated to the web console, you will be presented with a
list of projects that your user has permission to work with.

![Web Console Projects](/openshift/assets/middleware/quarkus/springprojects.png)

Click on your new project name to be taken to the project overview page
which will list all of the routes, services, deployments, and pods that you have
running as part of your project:

![Web Console Overview](/openshift/assets/middleware/quarkus/springoverview.png)

There's nothing there now, but that's about to change.

## Deploy Postgres

When running in production, we'll need a Postgres database on OpenShift. Click the next command to deploy Postgres to your new project:

`oc new-app \
    -e POSTGRESQL_USER=sa \
    -e POSTGRESQL_PASSWORD=sa \
    -e POSTGRESQL_DATABASE=fruits \
    -e POSTGRESQL_MAX_CONNECTIONS=200 \
    --name=postgres-database \
    openshift/postgresql`{{execute T1}}

## Deploy to OpenShift

Now let's deploy the application itself. First, create a new _binary_ build definition within OpenShift using the Java container image:

`oc new-build registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:1.5 --binary --name=fruit-taster`{{execute T1}}

> This build uses the new [Red Hat OpenJDK Container Image](https://access.redhat.com/documentation/en-us/red_hat_jboss_middleware_for_openshift/3/html/red_hat_java_s2i_for_openshift/index), providing foundational software needed to run Java applications, while staying at a reasonable size.

And then start and watch the build, which will take about a minute to complete:

`oc start-build fruit-taster --from-file target/*-runner.jar --follow`{{execute T1}}

This should take about 2 minutes to complete and should end with:

```console
...
Pushed 4/6 layers, 78% complete
Pushed 5/6 layers, 94% complete
Pushed 6/6 layers, 100% complete
Push successful
```
Once that's done, we'll deploy it as an OpenShift application and override the Postgres URL to specify our production Postgres credentials:

`oc new-app fruit-taster \
   -e QUARKUS_DATASOURCE_URL=jdbc:postgresql://postgres-database:5432/fruits && \
 oc expose svc/fruit-taster`{{execute T1}}

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

So now our app is deployed to OpenShift. You can also see it in the [Overview in the OpenShift Console](https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com/console/project/quarkus-spring/browse/rc/fruit-taster-1?tab=details) with its single replica running in 1 pod (the blue circle).

## Congratulations!

This step covered the deployment of a JVM-based Quarkus application on OpenShift. For even more performance and scalability, let's move to the final step: building and deploying a native-compiled app!
