In the previous step you added a process definition to your Kogito application that uses a Service Task node to call a CDI bean. In this step we will implement the CDI bean that calls our RESTful service.

### JAX-RS Client

Our Service Task node in our process will call the method `getCoffees` of a CDI bean called `CoffeeService`. Let's first create the skeleton of that bean.

First we need to create the package of the bean:

`mkdir -p /root/projects/kogito/coffeeshop/src/main/java/org/acme/service`{{execute T3}}

We can now open a new `CoffeeService.java` file in this package by clicking: `coffeeshop/src/main/java/org/acme/service/CoffeeService.java`{{open}}

Click on the _Copy to Editor_ link to copy the source code into the new `CoffeeService.java`file.

<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/service/CoffeeService.java" data-target="replace">
package org.acme.service;

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

First, we need to inject our `CoffeeResource` class into our service. So, we need to create add the following attribute to our class (not that this attribute is _package-private_. This is recommended by Quarkus, as this allows Quarkus to do the injection without the need for reflection):

<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/service/CoffeeService.java" data-target="insert" data-marker="//Add RestClient attribute">
    CoffeeResource coffeeResource;
</pre>

Next, we need to add the proper annotation to this attribute to inject our REST client. Here we need 2 annotations. First we need the `@Inject` annotation, but because we want to inject the generated REST client project (generated from the JAX-RS interface we created earlier), we also need to add the `@RestClient` annotation:

<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/service/CoffeeService.java" data-target="insert" data-marker="//Add RestClient annotations">
    @Inject
    @RestClient
</pre>

Finally, we need to call our REST client to retrieve the list of coffees from our service. We add some logging to our application to show that our CDI is actually being called (just for demonstration purposes):

<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/service/CoffeeService.java" data-target="insert" data-marker="return null();">
    System.out.println("Kogito calling our CoffeeService microservice!")
    return coffeeResource.getCoffees();
</pre>

# Configuring the REST client
With our code completed, we now only need to add some configuration options to our `application.properties` file to instruct our REST client which endpoint it needs to call.

First we need to open our `application.properties` file by clicking: `coffeeshop/src/main/resources/application.properties`{{open}}

We can now add the proper content:

<pre class="file" data-filename="./coffeeshop/src/main/resources/application.properties" data-target="replace">
#
# Copyright 2020 Red Hat, Inc. and/or its affiliates.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#https://quarkus.io/guides/openapi-swaggerui
quarkus.smallrye-openapi.path=/docs/openapi.json
quarkus.swagger-ui.always-include=true

kogito.service.url=http://localhost:8080

#CoffeeResource
coffeeresource/mp-rest/url=http://localhost:8090
coffeeresource/mp-rest/scope=javax.inject.Singleton
</pre>

Notice that we can use the key `coffeeresource` to configure our client, and don't need to specify its full class name. This because we defined this as the `configKey` in `@RegisterRestClient` annotation on our JAX-RS interface.

## Testing the Application

Because we've got our application running in Quarkus development mode, all our changes will be hot reloaded. So, we can simply hit our endpoint with the following request:

`curl -X POST "http://localhost:8080/coffeeprocess" -H "accept: application/json" -H "Content-Type: application/json" -d "{}"`{{execute T3}}

You should see the following output:

```console
[{"id":1,"name":"espresso-arabica","description":"arabica beans","price":2.0},{"id":2,"name":"espresso-robusta","description":"robusta beans","price":2.0},{"id":3,"name":"latte-arabica","description":"arabica beans, full fat bio milk","price":3.0}]
```

## Congratulations!

You've implemented the MicroProfile JAXRS Rest Client implementation to integrate your Kogito application with another microservice over REST. Well done! In the next step we will change the implementation to use Apache Camel.
