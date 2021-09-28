## Build executable JAR

Quarkus applications can be built as executable JARs, or native binary images. Here we'll use an executable JAR to deploy our app. Build the application:

`mvn clean package -DskipTests`{{execute}}. It produces 2 jar files:

* `target/fruit-taster-1.0.0-SNAPSHOT.jar` - containing just the classes and resources of the projects, it’s the regular artifact produced by the Maven build

* `target/quarkus-app/quarkus-run.jar` - being an executable jar. Be aware that it’s not an über-jar as the dependencies are copied into several subdirectories (and would need to be included in any layered container image).

See the files with this command:

`ls -l target/*.jar target/quarkus-app/*.jar`{{execute}}

> **NOTE**: Quarkus uses the _fast-jar_ packaging by default. The fast-jar packaging format is introduced as an alternative to the default jar packaging format. The main goal of this new format is to bring faster startup times.

## Run the executable JAR

You can run the packaged application by clicking:

`java -jar target/quarkus-app/quarkus-run.jar`{{execute}}

Make sure the app is still working as expected (we'll use `curl` this time to access it directly):

`curl -s http://localhost:8080/fruits | jq`{{execute T2}}

## Cleanup

In the first Terminal, press `CTRL-C` to stop the running Quarkus native app (or click the `clear`{{execute T1 interrupt}} command to do it for you).

## Congratulations!

You've now built a Java application as an executable JAR. Quarkus also supports building to _native_ images providing even greater startup speed and memory effeciency. Now let's give our app native powers by creating a Quarkus native app.
