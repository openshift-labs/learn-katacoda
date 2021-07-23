# Implementing Health Checks

Now that our project has been deployed to OpenShift and we've verified that we're able to hit our endpoint, it's time to add a health check to the application.

**1. View Health Checks**

Our application is now up and running on OpenShift and accessible to all users. However how do we handle an application failure? Without constantly manually veriifying the application there would be no way to know when the application crashes. Luckily OpenShift can handle this issue by using probes.

There are two types of probes that we can create; a `liveness probe` and a `readiness probe`. Liveness probes are used to check if the container is still running. Readiness probes are used to determine if containers are ready to service requests. We're going to be creating a health check, which is a liveness probe that we'll use to keep track of our application health.

Our health check will continually poll the application to ensure that the application is up and healthy. If the check fails, OpenShift will be alerted and will restart the container and spin up a brand new instance. You can read more about the specifics [here](https://docs.openshift.com/container-platform/4.7/applications/application-health.html).

Since a lack of health checks can cause container issues if they crash, OpenShift will alert you with a warning message if your project is lacking one. 

Switch to the 'developer' perspective and from the _Topology_ tab of your project _dev_, select your deployment. You should see something like this:

![Missing Health Checks](/openshift/assets/middleware/rhoar-monitoring/healthChecks.png)


Since we have a Spring Boot application we have an easy option for implementation of health checks. We're able to pull in the `Spring Actuator` library.

**2. Add Health Checks with Actuator**

Spring Actuator is a project which exposes health data under the API path `/actuator/health` that is collected during application runtime automatically. All we need to do to enable this feature is to add the following dependency to ``pom.xml``{{open}} at the **TODO** comment..

<pre class="file" data-filename="pom.xml" data-target="insert" data-marker="<!-- TODO: Add Actuator dependency here -->">
    &lt;dependency&gt;
      &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
      &lt;artifactId&gt;spring-boot-starter-actuator&lt;/artifactId&gt;
    &lt;/dependency&gt;
</pre>

Notice how the previous warning message from before regarding missing health checks is no longer present. This is because of the dependency that we just added to ourt `pom.xml`. Adding this dependency triggers jkube to create Readiness/Liveness probes for OpenShift. These probes will periodically query the new health endpoints to make sure the app is still up.

Run the following command again to re-deploy the application to OpenShift:

``mvn package oc:deploy -Popenshift -DskipTests``{{execute}}

Now that we've added Spring Actuator, we're able to hit their provided `/actuator/health` endpoint. We can navigate to it by either adding `/actuator/health` to our landing page, or by clicking [here](http://spring-monitoring-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/actuator/health) 

We should now see the following response, confirming that our application is up and running properly:

```json 
{"status":"UP"}
```

OpenShift will now continuously poll this endpoint to determine if any action is required to maintain the health of our container.

**3.Other Spring Actuator endpoints for monitoring**

The `/actuator/health` endpoint isn't the only endpoint that Spring Actuator provides out of the box. We're going to take a closer look at a few of the different endpoints so we can see how they help us with monitoring our newly deployed application, specifically the `/metrics` and `/beans` endpoints. A list of all other Spring Actuator endpoints can be found [here](https://docs.spring.io/spring-boot/docs/current/reference/html/production-ready-endpoints.html).

Unlike the `/actuator/health` endpoint some of these endpoints can return sensitive information and require authentication. For simplicity purposes we will be removing this security requirement in order to hit the endpoints, but this is not recommended for a production environment with sensitive data. Pull up the application.properties file ``src/main/resources/application.properties``{{open}} and add this code to disable endpoint security.

<pre class="file" data-filename="src/main/resources/application.properties" data-target="insert" data-marker="# TODO: Add Security preference here">
management.endpoints.web.exposure.include=*  
</pre>

If we redeploy the application again with: 

``mvn package oc:deploy -Popenshift -DskipTests``{{execute}}

Now we can hit the `/actuator/metrics` endpoint [here](http://spring-monitoring-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/actuator/metrics) and get a list of metrics types accessible to us:

```json
{"names":["jvm.memory.max","jvm.threads.states","process.files.max","jvm.gc.memory.promoted","system.load.average.1m","jvm.memory.used","jvm.gc.max.data.size","jvm.memory.committed","system.cpu.count","logback.events","http.server.requests","tomcat.global.sent","jvm.buffer.memory.used","tomcat.sessions.created","jvm.threads.daemon","system.cpu.usage","jvm.gc.memory.allocated","tomcat.global.request.max","tomcat.global.request","tomcat.sessions.expired","jvm.threads.live","jvm.threads.peak","tomcat.global.received","process.uptime","tomcat.sessions.rejected","process.cpu.usage","tomcat.threads.config.max","jvm.classes.loaded","jvm.classes.unloaded","tomcat.global.error","tomcat.sessions.active.current","tomcat.sessions.alive.max","jvm.gc.live.data.size","tomcat.threads.current","process.files.open","jvm.buffer.count","jvm.gc.pause","jvm.buffer.total.capacity","tomcat.sessions.active.max","tomcat.threads.busy","process.start.time"]}
```

We can then navigate to `/acutuator/metrics/[metric-name]`. For example, click this link: [JVM Memory Usage](http://spring-monitoring-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/actuator/metrics/jvm.memory.max).
This will display different types of metric data about the JVM Metrics:

```json
{"name":"jvm.memory.max","description":"The maximum amount of memory in bytes that can be used for memory management","baseUnit":"bytes","measurements":[{"statistic":"VALUE","value":2.543321088E9}],"availableTags":[{"tag":"area","values":["heap","nonheap"]},{"tag":"id","values":["Compressed Class Space","PS Survivor Space","PS Old Gen","Metaspace","PS Eden Space","Code Cache"]}]}
```

In addition to the different monitoring endpoints we also have informational endpoints like the `/actuator/beans` endpoint [here](http://spring-monitoring-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/actuator/beans), which will show all of the configured beans in the application. Spring Actuator provides multiple informational endpoints on top of the monitoring endpoints that can prove useful for information gathering about your deployed Spring application and can be helpful while debugging your applications in OpenShift.

# Open the solution in an IDE in the Cloud!
Want to continue exploring this solution on your own in the cloud? You can use the free [Red Hat CodeReady Workspaces](https://developers.redhat.com/products/codeready-workspaces/overview) IDE running on the free [Red Hat Developer Sandbox](http://red.ht/dev-sandbox). [Click here](https://workspaces.openshift.com) to login or to register if you are a new user. This free service expires after 30 days, but you can always enable a new free 30-day subscription.

Once logged in, [click here](https://workspaces.openshift.com/f?url=https://raw.githubusercontent.com/openshift-katacoda/rhoar-getting-started/solution/spring/spring-monitoring/devfile.yaml) to open the solution for this project in the cloud IDE. While loading, if it asks you to update or install any plugins, you can say no.

# Fork the source code to your own GitHub!
Want to experiment more with the solution code you just worked with? If so, you can fork the repository containing the solution to your own GitHub repository by clicking on the following command to execute it:

`/root/projects/forkrepo.sh`{{execute T1}}
- Make sure to follow the prompts. An error saying `Failed opening a web browser at https://github.com/login/device exit status 127` is expected.
- [Click here](https://github.com/login/device) to open a new browser tab to GitHub and paste in the code you were presented with and you copied.
- Once done with the GitHub authorization in the browser, close the browser tab and return to the console and press `Enter` to complete the authentication process.
- If asked to clone the fork, press `n` and then `Enter`.
- If asked to confirm logout, press `y` and the `Enter`.

   > **NOTE:** This process uses the [GitHub CLI](https://cli.github.com) to authenticate with GitHub. The learn.openshift.com site is not requesting nor will have access to your GitHub credentials.

After completing these steps the `rhoar-getting-started` repo will be forked in your own GitHub account. On the `solution` branch in the repo, the `spring-monitoring` project inside the `spring` folder contains the completed solution for this scenario.

## Congratulations

You have now included a health check in your Spring Boot application that's living in the OpenShift Container Platform.
