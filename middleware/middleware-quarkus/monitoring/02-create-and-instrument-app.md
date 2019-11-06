## Create basic project

Let's create the basic Quarkus _Hello World_ application and include the necessary monitoring extensions. Click this command to create the project:

`mvn io.quarkus:quarkus-maven-plugin:1.0.0.CR1:create \
    -DprojectGroupId=org.acme \
    -DprojectArtifactId=getting-started \
    -DclassName="org.acme.quickstart.GreetingResource" \
    -Dextensions="metrics" \
    -Dpath="/hello"`{{execute}}

This will use the Quarkus Maven Plugin and generate a basic Maven project for you in the `getting-started` subdirectory and include the `smallrye-metrics` extension which is an implementation of the MicroProfile Metrics specification used in Quarkus.

## Start the app

Change to the directory in which the app was created:

`cd /root/projects/quarkus/getting-started`{{execute}}

Let's begin Live Coding. Click on the following command to start the app in _Live Coding_ mode:

`mvn compile quarkus:dev`{{execute}}

You should see:

```console
INFO  [io.qua.dep.QuarkusAugmentor] (main) Beginning quarkus augmentation
INFO  [io.qua.dep.QuarkusAugmentor] (main) Quarkus augmentation completed in 1283ms
INFO  [io.quarkus] (main) Quarkus x.xx.x started in 1.988s. Listening on: http://[::]:8080
INFO  [io.quarkus] (main) Installed features: [cdi, resteasy, smallrye-metrics]
```
> The first time you build the app, new dependencies may be downloaded via maven. This should only happen once, after that things will go even faster.

Note the amazingly fast startup time! The app is now running "locally" (within the Linux container in which this exercise runs).

Test that the app is running by accessing the simple `hello` endpoint:

`cd /root/projects/quarkus/getting-started && \
  curl http://localhost:8080/hello`{{execute T2}}

> You may need to click this command again in case it doesn't execute properly on first click

you should see

```console
hello
```

## Test Metrics endpoint

You will be able to immediately see the raw metrics generated from Quarkus apps. Run this in the Terminal:

`curl http://localhost:8080/metrics`{{execute T2}}

You will see a bunch of metrics in the OpenMetrics format:

```
# HELP base:jvm_uptime_seconds Displays the time from the start of the Java virtual machine in milliseconds.
# TYPE base:jvm_uptime_seconds gauge
base:jvm_uptime_seconds 5.631
# HELP base:gc_ps_mark_sweep_count Displays the total number of collections that have occurred. This attribute lists -1 if the collection count is undefined for this collector.
# TYPE base:gc_ps_mark_sweep_count counter
base:gc_ps_mark_sweep_count 2.0
```

This is what Prometheus will do to access and index the metrics from our app when we deploy it to the cluster.
