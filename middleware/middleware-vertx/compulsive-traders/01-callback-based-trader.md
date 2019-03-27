## The callback-based trader

Let’s start with the callback trader. This trader is developed using the raw Vert.x API and so callbacks. To ease the readability of the code, we are going to use Vert.x `Future`. A `Future` is a structure encapsulating a deferred result (or failure). Unlike regular Java Future, Vert.x `Futures` are non-blocking (no `get` and `join` methods). You needs to listen for the `Future` completion by attaching a `Handler` indicating the result (success or failure). `Futures` provide a nice and simple way to structure your code, but that’s not all. It also provides high-level operators such as `CompositeFuture.all` indicating the completion of a set of Futures.

Future objects are created using Future.future(). To be notified of the completion, you need to attach a Handler<AsyncResult>> using the Future.setHandler method.

Open the `io.vertx.workshop.trader.impl.CallbackTraderVerticle` class and fill in the code to complete TODOs 1 and 2.

`compulsive-traders/src/main/java/io/vertx/workshop/trader/impl/CallbackTraderVerticle.java`{{open}} 

The trader needs the Portfolio service and the market service (the message source sending the market data). We cannot start the trading logic before having retrieved both of them. Use a CompositeFuture to be notified when both are completed (or one fails). A CompositeFuture is a Future, so attach a Handler to it that call the initialize method.

<pre class="file" data-filename="compulsive-traders/src/main/java/io/vertx/workshop/trader/impl/CallbackTraderVerticle.java" data-target="insert" data-marker="// TODO 1">
Future&lt;PortfolioService&gt; retrieveThePortfolioService = getPortfolioService(discovery.result());
Future&lt;MessageConsumer&lt;JsonObject&gt;&gt; retrieveTheMarket = getMarketSource(discovery.result());
</pre>

<pre class="file" data-filename="compulsive-traders/src/main/java/io/vertx/workshop/trader/impl/CallbackTraderVerticle.java" data-target="insert" data-marker="// TODO 2">
CompositeFuture.all(retrieveServiceDiscovery, retrieveTheMarket)
    .setHandler(x ->
        initialize(done, company, numberOfShares, retrieveThePortfolioService, retrieveTheMarket, x));
</pre>