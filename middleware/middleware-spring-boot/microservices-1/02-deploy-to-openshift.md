# Login and Deploy to OpenShift Application Platform

**1. Login to the OpenShift Container Platform**

To login, we will use the `oc` command and then specify a username and password like this:

``oc login [[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com --insecure-skip-tls-verify=true -u developer -p developer``{{execute}}

Next we create the project that we'll be adding our application to:

``oc new-project dev --display-name="Dev - Spring Boot App"``{{execute}}

**2. Additional Configuration**

Before we deploy the application, we have to make a few changes so our application runs smoothly using External Configurations.

The first step is we're going to assign view access rights to the our deveoper account. We have to do this before deploying the application so that it's able to access the OpenShift API and read the contents of the ConfigMap. We can do that with the following command:

``oc policy add-role-to-user view -n $(oc project -q) -z default``{{execute}}

We should see `role "view" added: "default"` as output. The next step is to create our ConfigMap configuration and deploy it to OpenShift using:

``oc create configmap app-config --from-file=greeting-service/src/main/etc/application.properties``{{execute}}

We will talk about ConfigMaps in greater detail in the next section.

>**NOTE:** The only two parameters this command needs are the name of the ConfigMap to create and the file location. This command is creating a ConfigMap named `app-config`. We're going to be using that name in future commands. If you decide to manually run the command or give the ConfigMap a different name, make sure you modify the other commands accordingly.

Now we're ready to deploy!

**3. Deploy the application to OpenShift**

Run the following command to deploy the application to OpenShift

``mvn package fabric8:deploy -Popenshift``{{execute}}

There's a lot that happens here so lets break it down:

The `mvn package` piece of the above command instructs Maven to run the package lifecycle. This builds a Spring Boot JAR file which is a Fat Jar containing all dependencies necessary to run our application.

For the deployment to OpenShift we are using the [Fabric8](https://fabric8.io/) tool through the `fabric8-maven-plugin` which is configured in our ``pom.xml``{{open}} (found in the `<profiles/>` section).

Now that our application is deployed, navigate to our route in the OpenShift Web View or click [here](http://spring-boot-configmap-greeting-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/). We should see the following screen, meaning everything was successful:

![Greeting Service](/openshift/assets/middleware/rhoar-microservices/greeting-service-mini.png)

**4. Test functionality**

As the page suggests, we're going to put in a name and let our greeting service reply with a given greeting. Since our default value is `Greetings, you picked %s as your favorite fruit!`, that's what we should see after we fill in the textbox and click the button. 

<!-- And indeed that's what we see:

![Hello Message](/openshift/assets/middleware/rhoar-microservices/hello-message.png) -->


## Congratulations

We've now deployed our application to OpenShift and we're ready to see how we can modify certain aspects of our application without downtime through the use of External Configuration via our ConfigMap.