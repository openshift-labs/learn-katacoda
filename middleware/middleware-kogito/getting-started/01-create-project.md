In this step, you will create a Kogito application skeleton.


# Create basic project

The easiest way to create a new Kogito project is to execute the Maven command below by clicking on it:

`mvn io.quarkus:quarkus-maven-plugin:1.3.0.CR1:create \
    -DprojectGroupId=org.acme \
    -DprojectArtifactId=getting-started \
    -Dextensions=kogito,smallrye-openapi`{{execute}}

This will use the Quarkus Maven Plugin and generate a basic Maven project for you in the `getting-started` subdirectory, generating:

* The Maven structure.
* A landing page that is accessible on `http://localhost:8080` after starting the application.
* Example `Dockerfiles` for both Native and JVM modes.
* The application configuration file.
* An OpenAPI Swagger-UI at `http://localhost:8080/swagger-ui`.

Once generated, look at the `getting-started/pom.xml`{{open}}. You will find the import of the Quarkus BOM, allowing to omit the version on the different Quarkus dependencies. In addition, you can see the `quarkus-maven-plugin`, which is responsible for packaging of the application as well as allowing to start the application in development mode.

```xml
<dependencyManagement>
    <dependencies>
          <dependency>
            <groupId>${quarkus.platform.group-id}</groupId>
            <artifactId>${quarkus.platform.artifact-id}</artifactId>
            <version>${quarkus.platform.version}</version>
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
            <version>${quarkus.version}</version>
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

If we focus on the dependencies section, you can see we are using the [Kogito Quarkus extension](https://quarkus.io/extensions/#business-automation), which enables the development of Kogito applications on Quarkus:
```xml
<dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-kogito</artifactId>
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

After the dependencies have been downloaded, and the application has been compiled, note the amazingly fast startup time! Once started, you can request the provided endpoint in the browser [using this link](https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/).

You should see the following page:

![New Kogito Quarkus Web Page](/openshift/assets/middleware/middleware-kogito/new-kogito-quarkus-webpage.png)

It's working!

# Congratulations!

You've seen how to create the skeleton of basic Kogito app, package it and start it up very quickly in `quarkus:dev` mode. We'll leave the app running and rely on hot reload for the next steps.

In the next step we'll create a BPMN2 process definition to demonstrate Kogito's code generation, hot-reload and workflow capabilities.
