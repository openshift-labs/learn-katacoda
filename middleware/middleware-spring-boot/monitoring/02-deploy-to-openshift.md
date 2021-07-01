# Deploy to OpenShift Application Platform
**1. Deploying the application to OpenShift**

This sandbox has already authenticated you to OpenShift. To validate, we will use the `oc whoami` command:

``oc whoami``{{execute}}

Let's create a project that you will use to house your applications.

``oc new-project dev --display-name="Dev - Spring Boot App"``{{execute}}

Run the following command to deploy the application to OpenShift:

``mvn package oc:deploy -Popenshift -DskipTests``{{execute}}

This step may take some time to do the Maven build and the OpenShift deployment. After the build completes you can verify that everything is started by running the following command:

``oc rollout status dc/spring-monitoring``{{execute}}
 
**2. Using a Route to reach the application from the internet** 

Now that our application is deployed to OpenShift, how do external users access it? The answer is with a **Route**. By using a route, we are able to expose our services and allow for external connections at a given hostname. Open the OpenShift Console, log in using _admin_/_admin_ credetial and you can view the route that was created for our application under the project _dev_.
![Routes](/openshift/assets/middleware/rhoar-monitoring/routes.png)

Either click on the route link through the _Location_ column from the above screen and navigate to the `/fruits` endpoint, or click this link [here](http://spring-monitoring-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/fruits).

We should now see the same `Success` page that we saw when we first tested our app locally:

![Success](/openshift/assets/middleware/rhoar-monitoring/landingPage.png)

## Congratulations

You have now learned how to access the application via an external route. In our next step, we will navigate through OpenShift's web console in order to view our application and learn about health checks.