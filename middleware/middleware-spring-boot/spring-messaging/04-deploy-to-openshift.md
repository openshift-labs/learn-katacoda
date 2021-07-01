# Deploy to OpenShift Application Platform

Before we deploy the application to OpenShift we need to add health checks so that OpenShift can correctly detect if our application is working. For this simple application we will simply leverage another Spring Boot project: Spring Actuator.

**1. Add a health check**

Spring Boot provides a nice feature for health checks called Actuator. Actuator is a project which exposes health data under the API path `/health` that is collected during application runtime automatically. All we need to do to enable this feature is to add the following dependency to ``pom.xml``{{open}} at the **TODO** comment..

<pre class="file" data-filename="pom.xml" data-target="insert" data-marker="<!-- TODO: Add Actuator dependency here -->">
    &lt;dependency&gt;
      &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
      &lt;artifactId&gt;spring-boot-starter-actuator&lt;/artifactId&gt;
    &lt;/dependency&gt;
</pre>

**2. Deploy a Red Hat AMQ Instance**

Once the operator installation is successful, you will create two instances - an `ActiveMQArtemis` instance and an `ActiveMQArtemisAddress` instance. For your reference, the YAML containing the instance details has been created for you and you can view the file as follows:

``cat /root/amq-config-files/amq.yaml``{{execute}}

Now, execute the following command to create those two instances:

``oc apply -f /root/amq-config-files/amq.yaml``{{execute}}

**4. Deploy the application to OpenShift**

Run the following command to deploy the application to OpenShift

``mvn package oc:deploy -Popenshift -DskipTests``{{execute}}

There's a lot that happens here so lets break it down:

The `mvn package` piece of the above command instructs Maven to run the package lifecycle. This builds a Spring Boot JAR file which is a Fat Jar containing all dependencies necessary to run our application.

For the deployment to OpenShift we are using the [jkube](https://www.eclipse.org/jkube) tool through the `org.eclipse.jkube:openshift-maven-plugin` which is configured in our ``pom.xml``{{open}} (found in the `<profiles/>` section). Configuration files for jkube are contained in the ``src/main/jkube``{{open}} folder mentioned earlier.

After the Maven build as finished, it will typically take less than 20 sec for the application to be available. Then you can either go to the OpenShift web console and click on the route or click [here](http://spring-messaging-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com)

You should see the same web application as before. The scheduled Producer will continue to deploy messages so clicking refresh should change the values shown every 3 seconds.

## Congratulations

You have now learned how to deploy a Spring Boot JMS application and a JBoss AMQ resource to the OpenShift Container Platform.

In the final step you'll verify AMQ is receiving messages properly.