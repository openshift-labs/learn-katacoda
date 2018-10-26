# Implementing Health Checks

Now that our project has been deployed to OpenShift and we've verified that we're able to hit our endpoint, it's time to add a health check to the application.

**1. View Health Checks**

Our application is now up and running on OpenShift and accessible to all users. However how do we handle an application failure? Without constantly manually veriifying the application there would be no way to know when the application crashes. Luckily OpenShift can handle this issue by using probes.

There are two types of probes that we can create; a `liveness probe` and a `readiness probe`. Liveness probes are used to check if the container is still running. Readiness probes are used to determine if containers are ready to service requests. We're going to be creating a health check, which is a liveness probe that we'll use to keep track of our application health.

Our health check will continually poll the application to ensure that the application is up and healthy. If the check fails, OpenShift will be alerted and will restart the container and spin up a brand new instance. You can read more about the specifics [here](https://docs.openshift.org/latest/dev_guide/application_health.html).

Since a lack of health checks can cause container issues if they crash, OpenShift will alert you with a warning message if your project is lacking one. 

Click on Applications => Deployment and then select your deployment. You should see something like this: 

![Application Deployment](/openshift/assets/middleware/rhoar-monitoring/applicationDeployment.png)

Click on `Configuration` and we can see the warning message here:

![Missing Health Checks](/openshift/assets/middleware/rhoar-monitoring/missingHealthChecks.png)


Since we have a Spring Boot application we have an easy option for implementation of health checks. We're able to pull in the `Spring Actuator` library.

**2. Add Health Checks with Actuator**

Spring Actuator is a project which exposes health data under the API path `/health` that is collected during application runtime automatically. All we need to do to enable this feature is to add the following dependency to ``pom.xml``{{open}} at the **TODO** comment..

<pre class="file" data-filename="pom.xml" data-target="insert" data-marker="<!-- TODO: Add Actuator dependency here -->">
    &lt;dependency&gt;
      &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
      &lt;artifactId&gt;spring-boot-starter-actuator&lt;/artifactId&gt;
    &lt;/dependency&gt;
</pre>

Notice how the error message from before is no longer present in Applications => Deployment => Your App => Configuration. This is because of the dependency that we just added to ourt `pom.xml`. Adding this dependency triggers fabric8 to create Readiness/Liveness probes for OpenShift. These probes will periodically query the new health endpoints to make sure the app is still up.

Run the following command again to re-deploy the application to OpenShift:

``mvn package fabric8:deploy -Popenshift``{{execute}}

Now that we've added Spring Actuator, we're able to hit their provided `/health` endpoint. We can navigate to it by either adding `/health` to our landing page, or by clicking [here](http://rhoar-training-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/health) 

We should now see the following response, confirming that our application is up and running properly:

```json 
{"status":"UP"}
```

OpenShift will now continuously poll this endpoint to determine if any action is required to maintain the health of our container.

**3.Other Spring Actuator endpoints for monitoring**

The `/health` endpoint isn't the only endpoint that Spring Actuator provides out of the box. We're going to take a closer look at a few of the different endpoints so we can see how they help us with monitoring our newly deployed application, specifically the `/metrics` and `/beans` endpoints. A list of all other Spring Actuator endpoints can be found [here](https://docs.spring.io/spring-boot/docs/current/reference/html/production-ready-endpoints.html).

Unlike the `/health` endpoint some of these endpoints can return sensitive information and require authentication. For simplicity purposes we will be removing this security requirement in order to hit the endpoints, but this is not recommended for a production environment with sensitive data. Pull up the application.properties file ``src/main/resources/application.properties``{{open}} and add this code to disable endpoint security.

<pre class="file" data-filename="src/main/resources/application.properties" data-target="insert" data-marker="# TODO: Add Security preference here">
management.security.enabled=false
</pre>

If we redeploy the application again with: 

``mvn package fabric8:deploy -Popenshift``{{execute}} 

We can hit the `/health` endpoint again [here](http://rhoar-training-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/health) and we'll notice some differences. Since we've removed the security we should be getting a new response with much more content that looks something like:

```json
{"status":"UP","diskSpace":{"status":"UP","total":10725883904,"free":10131124224,"threshold":10485760}}
```

Navigating to the `/metrics` endpoint [here](http://rhoar-training-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/metrics) will display different types of metric data about the application including memory usage, heap, processors, threads, classes loaded, and some HTTP metrics in a response that looks like:

```json
{"mem":429321,"mem.free":306191,"processors":4,"instance.uptime":49984,"uptime":55113,"systemload.average":0.45,"heap.committed":372224,"heap.init":63488,"heap.used":66032,"heap":899584,"nonheap.committed":59328,"nonheap.init":2496,"nonheap.used":57098,"nonheap":0,"threads.peak":26,"threads.daemon":22,"threads.totalStarted":31,"threads":24,"classes":6994,"classes.loaded":6994,"classes.unloaded":0,"gc.ps_scavenge.count":14,"gc.ps_scavenge.time":141,"gc.ps_marksweep.count":2,"gc.ps_marksweep.time":130,"httpsessions.max":-1,"httpsessions.active":0,"gauge.response.health":2.0,"counter.status.200.health":5}
```

In addition to the different monitoring endpoints we also have informational endpoints like the `/beans` endpoint [here](http://rhoar-training-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/beans), which will show all of the configured beans in the application. Spring Actuator provides multiple informational endpoints on top of the monitoring endpoints that can prove useful for information gathering about your deployed Spring application and can be helpful while debugging your applications in OpenShift.

## Congratulations

You have now included a health check in your Spring Boot application that's living in the OpenShift Container Platform. In the next step, we're going to add some base logging that will help us when debugging our application.
