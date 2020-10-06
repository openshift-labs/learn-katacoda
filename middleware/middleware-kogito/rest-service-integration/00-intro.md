In this scenario, you will learn 2 ways to call a RESTful microservice from [Kogito](https://kogito.kie.org) process/workflow.

## What is Kogito?

![Logo](/openshift/assets/middleware/middleware-kogito/logo.png)

### BPMN2 and Services

The BPMN2 specification defines the _Service Task_, an activity node used to invoke an automated application (or service) to execute a task. In [Kogito](https://kogito.kie.org), a _Service Task_ can be implemented using a CDI bean (Quarkus) or a Spring bean (Spring Boot).

A CDI implementation of a _Service Task_ allows us to inject various capabilities and functionality into the implementation to allow us to, for example, define the integration logic to connect to external systems. In this scenario we will look at two options to integrate with RESTful microservice. First, we will use the MicroProfile Rest Client to call an external microservice. After that, we will replace this logic with an [Apache Camel](https://camel.apache.org/) route to call the same service. Note that the integration with Camel is extremely interesting, as Camel provides a vast array of connectors to connect to virtually any type of external system (e.g. SalesForce, Kafka, Twitter, SAP, etc.).

### Other possibilities

Learn more at [kogito.kie.org](https://kogito.kie.org), or just drive on and get hands-on!
