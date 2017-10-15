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

The build of our application is now scheduled, and it will take some time before it's ready.
To check the status of our application, run the command:

``oc status``{{execute}}

If the application is ready, you will see output like this:

```text
In project jberet-lab on server https://172.17.0.19:8443

http://intro-jberet-jberet-lab.2886795283-80-ollie01.environments.katacoda.com to pod port 8080-tcp (svc/intro-jberet)
  dc/intro-jberet deploys istag/intro-jberet:latest <-
    bc/intro-jberet source builds https://github.com/jberet/intro-jberet.git on openshift/wildfly:10.1
    deployment #1 deployed 22 seconds ago - 1 pod

View details with 'oc describe <resource>/<name>' or list everything with 'oc get all'.
```

To expose `intro-jberet` application to external clients, run the command:

``oc expose svc intro-jberet``{{execute}}

And you will see output like this:

```text
route "intro-jberet" exposed
```

Once the build completes, you can visit the application test URL below to verify:

`http://intro-jberet-jberet-lab.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/`{{copy}}

This will take you to WildFly landing page, which shows the application server is up and running.
