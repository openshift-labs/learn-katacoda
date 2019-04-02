**Red Hat OpenShift Container Platform** is the preferred cloud runtime for JBoss EAP
OpenShift Container Platform is based on **Kubernetes** which is the most used Orchestration for containers running in production. We assume you understand the basics of OpenShift, if not, please complete [Introduction to OpenShift]( https://learn.openshift.com/introduction/) course and come back here.

**1. Login to OpenShift Container Platform**

To authenticate to the OpenShift Container Platform, we will use the **oc** command and then specify the server that we
want to authenticate to:

```oc login -u developer -p developer```{{execute}}


Congratulations, you are now authenticated to the OpenShift server.


**2. Create project**

For this scenario, you will build a REST service that manages products that we deploy on OpenShift.

```
oc new-project my-project --display-name="Weather App"
```{{execute}}

**3. Open the OpenShift Web Console**

As you probably know, OpenShift ships with a web-based console that will allow users to perform various tasks via a browser. To get a feel for how the web console works, click on the "OpenShift Console" tab next to the "Local Web Browser" tab.

![OpenShift Console Tab](/openshift/assets/middleware/rhoar-getting-started-spring/openshift-console-tab.png)

The first screen you will see is the authentication screen. Enter your username and password and
then login:

![Web Console Login](/openshift/assets/middleware/rhoar-getting-started-spring/login.png)

* Username: `developer`
* Password: `developer`

After you have authenticated to the web console, you will be presented with a
list of projects (on the right side of the screen) that your user has permission to work with.

Click on your new project name to be taken to the project overview page which will list all of the routes, services, deployments, and pods that you will create as part of your project.

There's nothing there now, but that's about to change.

Now that you've logged into OpenShift, let's deploy a single JBoss EAP instance. The deployed JBoss EAP instance will in this step not be connected to a database, but we will see an example of that in a later scenario. 

**3. Deploy JBoss EAP image**

To deploy our application we first have to create a container. JBoss EAP comes with a S2I image that packages all the binaries that. S2I stands for Source-To-Image and is a convenient way for developers to provide either an artifact (E.g. WAR, JAR, etc) or the source code directly and OpenShift will then build a container image for you, so there is no need to have a local container build system and as a developer you do not have to care about patching and maintaining the base image. 

We will use the following command to create a build configuration in OpenShift:

`oc new-build jboss-eap72-openshift:1.0 --binary=true --name=weather-app`{{execute}}

This command tells openshift to use a base image including JBoss EAP 7.2 with the name `weather-app`  and finally, we tell it to use what is called binary deployment. Binary deployment means that we will build the Java artifacts locally (using maven) and let the S2I process build a container where that artifact is deployed in JBoss EAP.

Now, we need to build the prototype application that we are going to deploy.

First move to the project directory:

`cd ~/projects/weather-app`{{execute}}

Now, build the application by executing the following maven command.

`mvn clean package`{{execute}}

We are now ready to upload our artifact (a WAR file) to the build "product-service" process that we created earlier.

`oc start-build weather-app --from-file=target/ROOT.war --wait`{{execute}}

This command will upload the artifact to the build config that we created before and start building a container. Please note that this might take a while the first time you execute it since openshift will have to download the EAP image. Next time it will go much faster.

When the build is finished, we are ready to create your application.

`oc new-app weather-app`{{execute}}

The command new-app will create a running instance based on the container that we built before . You'll see the following output (with some small differences):

```console

--> Found image 11ca9f0 (53 seconds old) in image stream "my-project/weather-app" under tag "latest" for "weather-app"

    JBoss EAP continuous delivery
    -----------------------------
    Platform for building and running JavaEE applications on JBoss EAP continuous delivery

    Tags: builder, javaee, eap, eap7

    * This image will be deployed in deployment config "weather-app"
    * Ports 8080/tcp, 8443/tcp, 8778/tcp will be load balanced by service "product-service"
      * Other containers can access this service through the hostname "weather-app"

--> Creating resources ...
    deploymentconfig "weather-app" created
    service "weather-app" created
--> Success
    Run 'oc status' to view your app.
```

Go back to the OpenShift console and verify that the application comes up correctly

**4. Expose service route**

Now that our application is runing in a container we also have to expose the application to be accessed outside the internal OpenShift network. For that we need to create a route that will forward traffic ffrom the external OpenShift router to our service.

Let's do that next.

```oc expose svc weather-app```{{execute}}

Let's look at the details of the weather app route.

```oc describe route weather-app```{{execute}}

You'll see the output similar to this:

```console
Name:                   weather-app
Namespace:              simple-rest
Created:                25 seconds ago
Labels:                 app=weather-app
Annotations:            openshift.io/host.generated=true
Requested Host:         weather-app-product-service.2886795320-80-simba02.environments.katacoda.com
                          exposed on router router 25 seconds ago
Path:                   <none>
TLS Termination:        <none>
Insecure Policy:        <none>
Endpoint Port:          8080-tcp

Service:        weather-app
Weight:         100 (100%)
Endpoints:      172.20.0.3:8080, 172.20.0.3:8443, 172.20.0.3:8778
```

**NOTE**: The country selector flag will not work yet - we will develop that in the next step!

Now, try to access the service by calling going to the OpenShift console and click on the route link or use [this](http://weather-app-my-project.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/) link. You won't yet be able to select different country flags (you'll get an error popup) - this we will fix in the next step.
