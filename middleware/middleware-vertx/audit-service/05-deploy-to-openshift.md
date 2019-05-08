## Deploy to OpenShift

First, we need a database.

**1. Deploy the database**

`cd /root/code/audit-service`{{execute}}

`oc new-app -e POSTGRESQL_USER=admin -ePOSTGRESQL_PASSWORD=secret -ePOSTGRESQL_DATABASE=audit registry.access.redhat.com/rhscl/postgresql-94-rhel7 --name=audit-database`{{execute}}

It creates a new database service named `audit-database` with the given credentials and settings. Be aware that for sake of simplicity this database is not using a persistent storage.

Now, we can deploy our audit service:

`mvn fabric8:deploy`{{execute}}

**2. Access the Micro-trader dashboard**

Click on the "OpenShift Console" tab next to the "Local Web Browser" tab.

![OpenShift Console Tab](/openshift/assets/middleware/rhoar-getting-started-vertx/openshift-console-tab.png)

Log in using `developer/developer` for username and password. You should see the newly created project called `“vertx-kubernetes-workshop"`. Click on it. You should see six pods running, one each for the quote-generator, portfolio-service, compulsive-traders and micro-trader-dashboard microservices that you created in previous scenarios and new ones for the audit-database and audit-service that you created just now.

Click on the route for the `micro-trader-dashboard`. Append `“/admin”` at the end of the route and you should see the dashboard. You should see some new services and if you click on the “Trader” tab on the left, you should see the operations in the top right corner!

Alternatively, you can click on the
[route URL](http://micro-trader-dashboard-vertx-kubernetes-workshop.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/admin)
to access the dashboard.