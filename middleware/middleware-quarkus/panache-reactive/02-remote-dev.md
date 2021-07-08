# Remote Live Coding

What if you want to expand the inner loop development cycle to a remote container environment such as Kubernetes or OpenShift? You can configure your application in remote development mode to make changes to your local files immediately visible in your remote container environment. This allows you to develop in the same environment you will actually run your app in, and with access to the same services.

We'll deploy our base application to OpenShift and connect it to your local environment. The end result will be a fully functional app, already running on the target platform (OpenShift).

## Login to OpenShift

In order to login, we will use the **oc** command and then specify the server that we
want to authenticate to:

`oc login -u developer -p developer`{{execute}}

This will automatically log you in as the user `developer` whose password is `developer`.

> If the above `oc login` command doesn't seem to do anything, you may have forgotten to stop the application from the previous
step. Click in the first terminal and press CTRL-C to stop the application and try to `oc login` again!

## Access OpenShift Project

For this scenario, let's create a project that you will use to house your applications. Click:

`oc new-project quarkus --display-name="Sample Quarkus Datatable App"`{{execute}}

**3. Open the OpenShift Web Console**

OpenShift ships with a web-based console that will allow users to
perform various tasks via a browser. To get a feel for how the web console
works, click this link to open the [Overview in the OpenShift Console](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com/topology/ns/quarkus/graph)

The first screen you will see is the authentication screen. Enter your username and password and
then log in:

* Username: `developer`
* Password: `developer`

![Web Console Login](/openshift/assets/middleware/quarkus/login.png)

Click **Skip Tour** to skip the new user introduction.

There's nothing there now ("No workloads found"), but that's about to change.

## Deploy Postgres

Our app will need a Postgres database. Click the next command to quickly deploy a Postgres instance to your new project:

`oc new-app \
    -e POSTGRESQL_USER=sa \
    -e POSTGRESQL_PASSWORD=sa \
    -e POSTGRESQL_DATABASE=person \
    --name=postgres-database \
    -l app.openshift.io/runtime=postgresql \
    openshift/postgresql`{{execute}}

You'll see the Postgres pod spinning up in the [console](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com/topology/ns/quarkus/graph).

![Postgres pod](/openshift/assets/middleware/quarkus/people-postgres.png)

## Add Quarkus OpenShift extension

Quarkus offers the ability to automatically generate OpenShift resources based on sane defaults and user supplied configuration. The OpenShift extension is actually a wrapper extension that brings together the [kubernetes](https://quarkus.io/guides/deploying-to-kubernetes) and [container-image-s2i](https://quarkus.io/guides/container-image#s2i) extensions with defaults so that it’s easier for the user to get started with Quarkus on OpenShift.

Click the following command to add it to our project:

`mvn quarkus:add-extension -Dextensions="openshift"`{{execute}}

You will see:

```console
[SUCCESS] ✅ Extension io.quarkus:quarkus-openshift has been installed
```

## Configure Quarkus for remote live coding

Click: `./src/main/resources/application.properties`{{open}} to open this file. This file contains Quarkus configuration.

Click **Copy to Editor** to add the following values to the `application.properties` file:

<pre class="file" data-filename="./src/main/resources/application.properties" data-target="replace">
# Remote Live Coding setup
quarkus.package.type=mutable-jar
quarkus.live-reload.password=changeit

# OpenShift Production Configuration
quarkus.datasource.reactive.url=postgresql://postgres-database:5432/person
quarkus.datasource.username=sa
quarkus.datasource.password=sa
quarkus.hibernate-orm.database.generation=drop-and-create
quarkus.hibernate-orm.sql-load-script=import.sql
</pre>

The `quarkus.package.type=mutable-jar` instructs Quarkus to package the app as a _mutable_ app. Mutable applications also include the deployment time parts of Quarkus (need for dev mode), so they take up a bit more disk space. If run normally they start just as fast and use the same memory as an immutable application, however they can also be started in dev mode.

We also configure Quarkus to use the Postgres database, using `postgres-database` as the hostname (which is resolved by OpenShift to the running Postgres database host).

> **NOTE:** that you can change the remote live-reload password to whatever you want. It is used to secure communication between the remote side and the local side.

## Deploy application to OpenShift

Run the following command which will build and deploy the Quarkus app in Openshift. There's a number of arguments (which could optionally be put in `application.properties`) that are explained below.

`mvn clean package -DskipTests \
-Dquarkus.kubernetes.deploy=true \
-Dquarkus.container-image.build=true \
-Dquarkus.kubernetes-client.trust-certs=true \
-Dquarkus.kubernetes.deployment-target=openshift \
-Dquarkus.openshift.route.expose=true \
-Dquarkus.openshift.annotations.\"app.openshift.io/connects-to\"=postgres-database \
-Dquarkus.openshift.env.vars.quarkus-launch-devmode=true`{{execute}}

The output should end with `BUILD SUCCESS`.

For more details of the above options:

* `quarkus.kubernetes.deploy=true` - Instructs the extension to deploy to OpenShift after the container image is built
* `quarkus.container-image.build=true` - Instructs the extension to build a container image
* `quarkus.kubernetes-client.trust-certs=true` - We are using self-signed certs in this simple example, so this simply says to the extension to trust them.
* `quarkus.kubernetes.deployment-target=openshift` - Instructs the extension to generate and create the OpenShift resources (like `DeploymentConfig`s and `Service`s) after building the container
* `quarkus.openshift.route.expose=true` - Instructs the extension to generate an OpenShift `Route` so we can access it from our browser.
* `quarkus.kubernetes.annotations."app.openshift.io/connects-to"=postgres-database` - Adds a visual connector to show the DB connection in the web console topology view.
* `quarkus.openshift.env.vars.quarkus-launch-devmode=true` - Sets an environment variable in the container to tell Quarkus to launch in dev mode (not production mode which is the default when deploying to Kubernetes or OpenShift)

Finally, make sure it's actually done rolling out:

`oc rollout status -w dc/people`{{execute}}

Wait (about 30 seconds) for that command to report `replication controller "people-1" successfully rolled out` before continuing.

> If the `oc rollout` command appears to not finish, just `CTRL-C` it and run it again.

You can see it on the [Overview in the OpenShift Console](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com/topology/ns/quarkus/graph):

![Quarkus pod](/openshift/assets/middleware/quarkus/people-quarkus.png)


Do a quick test to ensure the remote app is running by using `curl` to retrieve the list of sample people:

`curl -s http://people-quarkus.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/person | jq`{{execute}}

> You may need to click this again if the initial click opens a Terminal but doesn't run the command for you.

You should see:

```json
[
  {
    "id": 1,
    "birth": "1974-08-15",
    "eyes": "BLUE",
    "name": "Farid Ulyanov"
  },
  {
    "id": 2,
    "birth": "1984-05-24",
    "eyes": "BROWN",
    "name": "Salvador L. Witcher"
  },
  {
    "id": 3,
    "birth": "1999-04-25",
    "eyes": "HAZEL",
    "name": "Huỳnh Kim Huê"
  }
]
```

The app is now running on OpenShift. In the next step we will connect to it via Quarkus' Remote Development feature so that the running app is updated as we make changes.

# Save Environment variable

We'll refer to this URL often, so click this command to save it in an environment variable called `PEOPLE_URL` (and put it in the Bash shell startup in case we open new terminals later):

`export PEOPLE_URL=http://people-quarkus.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; echo "export PEOPLE_URL='$PEOPLE_URL'" >> ~/.bashrc`{{execute}}

# Remote Dev Connection

Now we are ready to run our in dev mode and connect it to the remote application. Click here to run:

```mvn quarkus:remote-dev -Dquarkus.live-reload.url=$PEOPLE_URL```{{execute}}

You should see a bunch of log output including:

```console
INFO  [io.qua.ver.htt.dep.dev.HttpRemoteDevClient] (Remote dev client thread) Connected to remote server
```

Your locally running Quarkus app is now connected to the remote side running on OpenShift, and changes you make here will be immediately reflected live in the remote application. Cool!

You will leave this connection up and running and live code using it in the next step.

> **NOTE**: If you accidently quit (e.g. CTRL-C) the locally running app, no problem. The remote side continues to execute normally, and you can reconnect by re-running the above `quarkus:remote-dev` command!

# Congratulations!

You've seen how to build a basic app and add a simple query using Panache Reactive, and setup a remote connection to live code your application as it runs in the target environment.

In the next step we'll add some more Panache Reactive queries and compare and contrast vs. ordinary Hibernate/JQL Reactive queries.

