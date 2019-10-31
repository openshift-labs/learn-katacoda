## Build executable JAR

Quarkus applications can be built as executable JARs, or native binary images. Here we'll use an executable JAR to deploy our app. Build the application:

`mvn clean package -DuberJar`{{execute T2}}

It produces an executable jar file in the `target/` directory:

* `person-1.0-SNAPSHOT-runner.jar` - an executable jar that can be run with `java -jar`

Confirm the JAR file is there with this command:

`file target/*.jar`{{execute T2}}

## Deploy application to OpenShift

Now let's deploy the application itself. Create a new project for our app:

`oc new-project quarkus-kafka --display-name="Quarkus on Kafka"`{{execute T2}}


Next, create a new _binary_ build definition within OpenShift using the Java container image:

`oc new-build registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:1.5 --binary --name=people -l app=people`{{execute T2}}

The output should end with `--> Success`.

> This build uses the new [Red Hat OpenJDK Container Image](https://access.redhat.com/documentation/en-us/red_hat_jboss_middleware_for_openshift/3/html/red_hat_java_s2i_for_openshift/index), providing foundational software needed to run Java applications, while staying at a reasonable size.

And then start and watch the build, which will take about a minute to complete:

`oc start-build people --from-file target/*-runner.jar --follow`{{execute T2}}

It should end with:

```console
Pushed 5/6 layers, 96% complete
Pushed 6/6 layers, 100% complete
Push successful
```

Once that's done, deploy it as an OpenShift application:

`oc new-app people`{{execute T2}}

and expose it to the world:

`oc expose service people`{{execute T2}}

Finally, make sure it's actually done rolling out:

`oc rollout status -w dc/people`{{execute T2}}

Wait for that command to report `replication controller "people-1" successfully rolled out` before continuing.

And now we can access using `curl` once again to confirm the app is up:

`curl http://people-quarkus-kafka.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/hello`{{execute T2}}

So now our app is deployed to OpenShift. Finally, let's confirm our streaming Kafka app is working.

[Open up the web UI](http://people-quarkus-kafka.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com). You should see a word cloud being updated every 5 seconds:

> It takes a few seconds to establish the connection to Kafka. If you don’t see new names generated every 5 seconds reload the browser page to re-initialize the SSE stream.

![kafka](/openshift/assets/middleware/quarkus/wordcloud.png)

## Congratulations!

This guide has shown how you can interact with Kafka using Quarkus. It utilizes MicroProfile Reactive Messaging to build
data streaming applications.

If you want to go further check the documentation of [SmallRye Reactive
Messaging](https://smallrye.io/smallrye-reactive-messaging), the implementation used in Quarkus.
