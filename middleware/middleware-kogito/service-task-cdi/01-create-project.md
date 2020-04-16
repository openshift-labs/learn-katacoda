In this step, you will create the Kogito application skeleton.

# The Project

You start with a basic Maven-based Kogito application which has been generated from the Kogito Maven Archetype.

# The Application You Will Build

The application is a simple text processor application that will convert the passed text to uppercase.

You will implement logic that converts the text to uppercase in a CDI bean.

Let's get started.

# Create a basic project

The easiest way to create a new Kogito project is to execute the Maven command below by clicking on it:

`mvn archetype:generate \
  -DinteractiveMode=false \
  -DarchetypeGroupId=org.kie.kogito \
  -DarchetypeArtifactId=kogito-quarkus-archetype \
  -DarchetypeVersion=0.9.0 \
  -DgroupId=org.acme \
  -DartifactId=service-task-cdi \
  -Dversion=1.0-SNAPSHOT`{{execute}}

This will use the Kogito Maven Archetype and generate a basic Maven project for you in the `service-task-cdi` subdirectory.

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
