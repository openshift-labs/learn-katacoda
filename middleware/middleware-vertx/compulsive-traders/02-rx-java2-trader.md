## The RX Java 2 trader

In this task, we re-implement the very same logic but using a different programming style. We are going to use Rx Java 2. 

Open the `io.vertx.workshop.trader.impl.RXCompulsiveTraderVerticle` class. 

`compulsive-traders/src/main/java/io/vertx/workshop/trader/impl/RXCompulsiveTraderVerticle.java`{{open}}

Complete the code following the TODO items. Use the zip operator to combine the two Singles. When both are completed, attach the message handler to the MessageConsumer and execute the trading logic on each received event. Don’t forget the subscription part(s).

Copy the following to `// TODO 1`
<pre class="file" data-filename="compulsive-traders/src/main/java/io/vertx/workshop/trader/impl/RXCompulsiveTraderVerticle.java" data-target="insert" data-marker="// TODO 1">
retrieveThePortfolioService.zipWith(retrieveTheMarket, (ps, consumer) -> {
</pre>

Copy the following to `// TODO 2`
<pre class="file" data-filename="compulsive-traders/src/main/java/io/vertx/workshop/trader/impl/RXCompulsiveTraderVerticle.java" data-target="insert" data-marker="// TODO 2">
consumer.handler(message ->
</pre>

Copy the following to `// TODO 3`
<pre class="file" data-filename="compulsive-traders/src/main/java/io/vertx/workshop/trader/impl/RXCompulsiveTraderVerticle.java" data-target="insert" data-marker="// TODO 3">
    TraderUtils.dumbTradingLogic(company, numberOfShares, ps, message.body()).subscribe());
    return true;
})
</pre>

Copy the following to `// TODO 4`
<pre class="file" data-filename="compulsive-traders/src/main/java/io/vertx/workshop/trader/impl/RXCompulsiveTraderVerticle.java" data-target="insert" data-marker="// TODO 4">
.toCompletable()
.subscribe(CompletableHelper.toObserver(future));
</pre>

