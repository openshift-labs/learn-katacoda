In this step, you will create a straightforward application serving a `hello` endpoint. To demonstrate dependency injection this endpoint uses a `greeting` bean.

![Architecture](/openshift/assets/middleware/quarkus/arch.png)

# Wait for prerequisite downloads

A suitable Java runtime is being installed and should take less than a minute. Once it's done, continue below!

# Create basic project

The easiest way to create a new Quarkus project is to click to run the following command:

`mvn io.quarkus:quarkus-maven-plugin:2.0.0.Final:create \
    -DprojectGroupId=org.acme \
    -DprojectArtifactId=getting-started \
    -DclassName="org.acme.quickstart.GreetingResource" \
    -Dpath="/hello"`{{execute}}

This will use the Quarkus Maven Plugin and generate a basic Maven project for you in the `getting-started` subdirectory, generating:

* The Maven structure
* An `org.acme.quickstart.GreetingResource` resource exposed on `/hello`
* An associated unit test
* A landing page that is accessible on `http://localhost:8080` after starting the application
* Example `Dockerfile`s for a variety of build targets (native, jvm, etc)
* The application configuration file

Once generated, look at the `getting-started/pom.xml`{{open}}. You will find the import of the Quarkus BOM, allowing to omit the version on the different Quarkus dependencies. In addition, you can see the `quarkus-maven-plugin` responsible of the packaging of the application and also providing the development mode.

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
```

If we focus on the dependencies section, you can see we are using [Quarkus extensions](https://quarkus.io/extensions/) allowing the development and testing of REST applications:
```xml
  <dependencies>
    <dependency>
      <groupId>io.quarkus</groupId>
      <artifactId>quarkus-arc</artifactId>
    </dependency>
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
  </dependencies>
```

During the project creation, the `getting-started/src/main/java/org/acme/quickstart/GreetingResource.java`{{open}} file has been created with the following endpoint:

```java
@Path("/hello")
public class GreetingResource {

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String hello() {
        return "Hello RESTEasy";
    }
}
```
It’s a very simple REST endpoint, returning "hello" to requests on `/hello`.

> Compared to vanilla JAX-RS, with Quarkus there is no need to create an `Application` class. It’s supported but not required. In addition, only one instance of the resource is created and not one per request. You can configure this using the different `*Scoped` annotations (`ApplicationScoped`, `RequestScoped`, etc).

# Running the Application

First, change to the directory in which the project was created:

`cd /root/projects/quarkus/getting-started`{{execute}}

Now we are ready to run our application. Click here to run:

```mvn quarkus:dev -Dquarkus.http.host=0.0.0.0```{{execute}}

You should see:

```console
__  ____  __  _____   ___  __ ____  ______
 --/ __ \/ / / / _ | / _ \/ //_/ / / / __/
 -/ /_/ / /_/ / __ |/ , _/ ,< / /_/ /\ \
--\___\_\____/_/ |_/_/|_/_/|_|\____/___/
INFO  [io.quarkus] (Quarkus Main Thread) getting-started 1.0.0-SNAPSHOT on JVM (powered by Quarkus x.x.x.Final) started in 1.194s. Listening on: http://0.0.0.0:8080
INFO  [io.quarkus] (Quarkus Main Thread) Profile dev activated. Live Coding activated.
INFO  [io.quarkus] (Quarkus Main Thread) Installed features: [cdi, resteasy]
--
Tests paused, press [r] to resume, [h] for more options>
```

Note the amazingly fast startup time! Once started, you can request the provided endpoint in the browser [using this link](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/hello).

You should see:

```console
Hello RESTEasy
```
It's working!

Now, let's exercise the **live reload** capabilities of Quarkus. Click here to open the endpoint:  `getting-started/src/main/java/org/acme/quickstart/GreetingResource.java`{{open}}. Change `return "Hello RESTEasy";` to `return "Hola RESTEasy";` on line 14 in the editor. Don't save. Don't recompile or restart anything. Just try to reload the brower (or [click here](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/hello) again.)

You should see the updated `hola` message.

Wow, how cool is that? Supersonic Subatomic live reload! Go ahead and change it a few more times and access the endpoint again. And we're just getting started.

> `quarkus:dev` runs Quarkus in development mode. This enables live reload with background compilation, which means that when you modify your Java files your resource files and refresh your browser these changes will automatically take effect.
> This will also listen for a debugger on port `5005`. If your want to wait for the debugger to attach before running you can pass `-Ddebug` on the command line. If you don’t want the debugger at all you can use `-Ddebug=false`.

# The Dev UI

When running in Developer mode, Quarkus apps expose a useful UI for inspecting and making on-the-fly changes to the app (much like live coding mode). It allows you to quickly visualize all the extensions currently loaded, see and edit their configuration values, see their status and go directly to their documentation.

To access the Dev UI for your running app, [click this link](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/q/dev) which should open up the Dev UI in a new browser tab.

![Dev UI](/openshift/assets/middleware/quarkus/dev-ui-overview.png)

For example, click on the `Config Editor` link within the `Configuration` tile to see and make updates to configuration. This is super useful for developers to confirm code and configuration changes, or experiment with various settings.

> **NOTE** The Dev UI is only enabled when in _developer_ mode. It is not deployed when in production mode, as it's designed for developers to use during development. For more detail on what you can do, check out the [Dev UI Guide](https://quarkus.io/guides/dev-ui).

# Continuous Testing

When in developer mode (via `mvn quarkus:dev`), Quarkus can automatically and continuously run your unit tests. You may have noticed in the console `Tests paused, press [r] to resume, [h] for more options>`. This is an indication that you can enter continuous test mode. Type `r` to turn continuous testing mode on in the console.

Earlier, you changed `Hello` to `Hola` which broke the default unit test, and you can now see this in the console:

```
Response body doesn't match expectation.
Expected: is "Hello RESTEasy"
  Actual: Hola RESTEasy
```

Let's fix the test. Change `Hola RESTEasy` back to `Hello RESTEasy` in the editor. As soon as you fix it, Quarkus automatically re-runs the test and you should now have passing tests:

```
All 1 tests are passing (0 skipped), 1 tests were run in 389ms. Tests completed at 12:25:40 due to changes to GreetingResource.class.
```

Quarkus analyses your unit tests and only re-runs the tests that are affected by code changes. It's one of many developer productivity features of Quarkus, providing immediate feedback to developers as they type. We'll leave the tests running continously just to ensure we don't mess up later.

# Congratulations!

You've seen how to build a basic app, package it as an executable JAR and start it up very quickly. You also saw how Quarkus can run tests continuously to turbocharge your development tasks and facilitate test-driven development. We'll leave the app running and rely on hot reload for the next steps.

In the next step we'll inject a custom bean to showcase Quarkus' CDI capabilities.
