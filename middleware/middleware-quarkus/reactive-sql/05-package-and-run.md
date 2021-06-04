In the previous step you added a custom bean to the app. Let's now package it up as a production app and deploy it.

### Stop the previous application

Let's stop the original application so we can package it as an executable JAR. In the terminal, press `CTRL-C` to stop the application.

## Deploy production application to OpenShift

To deploy the application "in production", we can simply re-deploy the application using the OpenShift extension, omitting the `quarkus-launch-devmode` environment variable. Click the following command to do this:

`mvn clean package -DskipTests \
-Dquarkus.kubernetes.deploy=true \
-Dquarkus.container-image.build=true \
-Dquarkus.kubernetes-client.trust-certs=true \
-Dquarkus.kubernetes.deployment-target=openshift \
-Dquarkus.openshift.route.expose=true \
-Dquarkus.openshift.annotations.\"app.openshift.io/connects-to\"=database`{{execute}}

The output should end with `BUILD SUCCESS`.

[Open up the web UI](http://reactive-sql-reactive-sql.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com). You should see the front web page load with the List of Coffees, to which you can add (or delete).

![Reactive SQL app UI](/openshift/assets/middleware/quarkus/reactive-sql-ui.png)

## Congratulations!

You've packaged up the app as a production app and learned a bit more about the mechanics of packaging. In this tutorial we also used JAX-RS and deployed our application to the Openshift Container platform.

To read more about Quarkus and Reactive SQL head off to [QuarkusIO](http://www.quarkus.io) for more details.
