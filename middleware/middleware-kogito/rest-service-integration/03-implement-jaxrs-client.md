In the previous step you added a process definition to your Kogito application that uses a Service Task node to call a CDI bean. In this step we will implement the CDI bean that calls our RESTful service.

### JAX-RS Client

Our Service Task node in our process will call the method `getCoffees` of a CDI bean called `CoffeeService`. Let's first create the skeleton of that bean.

First we need to create the package of the bean:

`mkdir -p /root/projects/kogito/coffeeshop/src/main/java/org/acme/service`{{execute T3}}

We can now open a new `CoffeeService.java` file in this package by clicking: `coffeeshop/src/main/java/org/acme/service/CoffeeService.java`{{open}}

Click on the _Copy to Editor_ link to copy the source code into the new `CoffeeService.java`file.

<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/service/CoffeeService.java" data-target="replace">
package com.redhat.service;

import java.util.Collection;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;

import com.redhat.coffeeservice.client.CoffeeResource;
import com.redhat.model.Coffee;

import org.eclipse.microprofile.rest.client.inject.RestClient;

@ApplicationScoped
public class CoffeeService {

//Add RestClient annotations
//Add RestClient attribute

    public Collection&lt;Coffee&gt; getCoffees() {
      return null;
    }

}
</pre>

With our CDI bean skeleton implemented, we will first focus on the domain model and the JAX-RS interface from which we will generate our client.

Our domain model is simply the `Coffee` class that's also used by the CoffeeService we started in the first step. To add this domain model class, we first need to create the required package:

`mkdir -p /root/projects/kogito/coffeeshop/src/main/java/org/acme/model`{{execute T3}}

Next we can create our `Coffee.java` file in this package by clicking: `coffeeshop/src/main/java/org/acme/model/Coffee.java`{{open}}

<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/model/Coffee.java" data-target="replace">
package org.acme.model;

public class Coffee {

    private long id;

    private String name;

    private String description;

    private double price;

    public Coffee() {
    }

    public Coffee(final long id, final String name, final String description, final double price) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.price = price;
    }

    public long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public double getPrice() {
        return price;
    }

}
</pre>

With our domain model implemented, we can now implement our JAX-RS interface definition. This is actually the same JAX-RS interface definition that is used in the _CoffeeService_. The only difference is that we annotate this interface with the `@RegisterRestClient(configKey = "coffeeresource")` annotation to register it as a Rest client.

We first need to create the package in which we will create our Rest client:

`mkdir -p /root/projects/kogito/coffeeshop/src/main/java/org/acme/coffeeservice/client`{{execute T3}}

Next we can create our `CoffeeResource.java` interface in this package by clicking: `coffeeshop/src/main/java/org/acme/coffeeservice/client/CoffeeResource.java`{{open}}

<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/coffeeservice/client/CoffeeResource.java" data-target="replace">
package org.acme.coffeeservice.client;

import java.util.Collection;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import com.redhat.model.Coffee;

import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;

@RegisterRestClient(configKey = "coffeeresource")
@Path("/coffee")
public interface CoffeeResource {

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Collection<Coffee> getCoffees();

    @GET
    @Path("/{name}")
    @Produces(MediaType.APPLICATION_JSON)
    public Coffee getCoffee(@PathParam("name") String name);

}
</pre>

We now have both our domain model and JAX-RS client interface defined. We can now add the logic to our CDI bean to use the JAX-RS client.



//Add RestClient annotations
//Add RestClient attribute

<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/service/CoffeeService.java" data-target="insert" data-marker="//Add RestClient attribute">
    CoffeeResource coffeeResource;
</pre>



<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/service/CoffeeService.java" data-target="insert" data-marker="//Add RestClient annotations">
    @Inject
    @RestClient
</pre>


<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/service/CoffeeService.java" data-target="insert" data-marker="return null();">
    return coffeeResource.getCoffees();
</pre>







## Cleanup



## Congratulations!

You've implemented the MicroProfile JAXRS Rest Client implementation to integrate your Kogito application with another microservice over REST. Well done! In the next step we will change the implementation to use Apache Camel.
