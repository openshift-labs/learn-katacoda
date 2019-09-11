Now that we have our app built, let's move it into containers and into the cloud where Prometheus can scrape from.

## Build executable JAR

Quarkus applications can be built as executable JARs, or native binary images. Here we'll use an executable JAR to deploy our app. Build the application:

`mvn clean package -DskipTests`{{execute}}

It produces 2 jar files:

* `getting-started-1.0-SNAPSHOT.jar` - containing just the classes and resources of the projects, it’s the regular artifact produced by the Maven build

* `getting-started-1.0-SNAPSHOT-runner.jar` - being an executable jar. Be aware that it’s not an über-jar as the dependencies are copied into the `target/lib` directory.

## Deploy to OpenShift

Now let's deploy the application itself. First, create a new _binary_ build definition within OpenShift using the Java container image:

`oc new-build registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:1.5 --binary --name=primes -l app=primes`{{execute}}

> This build uses the new [Red Hat OpenJDK Container Image](https://access.redhat.com/documentation/en-us/red_hat_jboss_middleware_for_openshift/3/html/red_hat_java_s2i_for_openshift/index), providing foundational software needed to run Java applications, while staying at a reasonable size.

Next, create a directory to house only our previously-built app plus the `lib` directory:

`rm -rf target/binary && mkdir -p target/binary && cp -r target/*-runner.jar target/lib target/binary`{{execute}}

> Note that you could also use a true source-based S2I build, but we're using binaries here to save time.

And then start and watch the build, which will take about a minute to complete:

`oc start-build primes --from-dir=target/binary --follow`{{execute}}

> This command will take about 1 minute to complete. Wait for it!

It should end with:

```
Pushed 5/6 layers, 95% complete
Pushed 6/6 layers, 100% complete
Push successful
```

Once that's done, deploy it as an OpenShift application:

`oc new-app primes && oc expose service primes`{{execute}}

Finally, make sure it's actually done rolling out:

`oc rollout status -w dc/primes`{{execute}}

Wait for that command to report `replication controller "primes-1" successfully rolled out` before continuing.

And now we can access using `curl` once again to test our primes:

`curl http://primes-quarkus.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/prime/1`{{execute}}

`curl http://primes-quarkus.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/prime/350`{{execute}}

`curl http://primes-quarkus.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/prime/629521085409773`{{execute}}

With our app rolled out, Prometheus should start collecting metrics. Let's take a look in the next exercise.