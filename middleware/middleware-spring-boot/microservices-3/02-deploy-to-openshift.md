# Deploy to OpenShift and Test Application

**1. Login and create a Project**

To login, we will use the `oc` command and then specify a username and password like this:

``oc login [[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com --insecure-skip-tls-verify=true -u developer -p developer``{{execute}}

Now we'll create a base project for our application:

``oc new-project dev --display-name="Dev - Spring Boot App"``{{execute}}

**2. Deploy the application to OpenShift**

Run the following command to deploy the application to OpenShift

``mvn package fabric8:deploy -Popenshift -DskipTests``{{execute}}

This step may take some time to do the Maven build and the OpenShift deployment. After the build completes you can verify that everything is started by running the following commands (one for each service):

``oc rollout status dc/spring-boot-circuit-breaker-greeting``{{execute}}
``oc rollout status dc/spring-boot-circuit-breaker-name``{{execute}}

Then either go to the OpenShift web console and click on the route or click [here](https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/)

Make sure that you can add and remove fruits using the web application.

**3. Connection to the application**

Now that our application is deployed, navigate to our route in the OpenShift Web View or click [here](http://spring-boot-circuit-breaker-greeting-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/). We should see the following header, meaning everything was successful:

![Circuit Breaker page](/openshift/assets/middleware/rhoar-microservices/circuit-mainpage.png)

**4. Test current functionality**

Although our application has a nice web view, we're going to interact with it through our terminal for testing purposes. The first thing we have to do is call our greeting service.

``curl http://spring-boot-circuit-breaker-greeting-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/api/greeting``{{execute}}

 Since we should have no issue and our application is online we should get our normal response, which should look like this:
 
 ```json
 {"content":"You've picked apple!"}
 ```

This means that everything is working and our circuit is closed!

## Congratulations

You have now learned how to deploy a Spring Boot application to OpenShift Container Platform and we've tested our current application. In our next step, we will trip the Circuit Breaker and see how the functionality changes.