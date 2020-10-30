In the previous step we added a process definition to our Kogito application that uses a Service Task node to call a CDI bean. In this step we will implement the CDI bean that calls our RESTful service.

# REST Client Dependencies

We first add the required dependencies to our pom.xml. Because we will use the `quarkus-rest-client`, we need to add its dependency to our POM.

Click the following command to add the dependencies to our project.

`mvn quarkus:add-extension -Dextensions=io.quarkus:quarkus-rest-client`{{execute T1}}

Open the `pom.xml` file and observe that the required dependencies have been added: `coffeeshop/pom.xml`{{open}}

### JAX-RS Client

Our Service Task node in our process will call the method `getCoffees` of a CDI bean called `CoffeeService`. Let's first create the skeleton of that bean.

Click the following command to create the package of the `CoffeeService` bean.

`mkdir -p /root/projects/kogito/coffeeshop/src/main/java/org/acme/service`{{execute T3}}

Click the following path to open a new `CoffeeService.java` file: `coffeeshop/src/main/java/org/acme/service/CoffeeService.java`{{open}}

Click _Copy to Editor_ to copy the source code into the new `CoffeeService.java`file.

<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/service/CoffeeService.java" data-target="replace">
package org.acme.service;

import java.util.Collection;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;

import org.acme.coffeeservice.client.CoffeeResource;
import org.acme.model.Coffee;

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

With the CDI bean skeleton implemented, we can focus on the domain model and the JAX-RS interface from which our rest client is generated.

Our domain model is simply the `Coffee` class that's also used by the CoffeeService we started in the first step. Click the following command to create a new package for our domain class.

`mkdir -p /root/projects/kogito/coffeeshop/src/main/java/org/acme/model`{{execute T3}}

Click the following path to create the `Coffee.java` file: `coffeeshop/src/main/java/org/acme/model/Coffee.java`{{open}}

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

With our domain model implemented, we can now implement the JAX-RS interface definition. This is actually the same JAX-RS interface definition that is used in the _CoffeeService_. The only difference is that we annotate this interface with the `@RegisterRestClient(configKey = "coffeeresource")` annotation to register it as a Rest client.

Click the following command to create the package force our Rest client.

`mkdir -p /root/projects/kogito/coffeeshop/src/main/java/org/acme/coffeeservice/client`{{execute T3}}

Click the following path to create the `CoffeeResource.java` interface: `coffeeshop/src/main/java/org/acme/coffeeservice/client/CoffeeResource.java`{{open}}

<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/coffeeservice/client/CoffeeResource.java" data-target="replace">
package org.acme.coffeeservice.client;

import java.util.Collection;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.acme.model.Coffee;

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

With our domain model and JAX-RS client interface defined, we can now add the logic to our CDI bean to use the JAX-RS client. Click the following path to re-open the `CoffeeService.java` class: `coffeeshop/src/main/java/org/acme/service/CoffeeService.java`{{open}}

First, we inject the `CoffeeResource` class into the service. Click _Copy to Editor_ to add the `CoffeeResource` attribute to our class (note that this attribute is _package-private_. This is recommended by Quarkus, as this enables Quarkus to do the injection without the need for reflection):

<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/service/CoffeeService.java" data-target="insert" data-marker="//Add RestClient attribute">
    CoffeeResource coffeeResource;
</pre>

Next, we add the annotations to this attribute to inject the REST client. We need two annotations. First we need the `@Inject` annotation, but because we want to inject the generated REST client project (generated from the JAX-RS interface we created earlier), we also need to add the `@RestClient` annotation. Click `Copy to Editor` to add the annotations.

<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/service/CoffeeService.java" data-target="insert" data-marker="//Add RestClient annotations">
    @Inject
    @RestClient
</pre>

Finally, we call our REST client to retrieve the list of coffees from our service. We add some logging to our application to show that our CDI is actually being called (just for demonstration purposes). Click `Copy to Editor` to add this logic to our service class.

<pre class="file" data-filename="./coffeeshop/src/main/java/org/acme/service/CoffeeService.java" data-target="insert" data-marker="return null;">
    System.out.println("Kogito calling our CoffeeService microservice!");
    return coffeeResource.getCoffees();
</pre>

# Configuring the REST client
With our code completed, we now only need to add some configuration options to our `application.properties` file to instruct our REST client which endpoint it needs to call.

Click the following path to open the `application.properties`: `coffeeshop/src/main/resources/application.properties`{{open}}

Click `Copy to Editor` to add the configuration of the REST client to the `application.properties` file.

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

Notice that we use the key `coffeeresource` to configure our client, and don't specify its full class name. This is possible because we defined this name as the `configKey` in `@RegisterRestClient` annotation on the JAX-RS interface.

# Starting the Application

With our code implemented, click the following command to start the application.

`mvn clean compile quarkus:dev`{{execute T1}}

This downloads the new dependencies and starts our application in Quarkus development mode.

## Testing the Application

Click the following command to send a request to our application.

`curl -X POST "http://localhost:8080/coffeeshop" -H "accept: application/json" -H "Content-Type: application/json" -d "{}"`{{execute T3}}

We see the following output in the console:

```console
[{"id":1,"name":"espresso-arabica","description":"arabica beans","price":2.0},{"id":2,"name":"espresso-robusta","description":"robusta beans","price":2.0},{"id":3,"name":"latte-arabica","description":"arabica beans, full fat bio milk","price":3.0}]
```

## Congratulations!

We've implemented the MicroProfile JAXRS Rest Client to integrate our Kogito application with another microservice over REST. Well done! In the next step we will change the implementation to use Apache Camel.
