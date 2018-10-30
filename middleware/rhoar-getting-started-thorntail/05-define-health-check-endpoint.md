We are now ready to define the logic of our health check endpoint.

**1. Create empty Java class**

The logic will be put into a new Java class.

Click this link to create and open the file which will contain the new class: `src/main/java/com/example/HealthChecks.java`{{open}}

Methods in this new class will be annotated with
[MicroProfile's `@Health` annotation](https://microprofile.io/project/eclipse/microprofile-health),
indicating it should be used as a health check endpoint.

**2. Add logic**

Next, let's fill in the class by creating a new health check implementation which will be used by OpenShift to probe our services.

Click on **Copy To Editor** below to implement the logic.

<pre class="file" data-filename="./src/main/java/com/example/HealthChecks.java" data-target="replace">
package com.example;

import javax.enterprise.context.ApplicationScoped;

import org.eclipse.microprofile.health.Health;
import org.eclipse.microprofile.health.HealthCheck;
import org.eclipse.microprofile.health.HealthCheckResponse;

@Health
@ApplicationScoped
public class HealthChecks implements HealthCheck {

    public HealthCheckResponse call() {

        if (ApplicationConfig.IS_ALIVE.get()) {
            return HealthCheckResponse.named("server-state").up().build();
        } else {
            return HealthCheckResponse.named("server-state").down().build();
        }
    }
}
</pre>

The `call()` method will return the status of the service. For this example,
we are using a simple boolean flag `IS_ALIVE` which will control whether the application is able to take requests.
The method is annotated with MicroProfile's `@Health` annotation, which directs Thorntail to expose
this endpoint as a health check at `/health`.

With our new health check in place, we'll need to build and deploy the updated application in the next step.
