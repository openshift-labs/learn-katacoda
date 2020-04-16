In this scenario, you will learn how to implement process and workflow logic with CDI beans in [Kogito](https://kogito.kie.org).

![Logo](/openshift/assets/middleware/middleware-kogito/logo.png)

### BPMN2 Service Task and CDI

The BPMN2 specification defines the _Service Task_, an activity node used to invoke an automated application (or service) to execute a task. In [Kogito](https://kogito.kie.org), a _Service Task_ can be implemented using a CDI bean (Quarkus) or a Spring bean (Spring Boot). In this scenario we will demonstrate this functionality using [Quarkus](https://www.quarkus.io).

Context & Dependency Injection (CDI) support allows developers to easily create process and workflow logic, in a standard Java way for building application logic. Developers can focus on developing business logic, rather than having to learn new frameworks and extensions for building process logic. These CDI beans can in their turn be injected with other logic (e.g. Camel for integration, JPA for persistence, SmallRye Reactive Messaging for messaging, etc.).

### Other possibilities

Learn more at [kogito.kie.org](https://kogito.kie.org), or just drive on and get hands-on!
