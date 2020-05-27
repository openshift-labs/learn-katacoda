In this step, you will create the Kogito application skeleton.

# The Project

You start with a basic Maven-based Kogito application which has been generated from the Kogito Maven Archetype.

# The Application You Will Build

The application is a decision microservice which determines the airmiles a person will get based on his/her frequent flyer status and the price of the flight.

You will implement these rules in a DMN (Decision Model & Notation) model, using DMN DRDs (Decision Requirement Diagram), decision tables and DMN FEEL (Friendly Enough Expression Language) expressions.

Let's get started.

# Create a basic project

The easiest way to create a new Kogito project is to execute the Maven command below by clicking on it:

`mvn archetype:generate \
  -DinteractiveMode=false \
  -DarchetypeGroupId=org.kie.kogito \
  -DarchetypeArtifactId=kogito-quarkus-archetype \
  -DarchetypeVersion=0.9.0 \
  -DgroupId=org.acme \
  -DartifactId=airmiles-service \
  -Dversion=1.0-SNAPSHOT`{{execute}}

This will use the Kogito Maven Archetype and generate a basic Maven project for you in the `airmiles-service` subdirectory.

The default Kogito application created from the archetype contains a sample process called `test-process.bpmn2`. We will remove this process definition, as it is not required for our application.

`rm -f /root/projects/kogito/airmiles-service/src/main/resources/test-process.bpmn2`{{execute}}

# Running the Application

We will now run the Kogito application in development mode. This allows us to keep the application running while implementing our application logic. Kogito and Quarkus will _hot reload_ the application when it is accessed and changes have been detected.

`cd /root/projects/kogito/airmiles-service`{{execute}}

`mvn clean compile quarkus:dev`{{execute}}

When the application has started, you can access the [Swagger UI](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/swagger-ui).

You should see the following page:

![New Kogito Quarkus Web Page](/openshift/assets/middleware/middleware-kogito/new-kogito-quarkus-empty-swagger-ui.png)

It's working!


# Congratulations!

You've seen how to create the skeleton of basic Kogito app, and start the application in _Quarkus dev-mode_.

In the next step we'll add the DMN model to our application.
