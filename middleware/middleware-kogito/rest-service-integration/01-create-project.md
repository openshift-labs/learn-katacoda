In this step, we will create a Kogito application skeleton.


# Create a basic project

To create a new Quarkus project with the Kogito extension, click the following command.

`mvn io.quarkus:quarkus-maven-plugin:1.7.0.Final:create \
    -DprojectGroupId=org.acme \
    -DprojectArtifactId=coffeeshop \
    -Dextensions="org.kie.kogito:kogito-quarkus,io.quarkus:quarkus-smallrye-openapi"`{{execute}}


This uses the Quarkus Maven plugin and generates a basic Maven project for us in the `coffeeshop` subdirectory which contains:

* The project's Maven structure.
* An OpenAPI Swagger-UI at `http://localhost:8080/swagger-ui`.

Once generated, look at the `coffeeshop/pom.xml`{{open}}. We will find the import of the Quarkus BOM which enables us to omit the version of the Kogito and Quarkus dependencies. In addition, we can see the `quarkus-maven-plugin`, which is responsible for packaging of the application and which allows us to start the application in development mode.

# Running the Application

Click the following command to change directory to the `coffeeshop` directory:

`cd /root/projects/kogito/coffeeshop`{{execute}}

Click the following command to start the application in Quarkus development mode:

`mvn clean compile quarkus:dev`{{execute}}

We see the following output in the console:

```console
2020-02-07 09:09:12,440 INFO  [io.quarkus] (main) getting-started 1.0-SNAPSHOT (running on Quarkus 1.4.1.Final) started in 5.850s. Listening on: http://0.0.0.0:8080
2020-02-07 09:09:12,447 INFO  [io.quarkus] (main) Profile dev activated. Live Coding activated.
2020-02-07 09:09:12,449 INFO  [io.quarkus] (main) Installed features: [cdi, kogito, resteasy, resteasy-jackson, smallrye-openapi, swagger-ui]
```

Because this is the first Maven Kogito/Quarkus build in this environment, the system first needs to download a number of dependencies. This can take some time.

After the dependencies have downloaded, and the application is compiled, note the amazingly fast startup time! Once started, we can open the application's Swagger UI in the browser [using this link](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/swagger-ui).

We see the following Swagger-UI page. Because we have not yet implemented our application, there are no operations defined yet in our API:

![New Kogito Quarkus Web Page](/openshift/assets/middleware/middleware-kogito/new-quarkus-empty-swagger-ui.png)

It's working!

We can now stop the application using `CTRL-C`.

# The CoffeeService

The goal of this scenario is for our process to call an external microservice using REST from a BPMN2 Service Task node. So we need to have a RESTful microservice that we can call.

As part of this scenario we've provided a Quarkus-based microservice that serves as our Coffee Menu Service. The service provides a simple RESTful endpoint that returns a list of coffees on the menu, as well as the details of a single coffee item that can be selected by name.

To run the service, we first need to compile and package it.

Click the following command to change directory to the correct directory:

`cd /root/projects/kogito/coffeeservice-quarkus`{{execute T2}}

To package the project, click on the following command:

`mvn clean package`{{execute T2}}

This creates a new runnable Quarkus JAR file. Click on the following command to run the application:

`java -jar target/coffeeservice-quarkus-1.0-SNAPSHOT-runner.jar`{{execute T2}}

With the microservice running, we can access its [Swagger-UI here](https://[[CLIENT_SUBDOMAIN]]-8090-[[KATACODA_HOST]].environments.katacoda.com/swagger-ui).

We can also retrieve the list of coffees using curl.

`curl -X GET "http://localhost:8090/coffee" -H "accept: application/json" -d "{}"`{{execute T3}}

You should see the following output:

```console
[{"id":1,"name":"espresso-arabica","description":"arabica beans","price":2.0},{"id":2,"name":"espresso-robusta","description":"robusta beans","price":2.0},{"id":3,"name":"latte-arabica","description":"arabica beans, full fat bio milk","price":3.0}]
```

# Congratulations!

You've seen how to create the skeleton of basic Kogito app, package it and start it up very quickly in `quarkus:dev` mode. We'll leave the app running and rely on hot reload for the next steps.

In the next step we'll create a BPMN2 process definition to demonstrate Kogito's code generation, hot-reload and workflow capabilities.
