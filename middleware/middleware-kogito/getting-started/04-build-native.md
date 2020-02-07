Let’s now produce a native executable for our application. It improves the startup time of the application, and produces a minimal disk footprint. The executable would have everything to run the application including the "JVM" (shrunk to be just enough to run the application), and the application.

![Native process](/openshift/assets/middleware/quarkus/native-image-process.png)

We will be using GraalVM, which includes a native compiler for producing native images for a number of languages, including Java. It's been installed for you:

`echo $GRAALVM_HOME`{{execute}}

## Build native image

Within the `getting-started/pom.xml`{{open}} is the declaration for the Quarkus Maven plugin which contains a profile for `native-image`:

```xml
  <profile>
    <id>native</id>
    <activation>
      <property>
        <name>native</name>
      </property>
    </activation>
    <build>
      <plugins>
        <plugin>
          <artifactId>maven-failsafe-plugin</artifactId>
          <version>${surefire-plugin.version}</version>
          <executions>
            <execution>
              <goals>
                <goal>integration-test</goal>
                <goal>verify</goal>
              </goals>
              <configuration>
                <systemProperties>
                  <native.image.path>${project.build.directory}/${project.build.finalName}-runner</native.image.path>
                </systemProperties>
              </configuration>
            </execution>
          </executions>
        </plugin>
      </plugins>
    </build>
    <properties>
      <quarkus.package.type>native</quarkus.package.type>
    </properties>
  </profile>
```
We use a profile because, you will see very soon, packaging the native image takes a few seconds. However, this compilation time is only incurred _once_, as opposed to _every_ time the application starts, which is the case with other approaches for building and executing JARs.

In the original terminal, if the application is still running, stop it with `Ctrl+C`. Next, a native executable by clicking: `mvn clean package -Pnative -DskipTests=true`{{execute}}

> Since we are working in a Linux environment, and the OS that will eventually run our application is also Linux, we can use our local OS to build the native Quarkus app. If you need to build native Linux binaries when on other OS's like Windows or macOS, you can use `-Dquarkus.native.container-runtime=[podman | docker]`. You'll need either Docker or [Podman](https://podman.io) installed depending on which container runtime you want to use!

This will take a minute or so to finish. Wait for it!

In addition to the regular files, the build also produces `target/getting-started-1.0-SNAPSHOT-runner`. This is a native Linux binary:

`file target/getting-started-1.0-SNAPSHOT-runner`{{execute}}

```console
$ file target/getting-started-1.0-SNAPSHOT-runner
target/getting-started-1.0-SNAPSHOT-runner: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.32, BuildID[sha1]=e922a54ad13711d63023ff99b370cc419a3eba96, not stripped
```

## Run native image

Since our environment here is Linux, you can _just run it_:

`target/getting-started-1.0-SNAPSHOT-runner`{{execute}}

Notice the amazingly fast startup time:

```console
2019-12-19 13:52:17,872 INFO  [io.quarkus] (main) getting-started 1.0-SNAPSHOT (running on Quarkus 1.0.1.Final) started in 0.006s. Listening on: http://0.0.0.0:8080
2019-12-19 13:52:17,872 INFO  [io.quarkus] (main) Profile prod activated.
2019-12-19 13:52:17,872 INFO  [io.quarkus] (main) Installed features: [cdi, kogito, resteasy, resteasy-jackson, smallrye-openapi]
```
That's 6 milliseconds. A _mere 6000 nanoseconds_.

And extremely low memory usage as reported by the Linux `ps` utility. Click here to run this in your other Terminal tab:

`ps -o pid,rss,command -p $(pgrep -f runner)`{{execute T2}}

You should see something like:

```console
  PID   RSS COMMAND
26473 14948 target/getting-started-1.0-SNAPSHOT-runner
```

This shows that our process is taking around 15 MB of memory ([Resident Set Size](https://en.wikipedia.org/wiki/Resident_set_size), or RSS). Pretty compact!

> Note that the RSS and memory usage of any app, including Quarkus, will vary depending your specific environment, and will rise as the application experiences load.

Make sure the app is still working as expected by creating a new process instance:

`curl -X POST "http://localhost:8080/getting_started" -H "accept: application/json" -H "Content-Type: application/json" -d "{}"`{{execute T2}}

```console
$ curl -X POST "http://localhost:8080/getting_started" -H "accept: application/json" -H "Content-Type: application/json" -d "{}"
{"id":"75c00bcc-97a5-4655-beee-9b0b7b320d19"}
```

Nice!

## Cleanup

Go to the first Terminal tab and press `CTRL-C` to stop our native app.

## Congratulations!

You've now built a Kogito application as an executable JAR and a Linux native binary. Now let's give our app superpowers by deploying to OpenShift as a Linux container image.
