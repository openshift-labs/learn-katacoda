Now that we have our app built, let's move it into containers and into the cloud.

Make sure that you've stopped the Kogito application in your terminal with `CTRL-C`.

## Login to OpenShift

**Red Hat OpenShift Container Platform** is the preferred container orchestration platform for Quarkus. OpenShift is based on **Kubernetes** which is the most used Orchestration platform for containers running in production.

OpenShift also ships with a feature rich web console as well as command line tools to provide users with a nice interface to work with applications deployed to the platform.

In order to login, we will use the **oc** command and then specify the server that we want to authenticate to:

`oc login --server=https://[[HOST_SUBDOMAIN]]-6443-[[KATACODA_HOST]].environments.katacoda.com --insecure-skip-tls-verify=true`{{execute T1}}

Enter your username and password:
* Username: **developer**
* Password: **developer**

Congratulations, you are now authenticated to the OpenShift server.

> If the above `oc login` command doesn't seem to do anything, you may have forgotten to stop the application from the previous
step. Click in the first terminal and press CTRL-C to stop the application and try to `oc login` again!

## Access OpenShift Project

[Projects](https://docs.openshift.com/container-platform/3.11/architecture/core_concepts/projects_and_users.html#projects) are a top level concept to help you organize your deployments. An OpenShift project allows a community of users (or a user) to organize and manage their content in isolation from other communities.

For this scenario, let's create a project that you will use to house your applications. Click:

`oc new-project kogito --display-name="Sample Kogito App"`{{execute T1}}

**3. Open the OpenShift Web Console**

OpenShift ships with a web-based console that will allow users to perform various tasks via a browser. To get a feel for how the web console works, click on the "OpenShift Console" tab next to the "Local Web Browser" tab.

![OpenShift Console Tab](/openshift/assets/middleware/quarkus/openshift-console-tab.png)

> Note you will get a security certificate error due to the use of self-signed security certificates. You will need to accept the exception in your browser to continue to the OpenShift console.

The first screen you will see is the authentication screen. Enter your username and password (u: developer, p: developer) and then log in:

![Web Console Login](/openshift/assets/middleware/middleware-kogito/login.png)

After you have authenticated to the web console, you will be presented with a list of projects that your user has permission to work with.

![Web Console Projects](/openshift/assets/middleware/middleware-kogito/projects.png)

Click on your new project name to be taken to the project overview page which will list all of the routes, services, deployments, and pods that you have running as part of your project:

![Web Console Overview](/openshift/assets/middleware/middleware-kogito/overview.png)

There's nothing there now, but that's about to change.

## Deploy to OpenShift

First, create a new _binary_ build within OpenShift:

`oc new-build quay.io/quarkus/ubi-quarkus-native-binary-s2i:19.3.1 --binary --name=kogito-quickstart -l app=kogito-quickstart`{{execute T1}}

> This build uses the new [Red Hat Universal Base Image](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/building_running_and_managing_containers/using_red_hat_universal_base_images_standard_minimal_and_runtimes), providing foundational software needed to run most applications, while staying at a reasonable size.

And then start and watch the build, which will take about a minute or two to complete:

`oc start-build kogito-quickstart --from-file=target/getting-started-1.0-SNAPSHOT-runner --follow`{{execute T1}}

Once that's done, we'll deploy it as an OpenShift application:

`oc new-app kogito-quickstart`{{execute T1}}

and expose it to the world:

`oc expose service kogito-quickstart`{{execute T1}}

Finally, make sure it's actually done rolling out:

`oc rollout status -w dc/kogito-quickstart`{{execute T1}}

Wait for that command to report `replication controller "kogito-quickstart-1" successfully rolled out` before continuing.

And now we can access our application using `cURL` once again:

`curl -X POST "http://kogito-quickstart-kogito.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/getting_started" -H "accept: application/json" -H "Content-Type: application/json" -d "{}"`{{execute T1}}


You should again see the id of the process instance we've just started:

```console
{"id":"4844cfc0-ea93-46e3-8213-c10517bde1ce"}
```

So now our app is deployed to OpenShift. You can also see it in the [Overview in the OpenShift Console](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com/k8s/ns/kogito/deploymentconfigs/kogito-quickstart) with its single replica running in 1 pod (the blue circle).

## Congratulations!

This step covered the deployment of a Kogito application on OpenShift. However, there is much more, and the integration with these environments has been tailored to make Kogito applications execution very smooth. For instance, the health extension can be used for [health check](https://access.redhat.com/documentation/en-us/openshift_container_platform/3.11/html/developer_guide/dev-guide-application-health); the configuration support allows mounting the application configuration using config maps, the metric extension produces data _scrape-able_ by [Prometheus](https://prometheus.io/) and so on.

But we'll move to the final chapter around scaling and try a few things.
