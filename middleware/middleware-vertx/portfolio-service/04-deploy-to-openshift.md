## Deploy to OpenShift

Now that you've logged into OpenShift, let's deploy our new micro-trader Vert.x microservice:

**1. Build and Deploy**

We have already deployed our `quote-generator` and `micro-trader-dashboard` microservices on OpenShift. In this step we will deploy our new portfolio microservice. We will continue with the same OpenShift project to house this service and other microservices.

`oc project vertx-kubernetes-workshop`{{execute}}

As you know, Red Hat OpenShift Application Runtimes include a powerful maven plugin that can take an
existing Eclipse Vert.x application and generate the necessary Kubernetes configuration.

Build and deploy the project using the following command, which will use the maven plugin to deploy:

`cd /root/code/portfolio-service`{{execute}}

`mvn fabric8:deploy`{{execute}}

The build and deploy may take a minute or two. Wait for it to complete. You should see a **BUILD SUCCESS** at the
end of the build output.

After the maven build finishes it will take less than a minute for the application to become available.
To verify that everything is started, run the following command and wait for it complete successfully:

`oc rollout status -w dc/portfolio-service`{{execute}}

There you go, the portfolio service is started. It discovers the ``quotes`` service and is ready to be used.

**2. Access the Micro-trader dashboard**

Click on the "OpenShift Console" tab next to the "Local Web Browser" tab.

![OpenShift Console Tab](/openshift/assets/middleware/rhoar-getting-started-vertx/openshift-console-tab.png)

Log in using `developer/developer` for username and password. You should see the newly created project called `“vertx-kubernetes-workshop"`. Click on it. You should see four pods running, one each for the quote-generator and micro-trader-dashboard microservices that you created in previous scenarios and a new one for portfolio-service that you created just now.

Click on the route for the `micro-trader-dashboard`. Append `“/admin”` at the end of the route and you should see the dashboard. You should see some new services and if you click on the “Trader” tab on the left, cash should have been set in the top left corner.

Alternatively, you can click on the
[route URL](http://micro-trader-dashboard-vertx-kubernetes-workshop.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/admin)
to access the dashboard.

The dashboard is consuming the portfolio service using the async RPC mechanism. A client for JavaScript is generated at compile time, and use SockJS to communicate. Behind the hood there is a bridge between the event bus and SockJS.

## Congratulations!

You have deployed the portfolio microservice running on OpenShift. In the next component, we are going to implement the trader service and use that to buy and sell shares. 
