## Import the code

Let's refresh the code we'll be using. Run the following command to clone the sample project:

`cd /root/projects && rm -rf rhoar-getting-started && git clone https://github.com/openshift-katacoda/rhoar-getting-started`{{execute}}

# Inspect Java runtime

An appropriate Java runtime has been installed for you. Ensure you can use it by running this command:

`$JAVA_HOME/bin/java --version`{{execute}}

The command should report the version in use, for example (the versions and dates may be slightly different than the below example):

```console
openjdk 11.0.10 2021-01-19
OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.10+9)
OpenJDK 64-Bit Server VM AdoptOpenJDK (build 11.0.10+9, mixed mode)
```

If the command fails, wait a few moments and try again (it is installed in a background process and make take a few moments depending on system load).

# The Project

You start with a basic Maven-based application with the usual `pom.xml` entries for a Quarkus app.

We've also included a frontend HTML file at `src/main/resources/META-INF/resources/index.html`{{open}} that will render our stream.

# The Application You Will Build

The app consists of 3 components that pass messages via Kafka and an in-memory stream, then uses SSE to push messages to
the browser. It looks like:

![kafka](/openshift/assets/middleware/quarkus/kafkaarch.png)

## Add Extension

Like other exercises, we’ll need another extension to integrate Quarkus with Kafka. Install it by clicking on the following command:

`cd /root/projects/rhoar-getting-started/quarkus/kafka &&
  mvn quarkus:add-extension -Dextensions="smallrye-reactive-messaging-kafka"`{{execute}}

> The first time you add the extension, new dependencies may be downloaded via maven. This should only happen once, after that things will go even faster.

This will add the necessary entries in your `pom.xml`{{open}} to bring in the Kafka extension. You'll see:

```xml
<dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-smallrye-reactive-messaging-kafka</artifactId>
</dependency>
```
## Live Coding

**Live Coding** (also referred to as _dev mode_) allows us to run the app and make changes on the fly. Quarkus will automatically re-compile and reload the app when changes are made. This is a powerful and effecient style of developing that you find to be very useful.

With our extension installed, let's begin Live Coding. Click on the following command to start the app in Live Coding mode:

```mvn compile quarkus:dev -Dquarkus.http.host=0.0.0.0```{{execute}}

You should see:

```console
people 1.0-SNAPSHOT on JVM (powered by Quarkus 1.12.2.Final) started in 1.806s. Listening on: http://0.0.0.0:8080
Profile dev activated. Live Coding activated.
Installed features: [cdi, mutiny, resteasy, smallrye-context-propagation, smallrye-reactive-messaging, smallrye-reactive-messaging-kafka, vertx]
```

> The first time you build the app, new dependencies may be downloaded via maven. This should only happen once, after that things will go even faster.

Note the amazingly fast startup time! The app is now running "locally" (within the Linux container in which this exercise runs).

Test that the app is running by accessing the simple `hello` endpoint:

`cd /root/projects/rhoar-getting-started/quarkus/kafka && \
  curl http://localhost:8080/hello`{{execute T2}}

> You may need to click this command again in case it doesn't execute properly on first click

you should see

```console
hello
```
## Cleanup

In the terminal, press `CTRL-C` to stop our running app.
