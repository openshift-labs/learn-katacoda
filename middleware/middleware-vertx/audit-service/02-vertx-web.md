##  Implementing a method returning a Single & Vert.x Web

Take a look at the `configureTheHTTPServer` method. In this method we are going to use a new Vert.x Component: Vert.x Web. Vert.x Web is a Vert.x extension to build modern web application. Here we are going to use a Router which let us implement REST APIs easily (à la Hapi or ExpressJS). So:

1. Create a `Router` object with: `Router.router(vertx)`
2. Register a route (on /) on the router, calling `retrieveOperations` (using ``router.get("/").handler(…​)``)
3. Create a HTTP server delegating the request handler to router.accept.
4. Retrieve the port passed in the configuration or 0 if not set (it picks an available port), we can pick a random port as it is exposed in the service record, so consumer are bound to the right port.
5. Start the server with the `rxListen` version of the listen method that returns a single.

In the same `io.vertx.workshop.audit.impl.AuditVerticle` class, add the below content to the matching `// TODO: configureTheHTTPServer` statement (or use the `Copy to Editor` button):

<pre class="file" data-filename="audit-service/src/main/java/io/vertx/workshop/audit/impl/AuditVerticle.java" data-target="insert" data-marker="// TODO: configureTheHTTPServer">
Router router = Router.router(vertx);
router.get("/").handler(this::retrieveOperations);
router.get("/health").handler(rc -> {
        if (ready) {
            rc.response().end("Ready");
        } else {
            // Service not yet available
            rc.response().setStatusCode(503).end();
        }
    });
return vertx.createHttpServer().requestHandler(router::accept).rxListen(8080);
</pre>

It creates a `Router`. The Router is an object from Vert.x web that ease the creation of REST API with Vert.x. We won’t go into too much details here, but if you want to implement REST API with Vert.x, this is the way to go. On our `Router` we declare a route: when a request arrive on `/`, it calls this `Handler`. Then, we create the HTTP server. The requestHandler is a specific method of the router, and we return the result of the `rxListen` method.

So, the caller can call this method and get a Single. It can subscribe on it to bind the server and be notified of the completion of the operation (or failure).

The audit service needs to orchestrate a set of task before being ready to serve. We should indicate this readiness state to Kubernetes so it can know when we are ready. This would let it implement a rolling update strategy without downtime as the previous version of the service will still be used until the new one is ready.

You may have notice that our class has a `ready` field set to true when we have completed our startup. In addition, our pom.xml has the `<vertx.health.path>/health</vertx.health.path>` property indicating a health check. It instructs Kubernetes to ping this endpoint to know when the application is ready. But, there is still one thing required: serving these request. Jump back to the configureTheHTTPServer method and add a route handling ``GET /health`` and returning a 200 response when the ``ready`` field is true, or a 503 response otherwise. Set the status code with: `rc.response().setStatusCode(200).end("Ready")` (and don’t forget to call end).

With this in place, during the deployment, you will see that the pod state stays a "long" time in the not ready state (light blue). When the readiness check succeed, Kubernetes starts routing request to this pod.