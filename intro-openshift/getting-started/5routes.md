## Routes

While _Services_ provide internal abstraction and load balancing within an
OpenShift environment, sometimes clients (users, systems, devices, etc.)
**outside** of OpenShift need to access an application. The way that external
clients are able to access applications running in OpenShift is through the
OpenShift routing layer. And the data object behind that is a _Route_.

The default OpenShift router (HAProxy) uses the HTTP header of the incoming
request to determine where to proxy the connection. You can optionally define
security, such as TLS, for the _Route_. If you want your _Services_, and, by
extension, your _Pods_,  to be accessible to the outside world, you need to
create a _Route_.

## Task: Creating a Route

Fortunately, creating a _Route_ is a pretty straight-forward process.  You simply
`expose` the _Service_ via the command line. Or, via the web console, just click
the "Create Route" button associated with the service.

First we want to verify that we don't already have any existing routes:

`oc get routes`{{execute}}

We should see no resources returned.

Now we need to get the _Service_ name to expose:

`oc get services`{{execute}}


Once we know the _Service_ name, creating a _Route_ is a simple one-command task:

`oc expose service parksmap`{{execute}}

The output to this command will indicate us that the route has been created and the service is now externally exposed.

Verify the _Route_ was created with the following command:

`oc get route`{{execute}}

We will be able to see all the details associated with the route, like the hostname, the service port the route is exposing, details on the TLS security for the route, if any, and more.

You can also verify the _Route_ by looking at the project in the OpenShift web console:

![Route](/images/parksmap-route.png)

Pretty nifty, huh?  This application is now available at the URL shown in the
web console. Click the link and you will see:

![Application](/images/parksmap-empty.png)
