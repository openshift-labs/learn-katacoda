## Verticle

As you may have noticed, the code is structured in 3 `verticles`, but what are these? Verticles is a way to structure Vert.x application code. It’s not mandatory, but it is quite convenient. A verticle is a chunk of code that is deployed on top of a Vert.x instance. A verticle has access to the instance of `vertx` on which it’s deployed, and can deploy other verticles.

**Understanding the Application**

Let's open the `GeneratorConfigVerticle` class by clicking on the link below and look at the `start` method

`quote-generator/src/main/java/io/vertx/workshop/quote/GeneratorConfigVerticle.java`{{open}}

This method retrieves the configuration, instantiates the verticles and publishes the services in the service discovery.

First, notice the method signature. It receives a Future object indicating that the start is asynchronous. Indeed, all the actions made in this method are asynchronous. So, when the caller thread reaches the end of the method, the actions may have not completed. We use this given Future to indicate when the process has completed (or failed).

The start method:

1. retrieves the configuration (giving the "fake" company settings)
2. deploys one verticle per defined company
3. deploys the RestQuoteAPIVerticle
4. exposes the market-data message source
5. notifies the given Future of the successful completion or failure

As you review the content, you will notice that there are 2 TODO comments. Do not remove them! These comments are used as a marker and without them, you will not be able to finish this scenario.

To retrieve the configuration the verticle needs a `ConfigRetriever`. This object allows retrieving configuration chunks from different stores (such as git, files, http, etc.). Here we just load the contents of the ``config.json`` file located in the src/kubernetes directory. The configuration is a JsonObject. Vert.x uses JSON heavily, so you are going to see a lot of JSON in this lab.

Once we have the retriever, we can retrieve the configuration. This is an asynchronous method (``rxGetConfig``) returning a Single (a stream containing one item). After the configuration is retrieved, we extract the companies array from it and deploy one verticle per defined company. The deployment is also asynchronous and done with ``rxDeployVerticle``. These company verticles simulate the value of the stocks. The quotes are sent on the event bus on the market address.

Add the below content to the matching `// TODO: MarketDataVerticle` statement (or use the `Copy to Editor` button):
      
<pre class="file" data-filename="src/main/java/io/vertx/workshop/quote/GeneratorConfigVerticle.java" data-target="insert" data-marker="// TODO: MarketDataVerticle">
.flatMapSingle(company -> vertx.rxDeployVerticle(MarketDataVerticle.class.getName(),
    new DeploymentOptions().setConfig(company)))
</pre>

When the company verticles are deployed, we deploy another verticle providing an HTTP API to access market data. 

Add the below content to the matching `// TODO: RestQuoteAPIVerticle` statement (or use the `Copy to Editor` button):

<pre class="file" data-filename="quote-generator/src/main/java/io/vertx/workshop/quote/GeneratorConfigVerticle.java" data-target="insert" data-marker="// TODO: RestQuoteAPIVerticle">
.flatMap(l -> vertx.rxDeployVerticle(RestQuoteAPIVerticle.class.getName()))
</pre>

The last part of the method is about the service discovery mentioned in the microservice section. This component generates quotes sent on the event bus. But to let other components discover where the messages are sent (where means on which address), it registers it. ``market-data`` is the name of the service, ``ADDRESS`` (a static final variable defined as market) is the event bus address on which the messages are sent.

```java
.flatMap(x -> discovery.rxPublish(MessageSource.createRecord("market-data", ADDRESS)))
```

Finally, when everything is done, we report the status on the given Future object. The failure management can be made at any stage, but generally, it’s done in the subscribe method:
                                                                                   
```java
object.rxAsync(param1, param2)
 // ....
 .subscribe((rec, err) -> {
     if (rec != null) {
         future.complete();
     } else {
         future.fail(err);
     }
 });
```

If you remember the architecture, the quote generator also provides an HTTP endpoint returning the last values of the quotes. Note that this service is not explicitly published in the service discovery. That’s because Kubernetes is taking care of this part. The Vert.x service discovery interacts with Kubernetes services, so all Kubernetes services can be retrieved by Vert.x