## Build executable JAR

Quarkus applications can be built as executable JARs, or native binary images. Here we'll use an executable JAR to deploy our app. Build the application:

`mvn clean package -DuberJar`{{execute}}

It produces an executable jar file in the `target/` directory:

* `reactive-sql-1.0-SNAPSHOT.jar` - an executable jar that can be run with `java -jar`

Confirm the JAR file is there with this command:

`file target/*.jar`{{execute}}

Lets move on to the Next step; create a new _binary_ build definition within OpenShift using the Java container image:

`oc new-build registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:1.5 --binary --name=reactive-sql -l app=reactive-sql`{{execute}}

The output should end with `--> Success`.

> This build uses the new [Red Hat OpenJDK Container Image](https://access.redhat.com/documentation/en-us/red_hat_jboss_middleware_for_openshift/3/html/red_hat_java_s2i_for_openshift/index), providing foundational software needed to run Java applications, while staying at a reasonable size.

And then start and watch the build, which will take about a minute to complete:

`oc start-build reactive-sql --from-file target/*-runner.jar --follow`{{execute}}

It should end with:

```console
Pushed 5/6 layers, 96% complete
Pushed 6/6 layers, 100% complete
Push successful
```

Once that's done, deploy it as an OpenShift application:

`oc new-app reactive-sql`{{execute}}

and expose it to the world:

`oc expose service reactive-sql`{{execute}}

Finally, make sure it's actually done rolling out:

`oc rollout status -w dc/reactive-sql`{{execute}}

Wait for that command to report `replication controller "reactive-sql-1" successfully rolled out` before continuing.


So now our app is deployed to OpenShift. Finally, let's confirm that its working as expected.

[Open up the web UI](http://reactive-sql-reactive-sql.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com). You should see the front web page load with the List of Coffee

![Reactive SQL app UI](/openshift/assets/middleware/quarkus/reactive-sql-ui.png)

## Congratulations!

You now have your first running reactive sql application with Quarkus. In this tutorial we also used JAX-RS and deployed our application to the Openshift Container platform. 

To read more about Quarkus and Reactive sql head off to [QuarkusIO](http://www.quarkus.io) for more details. 
