In the previous step you added a process definition to your Kogito application. Now it's time to package and run it as a self-contained JAR file.

### Stop the previous application

Let's stop the original application so we can package and re-run it as an executable JAR. In the first terminal, press `CTRL-C` to stop the application.

### Package the app

Package the application:

`mvn clean package`{{execute}}. It produces 2 jar files:

* `getting-started-1.0-SNAPSHOT.jar` - containing just the classes and resources of the projects, it’s the regular artifact produced by the Maven build.

* `getting-started-1.0-SNAPSHOT-runner.jar` - being an executable jar. Be aware that it’s not an über-jar as the dependencies are copied into the `target/lib` directory.

See the files with this command:

`ls -l target/*.jar`{{execute}}

## Run the executable JAR

You can run the packaged application by clicking:

`java -jar target/getting-started-1.0-SNAPSHOT-runner.jar`{{execute}}

We can test our application again using the second Terminal tab to create a new process instance by clicking on the following command:

`curl -X POST "http://localhost:8080/getting_started" -H "accept: application/json" -H "Content-Type: application/json" -d "{}"`{{execute T2}}

The output shows the id of the new instance (note that your id will be different from the one shown here)   

```console
{"id":"4844cfc0-ea93-46e3-8213-c10517bde1ce"}
```

> When we're not running in `mvn quarkus:dev` mode, the Swagger UI is not available. It can however be enabled by adding the following configuration to your `src/main/resources/application.properties` file:
>
>  `quarkus.swagger-ui.always-include=true`


> The `Class-Path` entry of the `MANIFEST.MF` file in the _runner JAR_ explicitly lists the jars from the `lib` directory. So if you want to deploy your application somewhere, you need to copy the _runner JAR_ as well as the _lib_ directory. If you want to create an _Uber-JAR_ with everything included, you can use `mvn package -DuberJar`.

## Cleanup

Go back to the first terminal and stop the application once again by pressing `CTRL-C`.

## Congratulations!

You've packaged up the Kogito app as an executable JAR and learned a bit more about the mechanics of packaging. In the next step, we'll continue our journey and build a _native image_. You will learn about the creation of a native executable and the packaging of such an executable in a Linux container.
