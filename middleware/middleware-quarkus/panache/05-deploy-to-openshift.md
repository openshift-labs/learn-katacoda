Now that we have our app built, let's move it into containers and into the cloud.

## Login to OpenShift

**Red Hat OpenShift Container Platform** is the preferred container orchestration platform for Quarkus. OpenShift is based on **Kubernetes** which is the most used Orchestration
for containers running in production. 

OpenShift also ships with a feature rich web console as well as command line tools to provide users with a nice
interface to work with applications deployed to the platform.

In order to login, we will use the **oc** command and then specify the server that we
want to authenticate to:

`oc login [[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com --insecure-skip-tls-verify=true -u developer -p developer`{{execute T1}}

This will automatically log you in as the user `developer` whose password is `developer`.

> If the above `oc login` command doesn't seem to do anything, you may have forgotten to stop the application from the previous
step. Click in the first terminal and press CTRL-C to stop the application and try to `oc login` again!

## Access OpenShift Project

[Projects](https://docs.openshift.com/container-platform/3.6/architecture/core_concepts/projects_and_users.html#projects)
are a top level concept to help you organize your deployments. An
OpenShift project allows a community of users (or a user) to organize and manage
their content in isolation from other communities. 

For this scenario, let's create a project that you will use to house your applications. Click:

`oc new-project quarkus --display-name="Sample Quarkus Datatable App"`{{execute T1}}

**3. Open the OpenShift Web Console**

OpenShift ships with a web-based console that will allow users to
perform various tasks via a browser. To get a feel for how the web console
works, click on the "OpenShift Console" tab next to the "Local Web Browser" tab.

![OpenShift Console Tab](/openshift/assets/middleware/quarkus/openshift-console-tab.png)

> Note you will get a security certificate error due to the use of self-signed security certificates. You will need to accept the exception in your browser to continue to the OpenShift console.

The first screen you will see is the authentication screen. Enter your username and password and
then log in:

* Username: `developer`
* Password: `developer`
  
![Web Console Login](/openshift/assets/middleware/quarkus/login.png)

After you have authenticated to the web console, you will be presented with a
list of projects that your user has permission to work with.

![Web Console Projects](/openshift/assets/middleware/quarkus/panache-projects.png)

Click on your new project name to be taken to the project overview page
which will list all of the routes, services, deployments, and pods that you have
running as part of your project:

![Web Console Overview](./openshift/assets/middleware/quarkus/panache-overview-empty.png)

There's nothing there now, but that's about to change.

## Build executable JAR

Quarkus applications can be built as executable JARs, or native binary images. Here we'll use an executable JAR to deploy our app. Build the application:

`mvn clean package`{{execute T1}}

It produces 2 jar files:

* `person-1.0-SNAPSHOT.jar` - containing just the classes and resources of the projects, it’s the regular artifact produced by the Maven build

* `person-1.0-SNAPSHOT-runner.jar` - being an executable jar. Be aware that it’s not an über-jar as the dependencies are copied into the `target/lib` directory.

See the files with this command:

`ls -l target/*.jar`{{execute}}

## Deploy Postgres

When running in production, we'll need a Postgres database. Click the next command to deploy Postgres to your new project:

`oc new-app \
    -e POSTGRESQL_USER=sa \
    -e POSTGRESQL_PASSWORD=sa \
    -e POSTGRESQL_DATABASE=person \
    --name=postgres-database \
    openshift/postgresql`{{execute T1}}

## Deploy to OpenShift

Now let's deploy the application itself. First, create a new _binary_ build definition within OpenShift using the Java container image:

`oc new-build registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:1.5 --binary --name=quarkus-datatable -l app=quarkus-datatable`{{execute T1}}

> This build uses the new [Red Hat OpenJDK Container Image](https://access.redhat.com/documentation/en-us/red_hat_jboss_middleware_for_openshift/3/html/red_hat_java_s2i_for_openshift/index), providing foundational software needed to run Java applications, while staying at a reasonable size.

Next, create a directory to house only our previously-built app plus the `lib` directory:

`rm -rf target/binary && mkdir -p target/binary && cp -r target/*runner.jar target/lib target/binary`{{execute T1}}

> Note that you could also use a true source-based S2I build, but we're using binaries here to save time.

And then start and watch the build, which will take about a minute to complete:

`oc start-build quarkus-datatable --from-dir=target/binary --follow`{{execute T1}}

Once that's done, we'll deploy it as an OpenShift application and override the Postgres URL to specify our production Postgres credentials (and set the file encoding to `UTF8` in case there are special characters in our sample data, which there are):

`oc new-app quarkus-datatable \
   -e QUARKUS_DATASOURCE_URL=jdbc:postgresql://postgres-database:5432/person \
   -e JAVA_OPTIONS='-Dfile.encoding=UTF8'`{{execute T1}}

and expose it to the world:

`oc expose service quarkus-datatable`{{execute T1}}

Finally, make sure it's actually done rolling out:

`oc rollout status -w dc/quarkus-datatable`{{execute T1}}

Wait for that command to report `replication controller "quarkus-datatable-1" successfully rolled out` before continuing.

And now we can access using `curl` once again to find everyone born in or before the year 2000 (there will be many):

`curl http://quarkus-datatable-quarkus.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/person/birth/before/2000 | jq`{{execute T1}}

So now our app is deployed to OpenShift. You can also see it in the [Overview in the OpenShift Console](https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com/console/project/quarkus/overview) with its single replica running in 1 pod (the blue circle), along with the Postgres database pod:

![Web Console Overview](/openshift/assets/middleware/quarkus/panache-overview.png)


## Congratulations!

This step covered the deployment of a Quarkus application on OpenShift. However, there is much more, and the integration with these environments has been tailored to make Quarkus applications execution very smooth. For instance, the health extension can be used for [health check](https://access.redhat.com/documentation/en-us/openshift_container_platform/3.11/html/developer_guide/dev-guide-application-health); the configuration support allows mounting the application configuration using [config maps](https://access.redhat.com/documentation/en-us/openshift_container_platform/3.11/html/developer_guide/dev-guide-configmaps), the metric extension produces data _scrape-able_ by [Prometheus](https://prometheus.io/) and so on.

But we'll move to the final chapter and try out our super-powered DataTable!


