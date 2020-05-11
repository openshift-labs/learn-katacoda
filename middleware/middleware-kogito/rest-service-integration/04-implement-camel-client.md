In the previous step you implemented a RESTful call from a Kogito process to a microservice using the MicroProfile JAX-RS Rest Client. In this step we will replace that implementation with an Apache Camel implementation. The advantage of Camel is that we can:

* Add additional logic to our integration using additional Camel functionality, e.g. marshalling, transformation, routing, error handling, etc.
* Use the vast array of Camel components to connect to virtually any other external system, e.g. Salesforce, Kafka, Twitter, Filesystems, etc.

# Stop the Application
Because we will be adding a number of Camel dependencies to our application, we will first stop our application.

In the first terminal, stop the application using `CTRL-C`.


# Camel Dependencies

We first need to add the required dependencies to our pom.xml. Because we will be using the `netty-http` Camel component, we need to add its dependency to our POM. We will also be using `camel-direct` to call the Camel Route from our CDI bean, and `jackson` to support marshalling and unmarshalling in our route.

We can add the dependencies using the following Maven command:

`mvn quarkus:add-extension -Dextensions=org.apache.camel.quarkus:camel-quarkus-netty-http,org.apache.camel.quarkus:camel-quarkus-jackson,org.apache.camel.quarkus:camel-quarkus-direct`{{execute T1}}

Open the `pom.xml` file and observe the the required dependencies have been added: `coffeeshop/pom.xml`{{open}}

### Camel RouteBuilder

We can now implement the Camel `RouteBuilder`. In the `RouteBuilder` we implement the Camel route that, in our case, will do a RESTful call to our CoffeeService microservice, and process the response.

To implement the RouteBuilder, we first need to create a new package in our application:

`mkdir -p /root/projects/kogito/coffeeshop/src/main/java/org/acme/camel`{{execute T3}}

Next we can create our `Coffee.java` file in this package by clicking: `coffeeshop/src/main/java/org/acme/camel/CoffeeRouteBuilder.java`{{open}}

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

With our route implemented, we can now change our `CoffeeService` implementation to use our Camel route. To do this, we first replace our old implementation with the following skeleton implementation:


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

    //Doesn't seem to work in Quarkus
    //@EndpointInject("direct://getCoffees")
    //private ProducerTemplate producer;

//Add CamelContext

//Add FluentProducerTemplate

//Add PostConstruct

//Add PreDestroy

    public Collection<Coffee> getCoffees() {
        LOGGER.debug("Retrieving coffees")
//Add Method Implementation
    }

}

</pre>


First we need to inject the `CamelContext`, from which we can create our Camel `FluentProducerTemplate`:

<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/service/CoffeeService.java" data-target="insert" data-marker="//Add CamelContext">
    @Inject
    CamelContext camelContext;CoffeeResource coffeeResource;
</pre>

We add an attribute to our class to hold the `FluentProducerTemplate`:

<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/service/CoffeeService.java" data-target="insert" data-marker="//Add FluentProducerTemplate">
    private FluentProducerTemplate producer;
</pre>

Using an `@PostConstruct` method, we initialize the `FluentProducerTemplate` and set its default endpoint:

<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/service/CoffeeService.java" data-target="insert" data-marker="//Add PostConstruct">
    @PostConstruct
    void init() {
       producer = camelContext.createFluentProducerTemplate();
       producer.setDefaultEndpointUri("direct://getCoffees");
    }
</pre>

And we use an `@PreDestroy` method to clean-up the `ProducerTemplate` resources when our bean is destroyed:

<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/service/CoffeeService.java" data-target="insert" data-marker="//Add PreDestroy">
    @PreDestroy
    void destroy() {
      producer.stop();
    }
</pre>

With all the plumbing in place, we can now implement the method that will call the Camel route, which in its turn will call our microservice via REST:

<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/service/CoffeeService.java" data-target="insert" data-marker="//Add Method Implementation">
    return producer.request(Collection.class);
</pre>


# Starting the Application

With our code implemented, we can now start our application again:

`mvn clean compile quarkus:dev`{{execute T1}}

This will download the new dependencies and start our application in Quarkus development mode.

## Testing the Application

We can now test our application again with the following request:

`curl -X POST "http://localhost:8080/coffeeprocess" -H "accept: application/json" -H "Content-Type: application/json" -d "{}"`{{execute T3}}

You should see the following output:

```console
[{"id":1,"name":"espresso-arabica","description":"arabica beans","price":2.0},{"id":2,"name":"espresso-robusta","description":"robusta beans","price":2.0},{"id":3,"name":"latte-arabica","description":"arabica beans, full fat bio milk","price":3.0}]
```

## Congratulations!

You've implemented the integration with our CoffeeService using Apache Camel's `netty-http` component. Well done!
