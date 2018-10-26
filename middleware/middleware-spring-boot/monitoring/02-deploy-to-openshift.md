# Deploy to OpenShift Application Platform
**1. Connection to the application via the Route**

We have already deployed the application to OpenShift for you. Check that it has finished deploying by clicking the **OpenShift Console** tab and viewing the project.  

Now that our application is deployed to OpenShift, how do external users access it? The answer is with a route. By using a route, we are able to expose our services and allow for external connections at a given hostname. Open the OpenShift web view and we can see the route that was created for our application. Navigate to the Overview page and expand our deployment tab. Under the `ROUTES External Traffic` section we should see our provided route.
![Routes](/openshift/assets/middleware/rhoar-monitoring/overviewRoutes.png)

Either click on the route link through the OpenShift web view, or click this link [here](http://rhoar-training-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/fruits).

We should now see the same `Success` page that we saw when we first tested our app locally:

![Success](/openshift/assets/middleware/rhoar-monitoring/success.png)

## Congratulations

You have now learned how to access the application via an external route. In our next step, we will navigate through OpenShift's web console in order to view our application and learn about health checks.