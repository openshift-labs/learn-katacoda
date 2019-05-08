## Using Async JDBC

In the `start` method, we are calling `initializeDatabase`. This method is also not very functional at this point. Let’s look at this method using another type of action composition. This method:

* get a connection to the database
* drop the table
* create the table
* close the connection (whatever the result of the two last operations)

All these operations may fail. Unlike in the start method where the actions were unrelated, these actions are related. Fortunately, we can chain asynchronous action using the flatMap operator of RX Java 2.

```java
Single<X> chain = input.flatMap(function1);
```

So to use the composition pattern, we just need a set of Functions and a Single that would trigger the chain.

Look at the `initializeDatabase` method in the `AuditVerticle` class

Add the below content to the matching `// TODO: retrieveConnection` statement in the `initializeDatabase` method (or use the `Copy to Editor` button):

<pre class="file" data-filename="audit-service/src/main/java/io/vertx/workshop/audit/impl/AuditVerticle.java" data-target="insert" data-marker="// TODO: retrieveConnection">
Single&lt;SQLConnection&gt; connectionRetrieved = jdbc.rxGetConnection();
</pre>

Then, we need compose the Single with the flatMap operator that is taking a SQLConnection as parameter and returns a Single containing the result of the database initialization:

1. we create the batch to execute
2. the rxBatch executes the batch gives us the single returns of the operation
3. finally we close the connection with doAfterTerminate

So, insert into the matching `// TODO: executeBatch` statement in the `initializeDatabase` method

<pre class="file" data-filename="audit-service/src/main/java/io/vertx/workshop/audit/impl/AuditVerticle.java" data-target="insert" data-marker="// TODO: executeBatch">
return connectionRetrieved
    .flatMap(conn -> {
        // When the connection is retrieved

        // Prepare the batch
        List&lt;String&gt; batch = new ArrayList<>();
        if (drop) {
            // When the table is dropped, we recreate it
            batch.add(DROP_STATEMENT);
        }
        // Just create the table
        batch.add(CREATE_TABLE_STATEMENT);

        // We compose with a statement batch
        Single&lt;List&lt;Integer&gt;&gt; next = conn.rxBatch(batch);

        // Whatever the result, if the connection has been retrieved, close it
        return next.doAfterTerminate(conn::close);
    })
</pre>

The previous statement return a Single&lt;List&lt;Integer&gt;&gt; but we need a Single<JDBCClient>. Append .map(x → jdbc) and return the result:

So, insert into the matching `// TODO: returnResult` statement in the `initializeDatabase` method

<pre class="file" data-filename="audit-service/src/main/java/io/vertx/workshop/audit/impl/AuditVerticle.java" data-target="insert" data-marker="// TODO: returnResult">
.map(list -> client);
</pre>
