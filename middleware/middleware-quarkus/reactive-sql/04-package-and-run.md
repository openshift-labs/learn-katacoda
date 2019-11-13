In the previous step you added a custom bean to the app. Now it's time to package and run it as a self-contained JAR file.

### Stop the previous application

Let's stop the original application so we can package and re-run it as an executable JAR. In the terminal, press `CTRL-C` to stop the application.

## Preparing to deploy application to OpenShift

Now let's deploy the application itself. Create a new project for our app:

`oc new-project reactive-sql --display-name="ReactiveSQL with Quarkus"`{{execute}}


We will also need to recreate our database since its not in this new project we are deploying in

``oc new-app postgresql-ephemeral --name database --param DATABASE_SERVICE_NAME=database --param POSTGRESQL_DATABASE=sampledb --param POSTGRESQL_USER=username --param POSTGRESQL_PASSWORD=password``{{execute}}

To monitor progress as the database is deployed and made ready, run the command:

``oc rollout status dc/database``{{execute}}


Now that we have a new database and a new project for our production system in place, its a good idea we should also change our application configuration. 

To do that, let use configuration profiles, Quarkus allows you to have multiple configuration profiles, so in our case we can have one for developers prefixed with %dev. and then one for our production. 

Open the application.properties `src/main/resources/application.properties` {{open}} and replace all the lines with the new application.properies config as stated below. 

<pre>
%dev.quarkus.datasource.url=vertx-reactive:postgresql://database.default.svc:5432/sampledb
%dev.quarkus.datasource.username=username
%dev.quarkus.datasource.password=password

quarkus.datasource.url=vertx-reactive:postgresql://database.reactive-sql.svc:5432/sampledb
quarkus.datasource.username=username
quarkus.datasource.password=password

</pre>

So now if you do `mvn quarkus:dev:` it will pick up the dev config profile otherwise it will take the default one, which we will use for our new deployment on openshift.


### Package the app

Package the application:

`mvn package`{{execute}}. It produces 2 jar files:

* `reactive-sql-1.0-SNAPSHOT.jar` - containing just the classes and resources of the projects, it’s the regular artifact produced by the Maven build

* `reactive-sql-1.0-SNAPSHOT-runner.jar` - being an executable jar. Be aware that it’s not an über-jar as the dependencies are copied into the `target/lib` directory.

See the files with this command:

`ls -l target/*.jar`{{execute}}

## Run the executable JAR

You can run the packaged application by clicking:

`java -jar target/reactive-sql-1.0-SNAPSHOT-runner.jar`{{execute}}

And then test using the browser to access the `/` endpoint at [this link](https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/).


> The `Class-Path` entry of the `MANIFEST.MF` from the _runner jar_ explicitly lists the jars from the `lib` directory. So if you want to deploy your application somewhere, you need to copy the _runner jar_ as well as the _lib_ directory. If you want to create an Uber-jar with everything included, you can use `mvn pakage -DuberJar`.

## Cleanup

Go back to the terminal and stop the app once again by pressing `CTRL-C`.

## Congratulations!

You've packaged up the app as an executable JAR and learned a bit more about the mechanics of packaging. In the next step, we'll continue our journey and build a _native image_ and then we'll learn about the native executable creation and the packaging in a Linux container.

