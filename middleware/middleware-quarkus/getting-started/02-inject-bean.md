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
        return "hello";
    }
}
</pre>

## Inspect the results

Since we still have our app running using `mvn quarkus:dev`, when you make these changes and reload the endpoint, Quarkus will notice all of these changes and live reload them.

Check that it works as expected by loading the new endpoint by [clicking here](https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/hello/greeting/quarkus).

Note we are exercising our new bean using the `/hello/greeting` endpoint, and you should see

```console
hello quarkus from master
```

> In this case, `master` is the hostname of the local host we are running on. It will be different later on when deployed to OpenShift!

## Congratulations!

It's a familiar CDI-based environment for you Enterprise Java developers out there, with powerful mechanisms to reload your code _as you type_ (or very close to realtime). In the next step, we'll package and run it as a standalone executable JAR, which should also be familiar to microservice developers.
