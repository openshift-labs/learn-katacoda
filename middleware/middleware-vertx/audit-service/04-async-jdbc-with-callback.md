## Async JDBC with a callback-based composition

You may ask why we do such kind of composition. Let’s implement a method without any composition operator (just using callbacks). The retrieveOperations method is called when a HTTP request arrives and should return a JSON object containing the last 10 operations. So, in other words:

1. Get a connection to the database
2. Query the database
3. Iterate over the result to get the list
4. Write the list in the HTTP response
5. Close the database

The step (1) and (2) are asynchronous. (5) is asynchronous too, but we don’t have to wait for the completion. In this code, don’t use composition (that’s the purpose of this exercise). In `retrieveOperations`, write the required code using Handlers / Callbacks.

Add the below content to the matching `// TODO: retrieveOperations` statement in the `retrieveOperations` method of the `AuditVerticle` class (or use the `Copy to Editor` button):

<pre class="file" data-filename="audit-service/src/main/java/io/vertx/workshop/audit/impl/AuditVerticle.java" data-target="insert" data-marker="// TODO: retrieveOperations">
 // 1. Get the connection
 jdbc.getConnection(ar -> {
     SQLConnection connection = ar.result();
     if (ar.failed()) {
         context.fail(ar.cause());
     } else {
         // 2. When done, execute the query
         connection.query(SELECT_STATEMENT, result -> {
             // 3. When done, iterate over the result to build a list
             ResultSet set = result.result();
             List&lt;JsonObject&gt; operations = set.getRows().stream()
                 .map(json -> new JsonObject(json.getString("operation")))
                 .collect(Collectors.toList());
             // 5. write this list into the response
             context.response().setStatusCode(200).end(Json.encodePrettily(operations));
             // 6. close the connection
             connection.close();
         });
     }
 });
</pre>

So obviously it’s possible too not use RX Java. But imagine when you have several asynchronous operations to chain, it become a callback hell very quickly. But again, Vert.x gives you the freedom to choose what you prefer.