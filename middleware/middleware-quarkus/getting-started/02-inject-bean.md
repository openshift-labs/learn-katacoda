In the previous step you created a basic RESTful Java application with Quarkus. In this step we'll add a custom bean that will use the _ArC_ extension which provides a CDI-based dependency injection [solution](https://quarkus.io/guides/cdi-reference.html) tailored for the Quarkus architecture.

## Add Custom Bean

Let’s modify the application and add a companion bean. Open a new file by clicking: `getting-started/src/main/java/org/acme/quickstart/GreetingService.java`{{open}}.

Next, click **Copy to Editor** to add the following code to this file:

<pre class="file" data-filename="./getting-started/src/main/java/org/acme/quickstart/GreetingService.java" data-target="replace">
package org.acme.quickstart;

import javax.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class GreetingService {

    private String hostname = System.getenv().getOrDefault("HOSTNAME", "unknown");

    public String greeting(String name) {
        return "hello " + name + " from " + hostname;
    }

}
</pre>

Next, open the `getting-started/src/main/java/org/acme/quickstart/GreetingResource.java`{{open}} class and then click **Copy To Editor** once again to inject the new bean and create a new endpoint using it:

<pre class="file" data-filename="./getting-started/src/main/java/org/acme/quickstart/GreetingResource.java" data-target="replace">
package org.acme.quickstart;

import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("/hello")
public class GreetingResource {

    @Inject
    GreetingService service;

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    @Path("/greeting/{name}")
    public String greeting(@PathParam("name") String name) {
        return service.greeting(name);
    }

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String hello() {
        return "Hello RESTEasy";
    }
}
</pre>

## Inspect the results

Since we still have our app running using `mvn quarkus:dev`, when you make these changes and reload the endpoint, Quarkus will notice all of these changes and live reload them.

Check that it works as expected by loading the new endpoint by [clicking here](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/hello/greeting/quarkus).

Note we are exercising our new bean using the `/hello/greeting` endpoint, and you should see

```console
hello quarkus from 4090f59d1a69
```

> In this case, `4090f59d1a69` is the hostname of the local host we are running on. It will be different for you!

## Add another test

Let's add another test for Quarkus to run continously for our new endpoint. Open a new file by clicking: `getting-started/src/test/java/org/acme/quickstart/GreetingServiceTest.java`{{open}}.

Next, click **Copy to Editor** to add the following code to this file:

<pre class="file" data-filename="./getting-started/src/test/java/org/acme/quickstart/GreetingServiceTest.java" data-target="replace">
package org.acme.quickstart;

import io.quarkus.test.junit.QuarkusTest;
import org.junit.jupiter.api.Test;

import java.util.UUID;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.startsWith;

@QuarkusTest
public class GreetingServiceTest {

    @Test
    public void testGreetingEndpoint() {
        String uuid = UUID.randomUUID().toString();
        given()
          .pathParam("name", uuid)
          .when().get("/hello/greeting/{name}")
          .then()
            .statusCode(200)
            .body(startsWith("hello " + uuid));
    }

}
</pre>

This test generates a random string (a UUID), and uses that to call into our new service, looking for the same random name in the returned value.

You should now see that both tests pass:

```
All 2 tests are passing (0 skipped), 1 tests were run in 429ms. Tests completed at 12:35:33 due to changes to GreetingServiceTest.class.
```
As you add more tests, Quarkus will simply continuously run them to produce the result in realtime.

## Congratulations!

It's a familiar CDI-based environment for you Enterprise Java developers out there, with powerful mechanisms to reload your code _as you type_ (or very close to realtime). In the next step, we'll package and run it as a standalone executable JAR, which should also be familiar to microservice developers.
