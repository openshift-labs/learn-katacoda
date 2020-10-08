In the previous step we've implemented a RESTful call from a Kogito process to a microservice using the MicroProfile JAX-RS Rest Client. In this step we will replace that implementation with an Apache Camel implementation. The advantage of Camel is that we can:

* Add additional logic to our integration using additional Camel functionality, e.g. marshalling, transformation, routing, error handling, etc.
* Use the vast array of Camel components to connect to virtually any other external system, e.g. Salesforce, Kafka, Twitter, Filesystems, etc.

# Stop the Application
Because we will add a number of Camel dependencies to our application, we must first stop our application.

In the first terminal, stop the application using `CTRL-C`.

# Camel Dependencies

We add the required dependencies to our pom.xml. Because we will use the `netty-http` Camel component, we add its dependency to our POM. We will also use `camel-direct` to call the Camel Route from our CDI bean, and `jackson` to support marshalling and unmarshalling in our route.

Click the following command to add the dependencies to our project:

`mvn quarkus:add-extension -Dextensions=org.apache.camel.quarkus:camel-quarkus-netty-http,org.apache.camel.quarkus:camel-quarkus-jackson,org.apache.camel.quarkus:camel-quarkus-direct`{{execute T1}}

Click the following path to open the `pom.xml` file and observe that the required dependencies have been added: `coffeeshop/pom.xml`{{open}}

### Camel RouteBuilder

We will now implement the Camel `RouteBuilder`. In the `RouteBuilder` we implement the Camel route that, in our case, will do a RESTful call to our CoffeeService microservice, and process the response.

Click the following command to create a new package in which we create our RouteBuilder:

`mkdir -p /root/projects/kogito/coffeeshop/src/main/java/org/acme/camel`{{execute T3}}

Click on the following path to create the `CoffeeRouteBuilder.java` file: `coffeeshop/src/main/java/org/acme/camel/CoffeeRouteBuilder.java`{{open}}

Click _Copy to Editor_ to implement the `CoffeeRouteBuilder`.

<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/camel/CoffeeRouteBuilder.java" data-target="replace">
package org.acme.camel;

import javax.enterprise.context.ApplicationScoped;
import javax.ws.rs.core.MediaType;

import org.acme.model.Coffee;

import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.component.jackson.JacksonDataFormat;
import org.apache.camel.component.jackson.ListJacksonDataFormat;

@ApplicationScoped
public class CoffeeRouteBuilder extends RouteBuilder {

    @Override
    public void configure() throws Exception {        

        JacksonDataFormat format = new ListJacksonDataFormat(Coffee.class);

        from("direct://getCoffees").log("Get Coffee Route Triggered: ${body}")
        .setHeader("Accept").constant(MediaType.APPLICATION_JSON)
        .setHeader("CamelHttpMethod").constant("GET")
        .to("netty-http:http://localhost:8090/coffee")
        .unmarshal(format);

    }

}
</pre>

The route is pretty simple. It accepts an exchange (message) from a "direct" endpoint (which allows us to call this endpoint from our CDI bean), it sets the required HTTP headers (`Accept`), it sets the HTTP method that we want to use, and uses the `netty-http` component to do a call to our CoffeeService. Finally, the response is unmarshalled into a `Collection` of `Coffee` instances using the `JacksonDataFormat` instance.

With our route implemented, we can change our `CoffeeService` implementation to use our Camel route. To do this, click _Copy to Editor_ to replace our old implementation with a new following skeleton implementation.

<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/service/CoffeeService.java" data-target="replace">
package org.acme.service;

import java.util.Collection;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;

import org.acme.coffeeservice.client.CoffeeResource;
import org.acme.model.Coffee;

import org.apache.camel.CamelContext;
import org.apache.camel.FluentProducerTemplate;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@ApplicationScoped
public class CoffeeService {

    private static final Logger LOGGER = LoggerFactory.getLogger(CoffeeService.class);

//Add CamelContext

//Add FluentProducerTemplate

//Add PostConstruct

//Add PreDestroy

    public Collection<Coffee> getCoffees() {
        LOGGER.debug("Retrieving coffees");
//Add Method Implementation
    }

}

</pre>


Click _Copy to Editor_ to copy the code snippet that injects the `CamelContext` into the service class:

<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/service/CoffeeService.java" data-target="insert" data-marker="//Add CamelContext">
    @Inject
    CamelContext camelContext;
</pre>

Click _Copy to Editor_ to add an attribute to our class to hold the `FluentProducerTemplate`.

<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/service/CoffeeService.java" data-target="insert" data-marker="//Add FluentProducerTemplate">
    private FluentProducerTemplate producer;
</pre>

Click _Copy to Editor_ to add the `@PostConstruct` method, in which the `FluentProducerTemplate` is initialized and its default endpoint is set:

<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/service/CoffeeService.java" data-target="insert" data-marker="//Add PostConstruct">
    @PostConstruct
    void init() {
       producer = camelContext.createFluentProducerTemplate();
       producer.setDefaultEndpointUri("direct://getCoffees");
    }
</pre>

Click _Copy to Editor_ to add the `@PreDestroy` method which cleans-up the `ProducerTemplate` resources when the bean is destroyed:

<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/service/CoffeeService.java" data-target="insert" data-marker="//Add PreDestroy">
    @PreDestroy
    void destroy() {
      producer.stop();
    }
</pre>

With all the plumbing in place, click _Copy to Editor_ to implement the method which calls the Camel route, which in its turn calls the microservice via REST:

<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/service/CoffeeService.java" data-target="insert" data-marker="//Add Method Implementation">
    return producer.request(Collection.class);
</pre>


# Starting the Application

Click on the following command to start the application again:

`mvn clean compile quarkus:dev`{{execute T1}}

This downloads the new dependencies and starts our application in Quarkus development mode.

## Testing the Application

Click on the following command to send a request to test our application.

`curl -X POST "http://localhost:8080/coffeeshop" -H "accept: application/json" -H "Content-Type: application/json" -d "{}"`{{execute T3}}

We should see the following output in the console:

```console
[{"id":1,"name":"espresso-arabica","description":"arabica beans","price":2.0},{"id":2,"name":"espresso-robusta","description":"robusta beans","price":2.0},{"id":3,"name":"latte-arabica","description":"arabica beans, full fat bio milk","price":3.0}]
```

## Congratulations!

We've implemented the integration with our CoffeeService using Apache Camel's `netty-http` component. Well done!
