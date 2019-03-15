## Deploy to OpenShift

**1. Build and Deploy**

To test, we can deploy our traders service to OpenShift using

`cd /root/code/compulsive-traders`{{execute}}

`mvn fabric8:deploy`{{execute}}

**2. Access the Micro-trader dashboard**

Click on the "OpenShift Console" tab next to the "Local Web Browser" tab.

![OpenShift Console Tab](/openshift/assets/middleware/rhoar-getting-started-vertx/openshift-console-tab.png)

Log in using `developer/developer` for username and password. You should see the newly created project called `“vertx-kubernetes-workshop"`. Click on it. You should see four pods running, one each for the quote-generator, portfolio-service and micro-trader-dashboard microservices that you created in previous scenarios and a new one for the compulsive-traders service that you created just now.

Click on the route for the `micro-trader-dashboard`. Append `“/admin”` at the end of the route and you should see the dashboard. You should see some new services and if you click on the “Trader” tab on the left, you may start seeing some moves on your portfolio!

Alternatively, you can click on the
[route URL](http://micro-trader-dashboard-vertx-kubernetes-workshop.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/admin)
to access the dashboard.