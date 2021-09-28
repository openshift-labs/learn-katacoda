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
