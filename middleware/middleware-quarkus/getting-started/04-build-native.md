Let’s now produce a native executable for our application. It improves the startup time of the application, and produces a minimal disk footprint. The executable would have everything to run the application including the "JVM" (shrunk to be just enough to run the application), and the application.

![Native process](/openshift/assets/middleware/quarkus/native-image-process.png)

We will be using GraalVM, which includes a native compiler for producing native images for a number of languages, including Java. It's been installed for you:

`echo $GRAALVM_HOME`{{execute}}

## Build native image

Within the `getting-started/pom.xml`{{open}} is the declaration for the Quarkus Maven plugin which contains a profile for `native-image`:

```xml
  <profile>
    <id>native</id>
    <build>
      <plugins>
        <plugin>
          <groupId>io.quarkus</groupId>
          <artifactId>quarkus-maven-plugin</artifactId>
          <version>${quarkus.version}</version>
          <executions>
            <execution>
              <goals>
                <goal>native-image</goal>
              </goals>
              <configuration>
                <enableHttpUrlHandler>true</enableHttpUrlHandler>
              </configuration>
            </execution>
          </executions>
        </plugin>
      </plugins>
    </build>
  </profile>
```
We use a profile because, you will see very soon, packaging the native image takes a few seconds. However, this compilation time is only incurred _once_, as opposed to _every_ time the application starts, which is the case with other approaches for building and executing JARs.

Create a native executable by clicking: `mvn clean package -Pnative -DskipTests=true`{{execute}}

> Since we are on Linux in this environment, and the OS that will eventually run our application is also Linux, we can use our local OS to build the native Quarkus app. If you need to build native Linux binaries when on other OS's like Windows or Mac OS X, you can use `-Dquarkus.native.container-runtime=[podman | docker]`. You'll need either Docker or [Podman](https://podman.io) installed depending on which container runtime you want to use!

This will take a minute or so to finish. Wait for it!

In addition to the regular files, the build also produces `target/getting-started-1.0-SNAPSHOT-runner`. This is a native Linux binary:

`file target/getting-started-1.0-SNAPSHOT-runner`{{execute}}

```console
$ file target/getting-started-1.0-SNAPSHOT-runner
target/getting-started-1.0-SNAPSHOT-runner: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.32, BuildID[sha1]=f3975244b096e24dc0f6a001f4599acd4a0a70a8, not stripped
```

## Run native image

Since our environment here is Linux, you can _just run it_:

`target/getting-started-1.0-SNAPSHOT-runner`{{execute}}

Notice the amazingly fast startup time:

```console
2019-03-07 18:34:16,642 INFO  [io.quarkus] (main) Quarkus 0.21.1 started in 0.004s. Listening on: http://[::]:8080
2019-03-07 18:34:16,643 INFO  [io.quarkus] (main) Installed features: [cdi, resteasy]
```
That's 4 milliseconds. A _mere 4000 nanoseconds_.

And extremely low memory usage as reported by the Linux `ps` utility. Click here to run this in your other Terminal tab:

`ps -o pid,rss,command -p $(pgrep -f runner)`{{execute T2}}

You should see something like:

```console
  PID   RSS  COMMAND
 4831 14184 target/getting-started-1.0-SNAPSHOT-runner
```

This shows that our process is taking around 13.8 MB of memory ([Resident Set Size](https://en.wikipedia.org/wiki/Resident_set_size), or RSS). Pretty compact!

> Note that the RSS and memory usage of any app, including Quarkus, will vary depending your specific environment, and will rise as the application experiences load.

Make sure the app is still working as expected (we'll use `curl` this time to access it directly):

`curl http://localhost:8080/hello/greeting/quarkus`{{execute T2}}

> This will automatically open and run `curl` in a separate terminal. You can also open additional terminals with the "+" button on the tab bar to the right.

```console
curl http://localhost:8080/hello/greeting/quarkus
hello quarkus from master
```

Nice!

## Cleanup

Go to the first Terminal tab and press `CTRL-C` to stop our native app.

## Congratulations!

You've now built a Java application as an executable JAR and a Linux native binary. Now let's give our app superpowers by deploying to OpenShift as a Linux container image.

