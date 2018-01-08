To create our new Java batch application based on WildFly image, run the command:

``oc new-app wildfly~https://github.com/jberet/intro-jberet.git``{{execute}}

And the output should look something like this:

```text
--> Found image 18929ed (5 weeks old) in image stream "openshift/wildfly" under tag "10.1" for "wildfly"

    WildFly 10.1.0.Final
    --------------------
    Platform for building and running JEE applications on WildFly 10.1.0.Final

    Tags: builder, wildfly, wildfly10

    * A source build using source code from https://github.com/jberet/intro-jberet.git will be created
      * The resulting image will be pushed to image stream "intro-jberet:latest"
      * Use 'start-build' to trigger a new build
    * This image will be deployed in deployment config "intro-jberet"
    * Port 8080/tcp will be load balanced by service "intro-jberet"
      * Other containers can access this service through the hostname "intro-jberet"

--> Creating resources ...
    imagestream "intro-jberet" created
    buildconfig "intro-jberet" created
    deploymentconfig "intro-jberet" created
    service "intro-jberet" created
--> Success
    Build scheduled, use 'oc logs -f bc/intro-jberet' to track its progress.
    Run 'oc status' to view your app.
```

The build of our application is now scheduled, and it will take **up to 3 minutes** before it's ready.
To watch its status and progress, run the command:

``oc rollout status dc/intro-jberet``{{execute}}

You will see output like the following as the application is being built and deployed:

```text
Deployment config "intro-jberet" waiting on image update
Waiting for latest deployment config spec to be observed by the controller loop...
Waiting for rollout to finish: 0 out of 1 new replicas have been updated...
Waiting for rollout to finish: 0 out of 1 new replicas have been updated...
Waiting for rollout to finish: 0 of 1 updated replicas are available...
Waiting for latest deployment config spec to be observed by the controller loop...
replication controller "intro-jberet-1" successfully rolled out
```

This command will exit once the application is ready.
Now is a great time to switch to the _Dashboard_ and explore features in OpenShift web console
including application configuration, details, logs, monitoring, resource management, etc.

To expose `intro-jberet` application to external clients, run the command:

``oc expose svc intro-jberet``{{execute}}

And you will see output like this:

```text
route "intro-jberet" exposed
```

Once the build completes, you can visit the application test URL below to verify:

http://intro-jberet-jberet-lab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/

This will take you to WildFly landing page, which shows the application server is up and running.
If the application is not ready yet, you will see messages like the following, which means more time
is needed to build and deploy the application:

```text
Application is not available

The application is currently not serving requests at this endpoint. It may not have been started or is still starting.
```
