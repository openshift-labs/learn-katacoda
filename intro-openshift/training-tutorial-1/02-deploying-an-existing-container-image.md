In this exercise you are going to deploy the front end web component of the ParksMap application which is called `parksmap`. The front end uses a dynamic service discovery mechanism to discover what backend services have been deployed and shows their data on the map.

![Web Console Login](../../assets/intro-openshift/training-tutorial-1/02-application-architecture-stage-1.png)

### Exercise: Deploying an application image

Let's start by doing the simplest thing possible - take a pre-existing container image and run it on OpenShift. This is incredibly simple to do using the web console.

Return to the web console:

https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com

Return to the project overview page for the `myproject` project. Next, click the _Add to Project_ drop down menu in the top navigation bar. Select the "Deploy Image".

We will learn more about image streams and image stream tags later. For now,
select the _Image Name_ option, and enter the following into the text entry field for _image name or pull spec_:

``docker.io/openshiftroadshow/parksmap-py:1.0.0``{{copy}}

Press *enter* or click on the magnifying glass icon. OpenShift will query the ``docker.io`` image registry and pull down details about the image and display them.

Your screen should look like:

![Application Image Details](../../assets/intro-openshift/training-tutorial-1/02-deploy-image-by-image-name.png)

With the query complete and the details available, you should also now be
presented with options to set the name of the application and add additional configuration such as environment variables and labels.

For now, ensure you change the application name from:

``parksmap-py``

to:

``parksmap``{{copy}}

![Deploy Application Image](../../assets/intro-openshift/training-tutorial-1/02-deploy-application-image.png)

Hit the _Create_ button at the bottom of the screen and on the next page click
"Continue to overview". Take a moment to look at the various messages that
you now see on the overview page.

WINNING! These few steps are the only ones you need to run to get a "vanilla"
container image deployed on OpenShift. This should work with any
container image that follows best practices, such as defining an EXPOSE
port, not needing to run specifically as the *root user* or other user name, and
a single non-exiting CMD to execute on start.

### Background: Containers and Pods

In OpenShift, the smallest deployable unit is a *Pod*. A *Pod* is a group of one or
more containers deployed together and guaranteed to be on the same host.

Each pod has its own IP address, therefore owning its entire port space, and
containers within pods can share storage. Pods can be "tagged" with one or
more labels, which are then used to select and manage groups of pods in a
single operation.

*Pods* can contain multiple containers. The general idea is for a Pod to
contain a "server" and any auxiliary services you want to run along with that
server. Examples of containers you might put in a *Pod* are, an Apache HTTPD
server, a log analyzer, and a file service to help manage uploaded files.

### Exercise: Examining the Pod

In the web console's overview page you will see that there is a single *Pod* that
was created by your actions. This *Pod* contains a single container, which
is the `parksmap` application.

You can also examine *Pods* from the command line:

``oc get pod``{{execute}}

You should see output that looks similar to:

```
NAME               READY     STATUS    RESTARTS   AGE
parksmap-1-cf6b6   1/1       Running   0          2m
```

The above output lists all of the *Pods* in the current *Project*, including the
*Pod* name, state, restarts, and uptime. Once you have a *Pod*'s name, you can
get more information about the *Pod* using the ``oc get`` command.  To make the
output readable, you can set the output type to *YAML* using the
following syntax:

```
oc get pod parksmap-1-cf6b6 -o yaml
```

NOTE: You will need to enter this command into the _Terminal_ yourself as you need to use the correct *Pod* name corresponding to what you have running.

You should see output which starts with a description similar to that below:

```
apiVersion: v1
kind: Pod
metadata:
  annotations:
    openshift.io/deployment-config.latest-version: "1"
    openshift.io/deployment-config.name: parksmap
    openshift.io/deployment.name: parksmap-1
    openshift.io/generated-by: OpenShiftWebConsole
    openshift.io/scc: restricted
  creationTimestamp: 2017-12-12T10:00:42Z
  generateName: parksmap-1-
  labels:
    app: parksmap
    deployment: parksmap-1
    deploymentconfig: parksmap
  name: parksmap-1-cf6b6
  namespace: myproject
  ...
```

The web interface also shows a lot of the same information on the *Pod* details
page. Click on the blue *Pod* circle on the project overview page. As there is only one *Pod* you will
be taken direct to the details page for the *Pod*. You can also get there by clicking "Applications", then
"Pods", at the left, and then clicking the *Pod* name. If there was more than one *Pod* and you clicked in the *Pod* circle you would instead end up at the *Pod* list.

#### Background: Services

*Services* provide a convenient abstraction layer inside OpenShift to find a
group of like *Pods*. They also act as an internal proxy/load balancer between
those *Pods* and anything else that needs to access them from inside the
OpenShift environment. For example, if you needed more parks map servers to
handle the load, you could spin up more *Pods*. OpenShift automatically maps
them as endpoints to the *Service*, and the incoming requests would not notice
anything different except that the *Service* was now doing a better job handling
the requests.

When you asked OpenShift to run the image, it automatically created a *Service*
for you. Remember that services are an internal construct. They are not
available to the "outside world", or anything that is outside the OpenShift
environment. That's OK, as you will learn later.

The way that a *Service* maps to a set of *Pods* is via a system of *Labels* and
*Selectors*. *Services* are assigned an eternal IP address and many ports and
protocols can be mapped.

There is a lot more information about
https://{{DOCS_URL}}/latest/architecture/core_concepts/pods_and_services.html#services[Services],
including the YAML format to make one by hand, in the official documentation.

Now that we understand the basics of what a *Service* is, let's take a look at
the *Service* that was created for the image that we just deployed.  In order to
view the *Services* defined in your *Project*, enter in the following command:

[source]
----
oc get services
----

You should see output similar to the following:

[source]
----
NAME       CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
parksmap   172.30.169.213   <none>        8080/TCP   3h
----

In the above output, we can see that we have a *Service* named `parksmap` with an
IP/Port combination of 172.30.169.213/8080TCP. Your IP address may be different, as
each *Service* receives a unique IP address upon creation. *Service* IPs are
eternal and never change for the life of the *Service*.

In the web console, service information is available by clicking "Applications"
and then clicking "Services" in the "Networking" submenu.

You can also get more detailed information about a *Service* by using the
following command to display the data in YAML:

[source]
----
oc get service parksmap -o yaml
----

You should see output similar to the following:

[source]
----
apiVersion: v1
kind: Service
metadata:
  annotations:
    openshift.io/generated-by: OpenShiftWebConsole
  creationTimestamp: 2016-10-03T15:33:17Z
  labels:
    app: parksmap
  name: parksmap
  namespace: {{EXPLORE_PROJECT_NAME}}{{USER_SUFFIX}}
  resourceVersion: "6893"
  selfLink: /api/v1/namespaces/{{EXPLORE_PROJECT_NAME}}{{USER_SUFFIX}}/services/parksmap
  uid: b51260a9-897e-11e6-bdaa-2cc2602f8794
spec:
  clusterIP: 172.30.169.213
  ports:
  - name: 8080-tcp
    port: 8080
    protocol: TCP
    targetPort: 8080
  selector:
    deploymentconfig: parksmap
  sessionAffinity: None
  type: ClusterIP
status:
  loadBalancer: {}
----

Take note of the `selector` stanza. Remember it.

It is also of interest to view the JSON of the *Pod* to understand how OpenShift
wires components together.  For example, run the following command to get the
name of your `parksmap` *Pod*:

[source]
----
oc get pods
----

You should see output similar to the following:

[source]
----
NAME               READY     STATUS    RESTARTS   AGE
parksmap-1-hx0kv   1/1       Running   0          3h
----

Now you can view the detailed data for your *Pod* with the following command:

[source]
----
oc get pod parksmap-1-hx0kv -o yaml
----

Under the `metadata` section you should see the following:

[source]
----
labels:
  app: parksmap
  deployment: parksmap-1
  deploymentconfig: parksmap
----

* The *Service* has `selector` stanza that refers to `deploymentconfig=parksmap`.
* The *Pod* has multiple *Labels*:
** `deploymentconfig=parksmap`
** `app=parksmap`
** `deployment=parksmap-1`

*Labels* are just key/value pairs. Any *Pod* in this *Project* that has a *Label* that
matches the *Selector* will be associated with the *Service*. To see this in
action, issue the following command:

[source]
----
oc describe service parksmap
----

You should see something like the following output:

[source]
----
Name:                   parksmap
Namespace:              {{EXPLORE_PROJECT_NAME}}{{USER_SUFFIX}}
Labels:                 app=parksmap
Selector:               deploymentconfig=parksmap
Type:                   ClusterIP
IP:                     172.30.169.213
Port:                   8080-tcp        8080/TCP
Endpoints:              10.1.2.5:8080
Session Affinity:       None
No events.
----

You may be wondering why only one end point is listed. That is because there is
only one *Pod* currently running.  In the next lab, we will learn how to scale
an application, at which point you will be able to see multiple endpoints
associated with the *Service*.
