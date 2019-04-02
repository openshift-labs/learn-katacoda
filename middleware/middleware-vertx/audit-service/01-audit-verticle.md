## Composing methods returning Single

Open the `io.vertx.workshop.audit.impl.AuditVerticle` class:

`audit-service/src/main/java/io/vertx/workshop/audit/impl/AuditVerticle.java`{{open}} 

The first important detail of this verticle is its `start` method. As the `start` method from the traders, the method is asynchronous, and report its completion in the given `Future` object.

Vert.x would consider the verticle deploy when the Future is valuated. It may also report a failure if the verticle cannot be started correctly.

Initializing the audit service includes:

* Discover and configure the database (already in the code), and prepare the database (create the table),
* Start the HTTP service and expose the REST API,
* Retrieve the message source on which the operation are sent

So, it’s clearly 3 independent actions, but the audit service is started only when all of them has been completed. So, we need to implement this orchestration.

Replace the matching  `// TODO: retrieveSingles` block with code below

<pre class="file" data-filename="audit-service/src/main/java/io/vertx/workshop/audit/impl/AuditVerticle.java" data-target="insert" data-marker="// TODO: retrieveSingles">
Single&lt;JDBCClient&gt; databaseReady = jdbc
    .flatMap(client -> initializeDatabase(client, true));
Single&lt;HttpServer&gt; httpServerReady = configureTheHTTPServer();
Single&lt;MessageConsumer&lt;JsonObject&gt;&gt; messageConsumerReady = retrieveThePortfolioMessageSource();

Single&lt;MessageConsumer&lt;JsonObject&gt;&gt; readySingle = Single.zip(databaseReady, httpServerReady,
    messageConsumerReady, (db, http, consumer) -> consumer);
</pre>

This code should retrieves 3 Single objects (from methods provided in the class) and wait for the completion of the three tasks. The three singles are then combined in one `Single<MessageConsumer<JsonObject>>`. Don’t forget that the `initializeDatabase` requires the JDBC client as parameter and so should be called once the ``jdbc Single`` has completed. Also look at the `retrieveThePortfolioMessageSource` method to see how you can create a ``Single`` object from an already known entity (we should have used service discovery - it’s just to give an example). When you have the three Singles, zip them to be notified when all of them have completed. The zip function must return the `MessageConsumer<JsonObject>>`.

On success this Single registers a message listener on the portfolio message source storing the operation in the database for each received message.

Its completion notifies Vert.x that the start process is completed (or successfully or not), it calls `future.complete()` and `future.fail(cause)`.