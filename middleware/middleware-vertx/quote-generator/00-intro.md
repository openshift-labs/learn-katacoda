In this scenario, you will learn more about Reactive Microservices using [Eclipse Vert.x](https://vertx.io), one of the runtimes included in [Red Hat OpenShift Application Runtimes](https://developers.redhat.com/products/rhoar).

This scenario is the first one in a list of scenarios that will walk you through building a Reactive application using Vert.x illustrating what Vert.x is. These scenarios offer an intermediate, hands-on session with Vert.x, from the first line of code, to making services, to consuming them and finally to assembling everything in a consistent reactive system. It illustrates what reactive systems are, what reactive programming is, and how to build applications based on reactive microservices (and the s is important).

## The Micro-Trader Application

The Vert.x application that is being developed is called the ``Micro-Trader`` and is composed of multiple microservices as seen below. It is a fake financial app, where we will be making (virtual) money. The application is composed of the following microservices:

* The quote generator - this is an absolutely unrealistic simulator that generates the quotes for 3 fictional companies MacroHard, Divinator, and Black Coat. The market data is published on the Vert.x event bus. It also publishes an HTTP endpoint to get the current value of the quote.
* The traders - these are a set of components that receives quotes from the quote generator and decides whether or not to buy or sell a particular share. To make this decision, they rely on another component called the portfolio service.
* The portfolio - this service manages the number of shares in our portfolio and their monetary value. It is exposed as a service proxy, i.e. an asynchronous RPC service on top of the Vert.x event bus. For every successful operation, it sends a message on the event bus describing the operation. It uses the quote generator to evaluate the current value of the portfolio.
* The audit - this is to keep a list of all our operations (yes, that’s the law). The audit component receives operations from the portfolio service via an event bus and address. It then stores theses in a database. It also provides a REST endpoint to retrieve the latest set of operations.
* The dashboard - some UI to let us know when we become rich.

Let’s have a look at the architecture:

![Architecture](/openshift/assets/middleware/rhoar-getting-started-vertx/reactive-ms-architecture.png)

The application uses several types of services:

* HTTP endpoint (i.e. REST API) - this service is located using an HTTP URL.
* gRPC - gRPC is a secure and fast RPC framework built on top of HTTP/2
* Message sources - these are components publishing messages on the event bus, the service is located using an (event bus) address.

All the components are going to be deployed in the same Kubernetes namespace (project), and will form a cluster.

The dashboard presents the available services, the value of each company’s quotes, the latest set of operations made by our traders and the current state of our portfolio. It also shows the state of the different circuit breakers.

![Architecture](/openshift/assets/middleware/rhoar-getting-started-vertx/dashboard.png)

## The first microservice - the quote generator

In this scenario, you are going to create the first microservice - the quote generator. In each subsequent scenario, you will create a microservice (from the set above) that will together form the Micro-Trader Application based on Vert.x.
