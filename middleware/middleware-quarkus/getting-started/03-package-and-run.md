In the previous step you added a custom CDI bean to the app. Now it's time to package and run it as a self-contained JAR file.

### Stop the previous application

Let's stop the original application so we can package and re-run it as an executable JAR. In the terminal, press `CTRL-C` to stop the application.

### Package the app

Package the application:

`mvn package`{{execute}}. It produces 2 jar files:

* `getting-started-1.0-SNAPSHOT.jar` - containing just the classes and resources of the projects, it’s the regular artifact produced by the Maven build

* `getting-started-1.0-SNAPSHOT-runner.jar` - being an executable jar. Be aware that it’s not an über-jar as the dependencies are copied into the `target/lib` directory.

See the files with this command:

`ls -l target/*.jar`{{execute}}

## Run the executable JAR

You can run the packaged application by clicking:

`java -jar target/getting-started-1.0-SNAPSHOT-runner.jar`{{execute}}

And then test it again using the browser to access the `/hello/greeting` endpoint, passing `quarkus` in the URL using [this link](https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/hello/greeting/quarkus).

You should see:

```console
hello quarkus from master
```

> The `Class-Path` entry of the `MANIFEST.MF` from the _runner jar_ explicitly lists the jars from the `lib` directory. So if you want to deploy your application somewhere, you need to copy the _runner jar_ as well as the _lib_ directory. If you want to create an Uber-jar with everything included, you can use `mvn pakage -DuberJar`.

## Cleanup

Go back to the terminal and stop the app once again by pressing `CTRL-C`.

## Congratulations!

You've packaged up the app as an executable JAR and learned a bit more about the mechanics of packaging. In the next step, we'll continue our journey and build a _native image_ and then we'll learn about the native executable creation and the packaging in a Linux container.

