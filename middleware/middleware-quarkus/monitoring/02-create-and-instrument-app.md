# Inspect Java runtime and create basic project

An appropriate Java runtime has been installed for you. Ensure you can use it by running this command:

`$JAVA_HOME/bin/java --version`{{execute T1}}

The command should report the version in use, for example (the versions and dates may be slightly different than the below example):

```console
openjdk 11.0.10 2021-01-19
OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.10+9)
OpenJDK 64-Bit Server VM AdoptOpenJDK (build 11.0.10+9, mixed mode)
```

If the command fails, wait a few moments and try again (it is installed in a background process and make take a few moments depending on system load).

## Create basic project

Let's create the basic Quarkus _Hello World_ application and include the necessary monitoring extensions. Click this command to create the project:

`cd /root/projects/quarkus && \
mvn io.quarkus:quarkus-maven-plugin:2.0.0.Final:create \
    -DprojectGroupId=org.acme \
    -DprojectArtifactId=primes \
    -DclassName="org.acme.quickstart.GreetingResource" \
    -Dextensions="micrometer-registry-prometheus" \
    -Dpath="/hello"`{{execute T1}}

This will use the Quarkus Maven Plugin and generate a basic Maven project for you in the `primes` subdirectory and include the `micrometer-registry-prometheus` extension which causes the app to generate metrics at the `/q/metrics` endpoint.

## Start the app

Change to the directory in which the app was created:

`cd /root/projects/quarkus/primes`{{execute T1}}

Let's begin Live Coding. Click on the following command to start the app in _Live Coding_ mode:

`mvn quarkus:dev`{{execute T1}}

You should see:

```console
__  ____  __  _____   ___  __ ____  ______
 --/ __ \/ / / / _ | / _ \/ //_/ / / / __/
 -/ /_/ / /_/ / __ |/ , _/ ,< / /_/ /\ \
--\___\_\____/_/ |_/_/|_/_/|_|\____/___/
INFO  [io.quarkus] (Quarkus Main Thread) primes 1.0.0-SNAPSHOT on JVM (powered by Quarkus x.xx.x.Final) started in x.xxxs. Listening on: http://localhost:8080
INFO  [io.quarkus] (Quarkus Main Thread) Profile dev activated. Live Coding activated.
INFO  [io.quarkus] (Quarkus Main Thread) Installed features: [cdi, micrometer, resteasy]

--
Tests paused, press [r] to resume, [h] for more options>
```

> The first time you build the app, new dependencies may be downloaded via maven. This should only happen once, after that things will go even faster.

Note the amazingly fast startup time! The app is now running "locally" (within the Linux container in which this exercise runs).

Test that the app is running by accessing the simple `hello` endpoint:

`cd /root/projects/quarkus/primes && \
  curl http://localhost:8080/hello`{{execute T2}}

> You may need to click this command again in case it doesn't execute properly on first click

you should see

```console
Hello RESTEasy
```

## Test Metrics endpoint

You will be able to immediately see the raw metrics generated from Quarkus apps. Run this in the Terminal:

`curl http://localhost:8080/q/metrics`{{execute T2}}

You will see a bunch of raw metrics in the OpenMetrics format (as we are using a Prometheus registry):

```console
# TYPE http_server_bytes_read summary
http_server_bytes_read_count 1.0
http_server_bytes_read_sum 0.0
# HELP http_server_bytes_read_max
# TYPE http_server_bytes_read_max gauge
http_server_bytes_read_max 0.0
```

This is what Prometheus will do to access and index the metrics from our app when we deploy it to the cluster.

### Using other Registry Implementations

It is possible to use other systems to consume metrics other than Prometheus, for example StackDriver (part of the [Quarkiverse](https://github.com/quarkiverse/quarkiverse-micrometer-registry)). You can also use other pre-packaged registries for other APM systems. Consult the [Quarkus Micrometer Guide](https://quarkus.io/guides/micrometer) for more detail.