## The Audit Service

The law is the law. The Sarbanes–Oxley Act requires you to keep a track of every transaction you do on a financial market. The audit service records the shares you buy and sell in a database. It’s going to be a PostGreSQL database, but is would be similar with another database, even no-sql database. The database is going to be deployed in OpenShift.
 
In this chapter we are going to cover: 

* advanced asynchronous orchestration 
* asynchronous JDBC 
* Vert.x Web to build REST API 
* Managing secrets with OpenShift

**1. Initialize katacoda environment**

You may have noticed a script running in the terminal. This is getting the lab ready up to this scenario i.e. it is 
1. Cloning the source code
2. Initialize the OpenShift environment
3. Build and deploy the quote-generator scenario
4. Build and deploy the portfolio-service sceanrio
5. Build and deploy the compulsive-traders sceanrio
6. Build and deploy the micro-trader-dashboard


**2. Accessing data asynchronously**

As said previously, Vert.x is asynchronous and you must never block the event loop. And you know what’s definitely blocking? Database accesses and more particularly JDBC! Fortunately, Vert.x provides a JDBC client that is asynchronous.

The principle is simple (and is applied to all clients accessing blocking systems):

![Architecture](/openshift/assets/middleware/rhoar-getting-started-vertx/database-sequence.png)

However, interactions with databases are rarely a single operation, but a composition of operations. For example:

1. Get a connection
2. Drop some tables
3. Create some tables
4. Close the connection

**3. The Audit service**

The Audit service:

1. Listens for the financial operations on the event bus
2. Stores the received operations in a database
3. Exposes a REST API to get the last 10 operations

Interactions with the database use the `vertx-jdbc-client`, an async version of JDBC. So expect to see some SQL code (I know you love it). But, to orchestrate all these asynchronous calls, we need the right weapons. We are going to use RX Java 2 for this.