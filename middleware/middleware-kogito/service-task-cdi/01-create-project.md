In this step, you will create the Kogito application skeleton.

# The Project

You start with a basic Maven-based Kogito application which has been generated from the Kogito Maven Archetype.

# The Application You Will Build

The application is a simple text processor application that will convert the passed text to uppercase.

You will implement logic that converts the text to uppercase in a CDI bean.

Let's get started.

# Create basic project

The easiest way to create a new Kogito project is to execute the Maven command below by clicking on it:

`mvn archetype:generate \
  -DinteractiveMode=false \
  -DarchetypeGroupId=org.kie.kogito \
  -DarchetypeArtifactId=kogito-quarkus-archetype \
  -DarchetypeVersion=0.8.1 \
  -DgroupId=org.acme \
  -DartifactId=service-task-cdi \
  -Dversion=1.0-SNAPSHOT`{{execute}}

This will use the Kogito Maven Archetype and generate a basic Maven project for you in the `service-task-cdi` subdirectory.


# Running the Application

First, change to the directory in which the project was created:

`cd /root/projects/kogito/service-task-cdi`{{execute}}

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

You should see the following page:

![New Kogito Quarkus Web Page](/openshift/assets/middleware/middleware-kogito/new-kogito-quarkus-swagger-ui.png)


# BPMN2 Process Definition

The default Kogito application contains a sample process called `test-process.bpmn2`. We will use this file as the base of our project.

Click on the following link to open the [Kogito Online Tooling] with our test process: https://kiegroup.github.io/kogito-online/?file=https://raw.githubusercontent.com/kiegroup/kogito-runtimes/master/archetypes/kogito-quarkus-archetype/src/main/resources/archetype-resources/src/main/resources/test-process.bpmn2#/editor/bpmn2

We will use this process definition as the base of our application.

# Running the Application

We will now run the Kogito application in development mode. This allows us to keep the application running while implementing our application logic. Kogito and Quarkus will _hot reload_ the application when it is acccessed and changes have been detected.

`cd /root/projects/kogito/service-task-cdi`{{execute}}
`mvn clean compile quarkus:dev`{{execute}}

When the application has started, you can access the [Swagger UI](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/swagger-ui).

You should see the following page:

![New Kogito Quarkus Web Page](/openshift/assets/middleware/middleware-kogito/new-kogito-quarkus-swagger-ui.png)

It's working!


# Congratulations!

You've seen how to create the skeleton of basic Kogito app, and open the base process definition in the [Kogito Online Tooling](https://kiegroup.github.io/kogito-online/#/). Finally, you've started the application in _Quarkus dev-mode_.

In the next step we'll add a CDI bean that implements our text processing logic.
