## Implementing the service

It’s time to implement our async service interface. We are going to implement three methods in this service:

* `getPortfolio` to understand how to create AsyncResult objects

* `sendActionOnTheEventBus` to see how to send messages on the event bus

* `evaluate` computing the current value of the portfolio

**1. Creating AsyncResult instances**

As we have seen above, our async service has a `Handler<AsyncResult<Portfolio>>` parameter. So when we implement this service, we would need to call the `Handler` with an instance of `AsyncResult`. To see how this works, let’s implement the `getPortfolio` method:

In `io.vertx.workshop.portfolio.impl.PortfolioServiceImpl`, fill the `getPortfolio` method. It should call the `handle` method of the `resultHandler` with a successful async result. This object can be created from the (Vert.x) `Future` method.

Open the file in the editor: 

`portfolio-service/src/main/java/io/vertx/workshop/portfolio/impl/PortfolioServiceImpl.java`{{open}}

Then, copy the below content to the matching `// TODO: getPortfolio` statement (or use the `Copy to Editor` button):

<pre class="file" data-filename="portfolio-service/src/main/java/io/vertx/workshop/portfolio/impl/PortfolioServiceImpl.java" data-target="insert" data-marker="// TODO: getPortfolio">
resultHandler.handle(Future.succeededFuture(portfolio));
</pre>

Let’s dissect it:

* resultHandler.handle : this invokes the Handler. Handler<X> has a single method (handle(X)).
* Future.succeededFuture : this is how we create an instance of AsyncResult denoting a success. The passed value is the result (portfolio)

What is the relationship between `AsyncResult` and `Future`? A `Future` represents the result of an action that may, or may not, have occurred yet. The result may be null if the `Future` is used to detect the completion of an operation. The operation behind a `Future` object may succeed or fail. `AsyncResult` is a structure describing the success of the failure of an operation. So, `Future` are `AsyncResult`. In Vert.x `AsyncResult` instances are created from the `Future` class.

`AsyncResult` describes:

* a success as shown before, it encapsulates the result
* a failure, it encapsulates a `Throwable` instance

So, how does this work with our async RPC service, let’s look at this sequence diagram:

![Architecture](/openshift/assets/middleware/rhoar-getting-started-vertx/portfolio-sequence.png)

**2. Sending an event on the event bus**
It’s time to see how to send messages on the event bus. You access the event bus using vertx.eventBus(). From this object you can:

* `send` : send a message in point to point mode
* `publish` : broadcast a message to all consumers registered on the address
* `send` with a `Handler<AsyncResult<Message>>>`: send a message in point to point mode and expect a reply. If you use RX Java, this method is called `rxSend` and returns a `Single<Message>`. If the receiver does not reply to the message, it is considered a failure (timeout)

In our code, We have provided the `buy` and `sell` methods, that are just doing some checks before buying or selling shares. Once the action is emitted, we send a message on the event bus that will be consumed by the `Audit Service` and the `Dashboard`. So, we are going to use the `publish` method.

Write the body of the `sendActionOnTheEventBus` method in order to publish a message on the `EVENT_ADDRESS` address containing a `JsonObject` as body. This object must contains the following entries:
* action → the action (buy or sell)
* quote → the quote as Json
* date → a date (long in milliseconds)
* amount → the amount
* owned → the updated (owned) amount

Copy the following to the matching `// TODO: sendActionOnTheEventBus` statement

<pre class="file" data-filename="portfolio-service/src/main/java/io/vertx/workshop/portfolio/impl/PortfolioServiceImpl.java" data-target="insert" data-marker="// TODO: sendActionOnTheEventBus">
vertx.eventBus().publish(EVENT_ADDRESS, new JsonObject()
    .put("action", action)
    .put("quote", quote)
    .put("date", System.currentTimeMillis())
    .put("amount", amount)
    .put("owned", newAmount));
</pre>

Let’s have a deeper look:

* It gets the `EventBus` instance and call `publish` on it. The first parameter is the address on which the message is sent
* The body is a `JsonObject` containing the different information on the action (buy or sell, the quote (another json object), the date…​

**3. Coordinating async methods and consuming HTTP endpoints - Portfolio value evaluation**

The last method to implement is the `evaluate` method. This method computes the current value of the portfolio. However, for this it needs to access the "current" value of the stock (so the last quote). It is going to consume the HTTP endpoint we have implemented in the quote generator. For this, we are going to:

* Discover the service
* Call the service for each company we own some shares
* When all calls are done, compute the value and send it back to the caller

Let’s do it step by step. First, in the evaluate, we need to retrieve the HTTP endpoint (service) provided by the quote generator. This service is named quotes. We published in in the previous section. So, let’s start to get this service.

Fill the evaluate method to retrieve the quotes service. You can retrieve Http services using HttpEndpoint.getClient. The name of the service is quotes. If you can’t retrieve the service, just passed a failed async result to the handler. Otherwise, call computeEvaluation.

Copy the following to the matching `// TODO: evaluate` statement in the evaluate method

<pre class="file" data-filename="portfolio-service/src/main/java/io/vertx/workshop/portfolio/impl/PortfolioServiceImpl.java" data-target="insert" data-marker="// TODO: evaluate">
quotes.subscribe((client, err) -> {
 if (err != null) {
     resultHandler.handle(Future.failedFuture(err));
 } else {
     computeEvaluation(client, resultHandler);
 }
});
</pre>

* Get the HTTP Client for the requested service.
* The client cannot be retrieved (service not found), report the failure
* We have the client, let’s continue…​

Here is how the `computeEvaluation` method is implemented:

```java
private void computeEvaluation(HttpClient httpClient, Handler<AsyncResult<Double>> resultHandler) {
    // We need to call the service for each company we own shares
    List<Future> results = portfolio.getShares().entrySet().stream()
        .map(entry -> getValueForCompany(httpClient, entry.getKey(), entry.getValue()))    
        .collect(Collectors.toList());


    // We need to return only when we have all results, for this we create a composite future.
    // The set handler is called when all the futures has been assigned.
    CompositeFuture.all(results).setHandler(                                            
      ar -> {
        double sum = results.stream().mapToDouble(fut -> (double) fut.result()).sum();  
        resultHandler.handle(Future.succeededFuture(sum));                              
    });
}
```

Now, we just need the `getValueForCompany` method that call the service. Write the content of this method. 

This method returns a Single<Double> emitting the numberOfShares * bid result. Write the content of this method following these steps:

1. use the client.get("/?name=" + encode(company)) to create a HTTP request
2. we expect a JSON object as response payload, so use .as(BodyCodec.jsonObject())
3. use the rxSend method to create a Single containing the result
4. we now need to extract the "bid" from the returned JSON. Extract the response body and then extract the "bid" entry (json.getDouble("bid")). Both extraction are orchestrated using map.
5. compute the amount (bid * numberOfShared)
6. Done!

Copy the following to the matching `// TODO: getValueForCompany` statement in the getValueForCompany method 

<pre class="file" data-filename="portfolio-service/src/main/java/io/vertx/workshop/portfolio/impl/PortfolioServiceImpl.java" data-target="insert" data-marker="// TODO: getValueForCompany">
 return client.get("/?name=" + encode(company))
     .as(BodyCodec.jsonObject())
     .rxSend()
     .map(HttpResponse::body)
     .map(json -> json.getDouble("bid"))
     .map(val -> val * numberOfShares);                              
</pre>