## Async service interface

To create an async RPC service, or event bus service, or service proxies, you first need a Java interface declaring the async methods. 

Open the ``io.vertx.workshop.portfolio.PortfolioService`` class by clicking the link:

``portfolio-service/src/main/java/io/vertx/workshop/portfolio/PortfolioService.java``{{open}}

The class is annotated with:

* ``ProxyGen`` - enables the event bus service proxy and server generation

* ``VertxGen`` - enables the creation of the proxy in the different language supported by Vert.x

Let’s have a look at the first method:

```java
void getPortfolio(Handler<AsyncResult<Portfolio>> resultHandler);
```

This method lets you retrieve a Portfolio object. This method is asynchronous and so has a Handler parameter receiving an AsyncResult<Portfolio>. The other methods follows the same pattern.

***NOTE***
You may have also noticed that the package has a package-info.java file. This file is required to enable the service proxy generation.

