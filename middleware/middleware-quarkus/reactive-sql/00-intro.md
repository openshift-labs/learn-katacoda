In this scenario, you will get an introduction to the reactive programming model of Quarkus

![Logo](/openshift/assets/middleware/quarkus/logo.png)

### Unifies Imperative and Reactive

Application requirements have changed drastically over the last few years. For any application to succeed in the era of cloud computing, big data or IoT, going reactive is increasingly becoming the architecture style to follow.

Quarkus combines both the familiar imperative code and the non-blocking reactive style when developing applications.

Quarkus uses Vert.x and Netty at its core. And uses a bunch of reactive frameworks and extensions on top to enable the developers. Quarkus is not just for HTTP microservices, but also for Event-Driven Architecture. The secret behind this is to use a single reactive engine for both imperative and reactive code.

![Reactive](/openshift/assets/middleware/quarkus/reactive-quarkus.png)


Quarkus does this quite brilliantly. Between imperative and reactive the obvious choice is to have a reactive core. What that helps with is a fast non-blocking core that handles almost everything going via the event-loop. So if you were creating a typical REST application or a client-side application, Quarkus also gives you the imperative programming model. For example, Quarkus HTTP support is based on a non-blocking and reactive engine (Eclipse Vert.x and Netty). All the HTTP requests your application receive are handled by event loops (IO Thread) and then are routed towards the code that manages the request. Depending on the destination, it can invoke the code managing the request on a worker thread (Servlet, Jax-RS) or use the IO Thread (reactive route)

In this scenario you will create a simple `Coffee Resource` endpoint by using JAX-RS with Quarkus backed by the Reactive SQL drivers; In our example we will use PostgreSQL Reactive SQL Driver. We will add methods like list, add and remove items from our list of famous Coffee.


# Reactive SQL
In every architecture component data is a key ingredient. With no surprises,relational databases store and crunch major amounts of data for applications to be used. Historically, traditional databases have not been reactive, that also trickles down to the JDBC API since using those databases have to be in conjuction with the underlying architecture, which ensures consistency, transactions, ACID etc. However in recent years, improvements have been made and JDBC access can now be done reactivels.

Some of the advantages with reactive SQL with Quarkus are:
- Simple API focusing on scalability and low overhead.
- Reactive and non blocking which able to handle many database connections with a single thread.
- Ranked #1 in the [TechEmpower Benchmark Round 15 Single query benchmark](https://www.techempower.com/benchmarks/#section=data-r15&hw=ph&test=db)




### Other possibilities

Learn more at [quarkus.io](https://quarkus.io), or just drive on and get hands-on!