In this step, you will create a straightforward application serving a `hello` endpoint. To demonstrate dependency injection this endpoint uses a `greeting` bean.

![Architecture](/openshift/assets/middleware/quarkus/arch.png)

# Create basic project

The easiest way to create a new Quarkus project is to click to run the following command:

`mvn io.quarkus:quarkus-maven-plugin:1.0.0.CR1:create \
    -DprojectGroupId=org.acme \
    -DprojectArtifactId=getting-started \
    -DclassName="org.acme.quickstart.GreetingResource" \
    -Dpath="/hello"`{{execute}}

This will use the Quarkus Maven Plugin and generate a basic Maven project for you in the `getting-started` subdirectory, generating:

* The Maven structure
* An `org.acme.quickstart.GreetingResource` resource exposed on `/hello`
* An associated unit test
* A landing page that is accessible on `http://localhost:8080` after starting the application
* Example `Dockerfile`s for both native and jvm modes
* The application configuration file

Once generated, look at the `getting-started/pom.xml`{{open}}. You will find the import of the Quarkus BOM, allowing to omit the version on the different Quarkus dependencies. In addition, you can see the `quarkus-maven-plugin` responsible of the packaging of the application and also providing the development mode.

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>io.quarkus</groupId>
            <artifactId>quarkus-bom</artifactId>
            <version>${quarkus.version}</version>
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

If we focus on the dependencies section, you can see we are using [Quarkus extensions](https://quarkus.io/extensions/) allowing the development and testing of REST applications:
```xml
<dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-resteasy</artifactId>
</dependency>
<dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-junit5</artifactId>
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>io.rest-assured</groupId>
    <artifactId>rest-assured</artifactId>
    <scope>test</scope>
</dependency>
```

During the project creation, the `getting-started/src/main/java/org/acme/quickstart/GreetingResource.java`{{open}} file has been created with the following endpoint:

```java
@Path("/hello")
public class GreetingResource {

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String hello() {
        return "hello";
    }
}
```
It’s a very simple REST endpoint, returning "hello" to requests on `/hello`.

> Compared to vanilla JAX-RS, with Quarkus there is no need to create an `Application` class. It’s supported but not required. In addition, only one instance of the resource is created and not one per request. You can configure this using the different `*Scoped` annotations (`ApplicationScoped`, `RequestScoped`, etc).

# Running the Application

First, change to the directory in which the project was created:

`cd /root/projects/quarkus/getting-started`{{execute}}

Now we are ready to run our application. Click here to run:

```mvn compile quarkus:dev```{{execute}}

You should see:

```console
2019-02-28 17:05:22,347 INFO  [io.qua.dep.QuarkusAugmentor] (main) Beginning quarkus augmentation
2019-02-28 17:05:22,635 INFO  [io.qua.dep.QuarkusAugmentor] (main) Quarkus augmentation completed in 288ms
2019-02-28 17:05:22,770 INFO  [io.quarkus] (main) Quarkus started in 0.668s. Listening on: http://localhost:8080
2019-02-28 17:05:22,771 INFO  [io.quarkus] (main) Installed features: [cdi, resteasy]
```

Note the amazingly fast startup time! Once started, you can request the provided endpoint in the browser [using this link](https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/hello).

You should see:

```console
hello
```
It's working!

Now, let's exercise the **live reload** capabilities of Quarkus. Click here to open the endpoint:  `getting-started/src/main/java/org/acme/quickstart/GreetingResource.java`{{open}}. Change `return "hello";` to `return "hola";` on line 14 in the editor. Don't save. Don't recompile or restart anything. Just try to reload the brower (or [click here](https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/hello) again.)

You should see the updated `hola` message.

Wow, how cool is that? Supersonic Subatomic live reload! Go ahead and change it a few more times and access the endpoint again. And we're just getting started.

> `quarkus:dev` runs Quarkus in development mode. This enables live reload with background compilation, which means that when you modify your Java files your resource files and refresh your browser these changes will automatically take effect.
> This will also listen for a debugger on port `5005`. If your want to wait for the debugger to attach before running you can pass `-Ddebug` on the command line. If you don’t want the debugger at all you can use `-Ddebug=false`.

# Congratulations!

You've seen how to build a basic app, package it as an executable JAR and start it up very quickly. We'll leave the app running and rely on hot reload for the next steps.

In the next step we'll inject a custom bean to showcase Quarkus' CDI capabilities.
