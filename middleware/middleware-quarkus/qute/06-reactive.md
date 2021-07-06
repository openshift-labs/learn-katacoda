# Reactive and Asynchronous APIs

Quarkus is _reactive_. If you look under the hood, you will find a reactive engine powering your Quarkus application. This engine is [Eclipse Vert.x](https://vertx.io). Every IO interaction passes through the non-blocking and reactive Vert.x engine. All the HTTP requests your application receives are handled by event loops (IO Thread) and then are routed towards the code that manages the request. Depending on the destination, it can invoke the code managing the request on a worker thread (Servlet, Jax-RS) or use the IO Thread (reactive route). [Mutiny](https://github.com/smallrye/smallrye-mutiny) is a reactive programming library allowing to express and compose asynchronous actions.

Qute Templates can be asynchronously rendered as a `CompletionStage<String>` (completed with the rendered output asynchronously) or as `Publisher<String>` containing the rendered chunks.

If these are returned in an REST endpoint, the endpoint will be processed asynchronously, saving compute resources by not creating many threads to handle requests. Let's compare both types by creating a traditional (blocking) endpoint, and an async endpoint.

Quarkus [Reactive routes](https://quarkus.io/guides/reactive-routes) propose an alternative approach to implement HTTP endpoints where you declare and chain routes. This approach became very popular in the JavaScript world, with frameworks like Express.Js or Hapi. Quarkus also offers the possibility to use reactive routes. You can implement REST API with routes only or combine them with JAX-RS resources and servlets.

## Create reactive Report Generator

You've already added the `quarkus-vertx-web` extension which gives us the ability to declare Reactive Routes.

Click `qute/src/main/java/org/acme/ReactiveResource.java`{{open}} to open a new file.

Click **Copy to Editor** to create create a reactive route that will process our Qute template:

<pre class="file" data-filename="./qute/src/main/java/org/acme/ReactiveResource.java" data-target="replace">
package org.acme;

import io.quarkus.qute.Template;
import io.quarkus.qute.Location;
import io.quarkus.vertx.web.Route;
import io.quarkus.vertx.web.RoutingExchange;
import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.ws.rs.core.MediaType;

@ApplicationScoped
public class ReactiveResource {

    @Inject
    SampleService service;

    @Location(&quot;reports/v1/report_01.json.template&quot;)
    Template report;

    @Route(path = &quot;/reactive&quot;, methods = Route.HttpMethod.GET, produces = MediaType.APPLICATION_JSON)
    void reactive(RoutingExchange ex) throws Exception {
        report
          .data(&quot;samples&quot;,service.get())
          .data(&quot;now&quot;, java.time.LocalDateTime.now())
          .renderAsync()
          .thenAccept((val) -&gt; ex.ok(val));
    }
}
</pre>

* The `@Route` annotation indicates that the method is a reactive route. Again, by default, the code contained in the method must not block.
* Note the use of the Qute `.renderAsync()` method - this method will be completed with the rendered template asynchronously.
* The method gets a `RoutingExchange` as a parameter. `RoutingExchange` is a convenient wrapper of `RoutingContext` which provides some useful methods. With `RoutingContext` you can retrieve the HTTP request (using `request()`) and write the response using `response().end(…​)`.

More details about using the RoutingContext is available in the [Vert.x Web documentation](https://vertx.io/docs/vertx-web/java/).

## Test endpoint

Make sure the endpoint generates a report. Click the following command to try it:

`curl http://localhost:8080/reactive`{{execute T2}}

You should see a random report of the samples from earlier, but done so with a _Reactive Route_.

To learn more about Quarkus and reactive programming, check out the [Reactive Programming with Quarkus Reactive SQL exercise](https://learn.openshift.com/middleware/courses/middleware-quarkus/reactive-sql).

# Wrap-up

Congratulations! Qute provides a powerful, flexible, type-safe and reactive way to render templates using ideas and mechanisms familiar to Java developers. To learn more about Qute, please refer to the [Qute reference guide](https://quarkus.io/guides/qute-reference).


