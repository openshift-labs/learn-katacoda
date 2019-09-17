## Build executable JAR

Quarkus applications can be built as executable JARs, or native binary images. Here we'll use an executable JAR to deploy our app. Build the application:

`mvn clean package -DuberJar=true -DskipTests`{{execute T1}}

It produces 2 jar files:

* `fruit-taster-1.0-SNAPSHOT.jar` - containing just the classes and resources of the projects, it’s the regular artifact produced by the Maven build

* `fruit-taster-1.0-SNAPSHOT-runner.jar` - Since we used `-DuberJar=true`, this is an executable "Uber" JAR that can be run with `java -jar`.

## Run the app locally

Run the app by clicking on the below command:

`java -jar target/*-runner.jar`{{execute T1}}

Note the fast startup time!

When measuring the footprint of a Quarkus application, we measure Resident Set Size (RSS) and not the JVM heap size which is only a small part of the overall problem. The JVM not only allocates native memory for heap (`-Xms`, `-Xmx`) but also structures required by the JVM to run your application.

So, to see the RSS, click to run the following command in another terminal:

`ps -p $(jps|grep runner|awk '{print $1}') -o command,rss`{{execute T2}}

You should see something like:

```console
COMMAND                       RSS
java -jar target/fruit-tast 167660
```

This shows that our process is taking around 163 MB of memory ([Resident Set Size](https://en.wikipedia.org/wiki/Resident_set_size), or RSS). It gets even smaller when compiled to native (more on this later).

> Note that the RSS and memory usage of any app, including Quarkus, will vary depending your specific environment, and will rise as the application experiences load.

Make sure the app is still working as expected (we'll use `curl` this time to access it directly):

`curl -s http://localhost:8080/fruits | jq`{{execute T2}}

You should get back our default fruits data. Nice!

## Cleanup

In the first Terminal, press `CTRL-C` to stop the running Quarkus native app (or click the `clear`{{execute T1 interrupt}} command to do it for you).

## Congratulations!

You've now built a Java application as an executable JAR. Quarkus also supports building to _native_ images providing even greater startup speed and memory effeciency which we'll explore later.

Now let's give our app superpowers by deploying to OpenShift as a Linux container image.

