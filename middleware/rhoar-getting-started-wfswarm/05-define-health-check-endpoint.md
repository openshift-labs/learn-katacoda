We are now ready to define the logic of our health check endpoint.

**1. Create empty file and open it**

Click here to create the new file: `touch src/main/java/com/example/HealthChecks.java`{{execute}}

Now open the file: `src/main/java/com/example/HealthChecks.java`{{open}}

**2. Add logic**

Next, let's fill in the class by creating a new RESTful endpoint which will be used by OpenShift to probe our services.

Click on **Copy To Editor** below to implement the logic.

<pre class="file" data-filename="./src/main/java/com/example/HealthChecks.java" data-target="replace">
package com.example;

import javax.ws.rs.GET;
import javax.ws.rs.Path;

import org.wildfly.swarm.health.Health;
import org.wildfly.swarm.health.HealthStatus;

@Path("/service")
public class HealthChecks {

    @GET
    @Health
    @Path("/health")
    public HealthStatus check() {

        if (ApplicationConfig.IS_ALIVE.get()) {
            return HealthStatus.named("server-state").up();
        } else {
            return HealthStatus.named("server-state").down();
        }
    }
}

</pre>

The `check()` method exposes an HTTP GET endpoint which will return the status of the service. For this example,
we are using a simple boolean flag `IS_ALIVE` which will control whether the application is able to take requests.
The method is annotated with WildFly Swarm's `@Health` annotation, which directs WildFly Swarm to expose
this endpoint as a health check at `/health`.

With our new health check in place, we'll need to build and deploy the updated application in the next step.
