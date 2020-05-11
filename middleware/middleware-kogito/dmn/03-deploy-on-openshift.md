In the previous step you've created a DMN model that implements the decision logic of our airmiles service and tested it using a number of RESTful requests. In this step of the scenario, we will deploy our service to OpenShift and scale it up to be able to handle production load.

Before getting started with this step, make sure you've stopped the running application in terminal 1 using `CTRL-C`.

## Login to OpenShift

`oc login --server=https://[[HOST_SUBDOMAIN]]-6443-[[KATACODA_HOST]].environments.katacoda.com --insecure-skip-tls-verify=true`{{execute T1}}

Enter your username and password:
* Username: **developer**
* Password: **developer**

## Create a new project

`oc new-project kogito-airmiles --display-name="Kogito Airmiles App"`{{execute T1}}

**3. Open the OpenShift Web Console**

OpenShift ships with a web-based console that will allow users to perform various tasks via a browser. To get a feel for how the web console works, click on the "OpenShift Console" tab next to the "Local Web Browser" tab.

![OpenShift Console Tab](/openshift/assets/middleware/quarkus/openshift-console-tab.png)

> Note you will get a security certificate error due to the use of self-signed security certificates. You will need to accept the exception in your browser to continue to the OpenShift console.

The first screen you will see is the authentication screen. Enter your username and password (u: developer, p: developer) and then log in:

![Web Console Login](/openshift/assets/middleware/middleware-kogito/login.png)

After you have authenticated to the web console, you will be presented with a list of projects that your user has permission to work with.

![Web Console Projects](/openshift/assets/middleware/middleware-kogito/projects.png)

Click on your new project name to be taken to the project overview page which will list all of the routes, services, deployments, and pods that you have running as part of your project:

![Web Console Overview](/openshift/assets/middleware/middleware-kogito/overview.png)

There's nothing there now, but that's about to change.

## Deploy to OpenShift

First, we need to compile and package our application. We will compile our application as a Kogito Quarkus native image using GraalVM. Note that the compilation might take a minute or two:

`mvn clean package -Pnative`{{execute T1}}

Next, create a new _binary_ build within OpenShift:

`oc new-build quay.io/quarkus/ubi-quarkus-native-binary-s2i:19.3.1 --binary --name=airmiles-service -l app=airmiles-service`{{execute T1}}

> This build uses the new [Red Hat Universal Base Image](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/building_running_and_managing_containers/using_red_hat_universal_base_images_standard_minimal_and_runtimes), providing foundational software needed to run most applications, while staying at a reasonable size.

And then start and watch the build, which will take about a minute or two to complete:

`oc start-build airmiles-service --from-file=target/airmiles-service-1.0-SNAPSHOT-runner --follow`{{execute T1}}

Once that's done, we'll deploy it as an OpenShift application:

`oc new-app airmiles-service`{{execute T1}}

and expose it to the world:

`oc expose service airmiles-service`{{execute T1}}

Finally, make sure it's actually done rolling out:

`oc rollout status -w dc/airmiles-service`{{execute T1}}

Wait for that command to report `replication controller "airmiles-service-1" successfully rolled out` before continuing.

And now we can access our application using `cURL` once again:

`curl -X POST "http://airmiles-service-kogito-airmiles.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/airmiles" -H 'Accept: application/json' -H 'Content-Type: application/json' -d '{ "Status": "GOLD",	"Price": 600}'`{{execute T1}}


You should again see the following decision result:

```console
{"Status":"GOLD","Airmiles":720.0,"Price":600}
```

So now our app is deployed to OpenShift. You can also see it in the [Overview in the OpenShift Console](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com/k8s/ns/kogito-airmiles/deploymentconfigs/airmiles-service) with its single replica running in 1 pod (the blue circle).

## Scale the application

In order to be able to handle production load and have high availability semantics, we need to scale the application and add a number of extra running pods.

Let's make _sure_ our Kogito app doesn't go beyond a reasonable amount of memory for each instance by setting _resource constraints_ on it. We'll go with 50 MB of memory as an upper limit (which is pretty thin, compared to your average Java app!). This will let us scale up quite a bit. Click here to set this limit:

`oc set resources dc/airmiles-service --limits=memory=50Mi`{{execute T1}}

 We can now easily scale the number of PODs via the OpenShift _oc_ client:

`oc scale --replicas=10 dc/airmiles-service`{{execute T1}}

Back in the [Overview in the OpenShift Console](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com/k8s/ns/kogito-airmiles/deploymentconfigs/airmiles-service) you'll see the app scaling dynamically up to 10 pods.

This should only take a few seconds to complete the scaling. Now that we have 10 pods running, let's hit it with some load:

Now, with our service being ready for a production environment, let's hit it with some load:

`for i in {1..50} ; do curl -X POST "http://airmiles-service-kogito-airmiles.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/airmiles" -H "accept: application/json" -H "Content-Type: application/json"  -d '{ "Status": "GOLD",	"Price": 600}'; sleep .05 ; done`{{execute T1}}

You can see the 10 instances of our Kogito app being load-balanced and process instances being created:

```console
{"Status":"GOLD","Airmiles":720.0,"Price":600}
{"Status":"GOLD","Airmiles":720.0,"Price":600}
{"Status":"GOLD","Airmiles":720.0,"Price":600}
{"Status":"GOLD","Airmiles":720.0,"Price":600}
...
```


## Congratulations!

In this scenario you got a glimpse of the power of Kogito apps on a Quarkus runtime on OpenShift. You've packaged your Kogito DMN Decision Service in a container image, deployed it on OpenShift, scaled the environment to 10 PODs and hit it with a number of requests. Well done!
