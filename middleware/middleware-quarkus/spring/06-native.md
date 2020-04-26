# Going Native

## This step requires 10-15 minutes of your time!

This step **requires around 10-15 minutes of your time** due to the aggressive build-time optimizations
Quarkus does at build-time coupled with the limited resources of this environment. Real-world environments
will enjoy much greater build-time performance.

Let’s now produce a native executable for our application. It improves the startup time of the application, and produces a minimal disk footprint. The executable would have everything to run the application including the "JVM" (shrunk to be just enough to run the application), and the application.

We will be using GraalVM, which includes a native compiler for producing native images for a number of languages, including Java. It's been installed for you:

`echo $GRAALVM_HOME`{{execute}}

## Build native image

Create a native executable by clicking:

`mvn clean package -Pnative -DskipTests=true`{{execute}}

> Since we are on Linux in this environment, and the OS that will eventually run our application is also Linux, we can use our local OS to build the native Quarkus app. If you need to build native Linux binaries when on other OS's like Windows or Mac OS X, you can use `-Dquarkus.native.container-runtime=[podman | docker]`. You'll need either Docker or [Podman](https://podman.io) installed depending on which container runtime you want to use!

This will take time (10-15 minutes) to finish. Wait for it! Get a cup of coffee!

In addition to the regular files, the build also produces `target/fruit-taster-1.0-SNAPSHOT-runner`. This is a native Linux binary:

`file target/fruit-taster-1.0-SNAPSHOT-runner`{{execute}}

```console
ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.32, BuildID[sha1]=f3975244b096e24dc0f6a001f4599acd4a0a70a8, not stripped
```

## Run native image

Since our environment here is Linux, you can _just run it_:

`target/fruit-taster-1.0-SNAPSHOT-runner`{{execute T1}}

Notice the amazingly fast startup time:

```console
2019-03-07 18:34:16,642 INFO  [io.quarkus] (main) Quarkus x.xx.x started in 0.016s. Listening on: http://[::]:8080
2019-03-07 18:34:16,643 INFO  [io.quarkus] (main) Installed features: [agroal, cdi, hibernate-orm, jdbc-postgresql, narayana-jta, resteasy, spring-data-jpa, spring-di, spring-web]
```
That's 16 milliseconds.

Quarkus apps also enjoy extremely low memory usage as reported by the Linux `ps` utility. Click here to run this in your other Terminal tab:

`ps -o pid,rss,command -p $(pgrep -f runner$)`{{execute T2}}

You should see something like:

```console
  PID   RSS  COMMAND
72643  24028 target/fruit-taster-1.0-SNAPSHOT-runner
```

This shows that our process is taking around 24 MB of memory ([Resident Set Size](https://en.wikipedia.org/wiki/Resident_set_size), or RSS). Pretty compact!

> Note that the RSS and memory usage of any app, including Quarkus, will vary depending your specific environment, and will rise as the application experiences load.

Make sure the app is still working as expected (we'll use `curl` this time to access it directly):

`curl http://localhost:8080/fruits`{{execute T2}}

You should get back our default fruits data. Nice!

## Cleanup

In the first Terminal, press `CTRL-C` to stop the running Quarkus native app (or click the `clear`{{execute T1 interrupt}} command to do it for you).

## Congratulations!

This step covered the deployment a Quarkus native application. Lets give this app some super powers and deploy it on Openshift.