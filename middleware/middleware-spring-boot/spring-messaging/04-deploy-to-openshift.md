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

Once the operator installation is successful, you will create two instances - an `ActiveMQArtemis` instance and an `ActiveMQArtemisAddress` instance. For your reference, the YAML file containing the instance details has been created for you and you can view the file as follows:

``cat amq.yml``{{execute}}

You can also observe a **Route** to the AMQ console is defined here, should you choose to play around. Now, execute the following command to create those two instances and the route:

``oc create -f amq.yml``{{execute}}

**4. Deploy the application to OpenShift**

Run the following command to deploy the application to OpenShift

``mvn package oc:deploy -Popenshift -DskipTests``{{execute}}

There's a lot that happens here so lets break it down:

The `mvn package` piece of the above command instructs Maven to run the package lifecycle. This builds a Spring Boot JAR file which is a Fat Jar containing all dependencies necessary to run our application.

For the deployment to OpenShift we are using the [jkube](https://www.eclipse.org/jkube) tool through the `org.eclipse.jkube:openshift-maven-plugin` which is configured in our ``pom.xml``{{open}} (found in the `<profiles/>` section). Configuration files for jkube are contained in the ``src/main/jkube``{{open}} folder mentioned earlier.

After the Maven build/deploy is finished, it will typically take less than 20 sec for the application to be available. Then you can either go to the OpenShift web console from the developer perspective and click on the route from the topology tab (refer to the image below) or click [here](http://spring-messaging-training-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com)

![Spring Messaging App Route](/openshift/assets/middleware/rhoar-messaging/spring-messaging-training-route.png)

You should see the same web application as before. The scheduled Producer will continue to deploy messages every 3 seconds so you should observe a change in the values shown. The number of items in the list will remain 5.

# Open the solution in an IDE in the Cloud!
Want to continue exploring this solution on your own in the cloud? You can use the free [Red Hat CodeReady Workspaces](https://developers.redhat.com/products/codeready-workspaces/overview) IDE running on the free [Red Hat Developer Sandbox](http://red.ht/dev-sandbox). [Click here](https://workspaces.openshift.com) to login or to register if you are a new user. This free service expires after 30 days, but you can always enable a new free 30-day subscription.

Once logged in, [click here](https://workspaces.openshift.com/f?url=https://raw.githubusercontent.com/openshift-katacoda/rhoar-getting-started/solution/spring/spring-messaging/devfile.yaml) to open the solution for this project in the cloud IDE. While loading, if it asks you to update or install any plugins, you can say no.

# Fork the source code to your own GitHub!
Want to experiment more with the solution code you just worked with? If so, you can fork the repository containing the solution to your own GitHub repository by clicking on the following command to execute it:

`/root/projects/forkrepo.sh`{{execute T1}}
- Make sure to follow the prompts. An error saying `Failed opening a web browser at https://github.com/login/device exit status 127` is expected.
- [Click here](https://github.com/login/device) to open a new browser tab to GitHub and paste in the code you were presented with and you copied.
- Once done with the GitHub authorization in the browser, close the browser tab and return to the console and press `Enter` to complete the authentication process.
- If asked to clone the fork, press `n` and then `Enter`.
- If asked to confirm logout, press `y` and the `Enter`.

   > **NOTE:** This process uses the [GitHub CLI](https://cli.github.com) to authenticate with GitHub. The learn.openshift.com site is not requesting nor will have access to your GitHub credentials.

After completing these steps the `rhoar-getting-started` repo will be forked in your own GitHub account. On the `solution` branch in the repo, the `spring-messaging` project inside the `spring` folder contains the completed solution for this scenario.

## Congratulations

You have now learned how to deploy a Spring Boot JMS application and a Red Hat AMQ resource to the OpenShift Container Platform.