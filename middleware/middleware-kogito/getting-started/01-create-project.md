In this step, you will create a Kogito application skeleton.


# Create a basic project

The easiest way to create a new Kogito project is to execute the Maven command below by clicking on it:

`mvn archetype:generate \
  -DinteractiveMode=false \
  -DarchetypeGroupId=org.kie.kogito \
  -DarchetypeArtifactId=kogito-quarkus-archetype \
  -DarchetypeVersion=0.9.0 \
  -DgroupId=org.acme \
  -DartifactId=getting-started \
  -Dversion=1.0-SNAPSHOT`{{execute}}

This will use the Kogito Quarkus Archetype and generate a basic Maven project for you in the `getting-started` subdirectory, generating:

* The Maven structure.
* Example `test-process.bpmn2` BPMN2 process definition.
* An OpenAPI Swagger-UI at `http://localhost:8080/swagger-ui`.

Once generated, look at the `getting-started/pom.xml`{{open}}. You will find the import of the Kogito BOM, allowing to omit the version on the different Kogito and Quarkus dependencies. In addition, you can see the `quarkus-maven-plugin`, which is responsible for packaging of the application as well as allowing to start the application in development mode.

```xml
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>org.kie.kogito</groupId>
      <artifactId>kogito-quarkus-bom</artifactId>
      <version>${kogito.version}</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
  </dependencies>
</dependencyManagement>

<build>
    <plugins>
        <plugin>
            <groupId>io.quarkus</groupId>
            <artifactId>quarkus-maven-plugin</artifactId>
            <version>1.3.0.Final</version>
            <executions>
                <execution>
                    <goals>
                        <goal>build</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

If we focus on the dependencies section, you can see we are using the Kogito Quarkus extension, which enables the development of Kogito applications on Quarkus:
```xml
<dependency>
  <groupId>org.kie.kogito</groupId>
  <artifactId>kogito-quarkus</artifactId>
</dependency>
```

# Running the Application

First, change to the directory in which the project was created:

`cd /root/projects/kogito/getting-started`{{execute}}

Now we are ready to run our application. Click on the following command to start the application in _dev-mode_:

`mvn clean compile quarkus:dev`{{execute}}

You should see:

```console
2020-02-07 09:09:12,440 INFO  [io.quarkus] (main) getting-started 1.0-SNAPSHOT (running on Quarkus 1.2.0.Final) started in 5.850s. Listening on: http://0.0.0.0:8080
2020-02-07 09:09:12,447 INFO  [io.quarkus] (main) Profile dev activated. Live Coding activated.
2020-02-07 09:09:12,449 INFO  [io.quarkus] (main) Installed features: [cdi, kogito, resteasy, resteasy-jackson, smallrye-openapi, swagger-ui]
```

Because this is the first Maven Kogito/Quarkus build on this environment, the system first needs to download a number of dependencies, which can take some time.

After the dependencies have been downloaded, and the application has been compiled, note the amazingly fast startup time! Once started, you can request the provided Swagger UI in the browser [using this link](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/swagger-ui).

You should see the following page, which shows the API of the sample Kogito _Greetings_ service provided by the archetype:

![New Kogito Quarkus Web Page](/openshift/assets/middleware/middleware-kogito/new-kogito-quarkus-swagger-ui.png)

It's working!

# Congratulations!

You've seen how to create the skeleton of basic Kogito app, package it and start it up very quickly in `quarkus:dev` mode. We'll leave the app running and rely on hot reload for the next steps.

In the next step we'll create a BPMN2 process definition to demonstrate Kogito's code generation, hot-reload and workflow capabilities.
