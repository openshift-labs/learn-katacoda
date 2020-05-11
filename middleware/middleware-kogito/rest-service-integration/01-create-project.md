In this step, you will create a Kogito application skeleton.


# Create a basic project

We can create a new Quarkus project with the Kogito extension by executing the following Maven command:

`mvn io.quarkus:quarkus-maven-plugin:1.4.1.Final:create \
    -DprojectGroupId=org.acme \
    -DprojectArtifactId=coffeeshop \
    -Dextensions="org.kie.kogito:kogito-quarkus,io.quarkus:quarkus-smallrye-openapi"`{{execute}}


This will use the Kogito Quarkus Archetype and generate a basic Maven project for you in the `getting-started` subdirectory, generating:

* The Maven structure.
* Example `test-process.bpmn2` BPMN2 process definition.
* An OpenAPI Swagger-UI at `http://localhost:8080/swagger-ui`.

Once generated, look at the `getting-started/pom.xml`{{open}}. You will find the import of the Kogito BOM, allowing to omit the version on the different Kogito and Quarkus dependencies. In addition, you can see the `quarkus-maven-plugin`, which is responsible for packaging of the application as well as allowing to start the application in development mode.

# Running the Application

First, change to the directory in which the project was created:

`cd /root/projects/kogito/coffeeshop`{{execute}}

Now we are ready to run our application. Click on the following command to start the application in _dev-mode_:

`mvn clean compile quarkus:dev`{{execute}}

You should see:

```console
2020-02-07 09:09:12,440 INFO  [io.quarkus] (main) getting-started 1.0-SNAPSHOT (running on Quarkus 1.4.1.Final) started in 5.850s. Listening on: http://0.0.0.0:8080
2020-02-07 09:09:12,447 INFO  [io.quarkus] (main) Profile dev activated. Live Coding activated.
2020-02-07 09:09:12,449 INFO  [io.quarkus] (main) Installed features: [cdi, kogito, resteasy, resteasy-jackson, smallrye-openapi, swagger-ui]
```

Because this is the first Maven Kogito/Quarkus build on this environment, the system first needs to download a number of dependencies, which can take some time.

After the dependencies have been downloaded, and the application has been compiled, note the amazingly fast startup time! Once started, you can request the provided Swagger UI in the browser [using this link](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/swagger-ui).

You should see the following page, which shows the API of the sample Kogito _Greetings_ service provided by the archetype:

![New Kogito Quarkus Web Page](/openshift/assets/middleware/middleware-kogito/new-kogito-quarkus-swagger-ui.png)

It's working!

We can now stop the application using `CTRL-C`.

# The CoffeeService

The goal of this scenario is to have our process call an external microservice using REST from a Service Task node. Therefore we will need to have a RESTful microservice that we can call.

As part of this scenario we've provided a Quarkus-based microservice that will serve as our Coffee Menu Service. The service provides a simple RESTful endpoint that can return a list of coffees on the menu, as well as the details of a single coffee item that can be selected by name.

To run the service, we will first need to compile and package it.

We first need to navigate to the correct directory:

`cd /root/projects/kogito/coffeeservice-quarkus`{{execute T2}}

After which we can package the project:

`mvn clean package`{{execute T2}}

This will create a new runnable Quarkus JAR file. We can now run the application:

`java -jar target/coffeeservice-quarkus-1.0-SNAPSHOT-runner.jar`{{execute T2}}

With the microservice running, you can now access its [Swagger-UI here](https://[[CLIENT_SUBDOMAIN]]-8090-[[KATACODA_HOST]].environments.katacoda.com/swagger-ui).

We can also retrieve the list of coffees using curl.

`curl -X GET "http://localhost:8090/coffee" -H "accept: application/json" -d "{}"`{{execute T3}}

You should see the following output:

```console
[{"id":1,"name":"espresso-arabica","description":"arabica beans","price":2.0},{"id":2,"name":"espresso-robusta","description":"robusta beans","price":2.0},{"id":3,"name":"latte-arabica","description":"arabica beans, full fat bio milk","price":3.0}]
```

# Congratulations!

You've seen how to create the skeleton of basic Kogito app, package it and start it up very quickly in `quarkus:dev` mode. We'll leave the app running and rely on hot reload for the next steps.

In the next step we'll create a BPMN2 process definition to demonstrate Kogito's code generation, hot-reload and workflow capabilities.
