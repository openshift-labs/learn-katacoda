# Inspect Java runtime

An appropriate Java runtime has been installed for you. Ensure you can use it by running this command:

> If the command fails, wait a few moments and try again (it is installed in a background process and make take a few moments depending on system load).

`$JAVA_HOME/bin/java --version`{{execute}}

The command should report the version in use, for example (the versions and dates may be slightly different than the below example):

```console
openjdk 11.0.10 2021-01-19
OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.10+9)
OpenJDK 64-Bit Server VM AdoptOpenJDK (build 11.0.10+9, mixed mode)
```

## Import the code

Let's refresh the code we'll be using. Run the following command to clone the sample project:

`cd /root/projects && rm -rf rhoar-getting-started && git clone https://github.com/openshift-katacoda/rhoar-getting-started`{{execute}}

# The Project

You start with a basic Maven-based application with the usual `pom.xml` entries for a Quarkus app.

We've also included a frontend HTML file at `src/main/resources/META-INF/resources/index.html`{{open}} that will show our list of Coffee.

# The Application You Will Build

The application is a simple CRUD app with a Front end that lists Coffee and gives options to remove and add more Coffee.

We also use a CoffeeResource that helps us define those methods with JAX-RS.

Further more we use a PostgreSQL database, where we create the databses, read from and write to it.

Lets get started. We have already created a project for you, and lets continue adding functionality to this bare bones project.

> In this guide, we will use the Mutiny API of the Reactive PostgreSQL Client. If you’re not familiar with Mutiny reactive types, read the [Getting Started with Reactive guide](https://quarkus.io/guides/getting-started-reactive#mutiny) if you want to learn more!


## Add Extension

Like other exercises, we’ll need another extension to start using the PosgtreSQL. Lets install it by clicking on the following command:

`cd /root/projects/rhoar-getting-started/quarkus/reactive-sql &&
  mvn quarkus:add-extension -Dextensions="reactive-pg-client"`{{execute}}

> The first time you add the extension, new dependencies may be downloaded via maven. This should only happen once, after that things will go even faster.

This will add the necessary entries in your `pom.xml`{{open}} to bring in the Reactive PostgreSQL extension. You'll see:

```xml
<dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-reactive-pg-client</artifactId>
</dependency>
```

There are a few other extensions we'll use that are already there, including `resteasy-jackson` (for encoding Java objects as JSON objects).

With the app initialized, lets start coding!
