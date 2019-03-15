## Event bus services - Porfolio service

In this scenario, we are going to implement an event bus service. A `Portfolio` stores the owned shares and the available cash.

**1. Initialize katacoda environment**

All the scenarios in this lab are sequential and build on each other. The portfolio microservice being developed in this scenario is dependant on the quote generator microservice that should have been built and running on the OpenShift Container Platform already. That is what the script running in the terminal is doing. It is: 
1. Cloning the source code
2. Initialize the OpenShift environment
3. Build and deploy the quote-generator scenario
4. Build and deploy the micro-trader-dashboard

**2. Introduction - RPC and Async RPC**

Microservices are not only about REST. They can be exposed using any types of interactions, and Remote Procedure Calls is one of them. With RPC, a component can effectively send a request to another component by doing a local procedure call, which results in the request being packaged in a message and sent to the callee. Likewise, the result is sent back and returned to the caller component as the result of the procedure call:

![Architecture](/openshift/assets/middleware/rhoar-getting-started-vertx/rpc-sequence.png)

Such interactions has the advantages to introduce typing, and so is less error-prone than unstructured messages. However, it also introduces a tighter coupling between the caller and the callee. The caller knows how to call the callee:

1. how the service is called
2. where the service is living (location)

![Architecture](/openshift/assets/middleware/rhoar-getting-started-vertx/async-rpc-sequence.png)

The AsyncResult notifies the Handler whether the invocation succeeded or failed. Upon success, the handler can retrieve the result.

Such async-RPC has several advantages:

* the caller is not blocked
* it deals with failures
* it avoids you to send messages on the event bus and manages object marshalling and unmarshalling for you.
