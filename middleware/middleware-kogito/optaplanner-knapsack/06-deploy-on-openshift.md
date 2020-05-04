In the previous step you've implemented the RESTful resource of our OptaPlanner Quarkus application and solved a knapsack problem. In this step of the scenario, we will deploy our service to OpenShift and scale it up to be able to handle production load.

Before getting started with this step, make sure you've stopped the running application in terminal 1 using `CTRL-C`.

## Login to OpenShift

`oc login --server=https://[[HOST_SUBDOMAIN]]-6443-[[KATACODA_HOST]].environments.katacoda.com --insecure-skip-tls-verify=true`{{execute T1}}

Enter your username and password:
* Username: **developer**
* Password: **developer**

## Create a new project

`oc new-project knapsack-optaplanner --display-name="Knapsack OptaPlanner Solver"`{{execute T1}}

**3. Open the OpenShift Web Console**

OpenShift ships with a web-based console that will allow users to perform various tasks via a browser. To get a feel for how the web console works, click on the "OpenShift Console" tab next to the "Local Web Browser" tab.

![OpenShift Console Tab](/openshift/assets/middleware/quarkus/openshift-console-tab.png)

> Note you will get a security certificate error due to the use of self-signed security certificates. You will need to accept the exception in your browser to continue to the OpenShift console.

The first screen you will see is the authentication screen. Enter your username and password (u: developer, p: developer) and then log in:

![Web Console Login](/openshift/assets/middleware/middleware-kogito/login.png)

After you have authenticated to the web console, you will be presented with a list of projects that your user has permission to work with.

![Web Console Projects](/openshift/assets/middleware/middleware-kogito/openshift-knapsack-optaplanner-project.png)

Click on your new project name to be taken to the project overview page which will list all of the routes, services, deployments, and pods that you have running as part of your project:

![Web Console Overview](/openshift/assets/middleware/middleware-kogito/openshift-knapsack-optaplanner-overview.png)

There's nothing there now, but that's about to change.

## Deploy to OpenShift

First, we need to compile and package our application. We will compile our application as an OptaPlanner Quarkus image to run in JVM mode. Note that our application also supports being compiled into a native image using GraalVM.

`mvn clean package`{{execute T1}}

Next, create a new _binary_ build within OpenShift:

`oc new-build registry.access.redhat.com/openjdk/openjdk-11-rhel7:latest --binary --name=knapsack-optaplanner -l app=knapsack-optaplanner`{{execute T1}}

Our build needs both the _runner_ JAR file, as well as the _libs_ directory. We will create a temporary directory in which we will copy those assets, and use that directory to upload to our S2I image:

`rm -rf /tmp/knapsack-optaplanner-build && mkdir -p /tmp/knapsack-optaplanner-build && cp target/knapsack-optaplanner-quarkus-1.0-SNAPSHOT-runner.jar /tmp/knapsack-optaplanner-build/knapsack-optaplanner-quarkus-1.0-SNAPSHOT-runner.jar && cp -R target/lib /tmp/knapsack-optaplanner-build/lib`{{execute T1}}


And then start and watch the build, which will take about a minute or two to complete:

`oc start-build knapsack-optaplanner --from-dir=/tmp/knapsack-optaplanner-build --follow`{{execute T1}}

Once that's done, we'll deploy it as an OpenShift application:

`oc new-app knapsack-optaplanner`{{execute T1}}

and expose it to the world:

`oc expose service knapsack-optaplanner`{{execute T1}}

Finally, make sure it's actually done rolling out:

`oc rollout status -w dc/knapsack-optaplanner`{{execute T1}}

Wait for that command to report `replication controller "knapsack-optaplanner-1" successfully rolled out` before continuing.

And now we can access our application using `cURL` once again. Note that we again need to wait 10 seconds for the response to return:

`curl --location --request POST 'http://knapsack-optaplanner-knapsack-optaplanner.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/knapsack/solve' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--data-raw '{
	"knapsack": {
		"maxWeight": 10
	},
	"ingots" : [
		{
			"weight": 4,
			"value": 15
		},
		{
			"weight": 4,
			"value": 15
		},
		{
			"weight": 3,
			"value": 12
		},
		{
			"weight": 3,
			"value": 12
		},
		{
			"weight": 3,
			"value": 12
		},
		{
			"weight": 2,
			"value": 7
		},
		{
			"weight": 2,
			"value": 7
		},
		{
			"weight": 2,
			"value": 7
		},
		{
			"weight": 2,
			"value": 7
		},
		{
			"weight": 2,
			"value": 7
		}
	]
}'`{{execute T1}}


So now our app is deployed to OpenShift. You can also see it in the [Overview in the OpenShift Console](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com/k8s/ns/knapsack-optaplanner/deploymentconfigs/knapsack-optaplanner) with its single replica running in 1 pod (the blue circle).

## Scale the application

In order to be able to handle production load and have high availability semantics, we need to scale the application and add a number of extra running pods.

We can easily scale the number of PODs via the OpenShift _oc_ client:

`oc scale --replicas=10 dc/knapsack-optaplanner`{{execute T1}}

Back in the [Overview in the OpenShift Console](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com/k8s/ns/knapsack-optaplanner/deploymentconfigs/knapsack-optaplanner) you'll see the app scaling dynamically up to 10 pods.

This should only take a few seconds to complete the scaling. The application is now ready to take production load.

## Congratulations!

In this scenario you got a glimpse of the power of OptaPlanner apps on a Quarkus runtime on OpenShift. You've packaged your Knapsack OptaPlanner solver in a container image, deployed it on OpenShift, and solved a knapsack problem. Finally, you've scaled the environment to 10 PODs to be able to serve production load. Well done!
