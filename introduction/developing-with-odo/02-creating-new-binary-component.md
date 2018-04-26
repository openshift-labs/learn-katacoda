Working inside our `sample` application, we discover the components available on the cluster, referred to as the component or software *Catalog*, by listing the Catalog with odo:

`odo catalog list`{{execute}}

```
The following components can be deployed:
- httpd
- nodejs
- perl
- php
- python
- ruby
- wildfly
```

In the command line environment, source code is already available for a simple Java backend for our sample application. Change directories into the source directory, `backend`:

`cd ~/backend`{{execute}}

Build the `backend` source file with Maven to create the deployment artifact `ROOT.war`:

`mvn package`{{execute}}

With the backend's `.war` file built, we can use odo to deploy and run it atop a WildFly app server:

`odo create wildfly backend --binary=target/ROOT.war`{{execute}}

You will see no output while the platform deploys your artifact, but
eventually when the container create, push, and deploy steps are complete, output like the following will be displayed:

```
Receiving source from STDIN as file ROOT.war
Moving binaries in source directory into /wildfly/standalone/deployments for later deployment...
Moving all war artifacts from /opt/app-root/src/. directory into /wildfly/standalone/deployments for later deployment...
'/opt/app-root/src/./ROOT.war' -> '/wildfly/standalone/deployments/ROOT.war'
Moving all ear artifacts from /opt/app-root/src/. directory into /wildfly/standalone/deployments for later deployment...
Moving all rar artifacts from /opt/app-root/src/. directory into /wildfly/standalone/deployments for later deployment...
Moving all jar artifacts from /opt/app-root/src/. directory into /wildfly/standalone/deployments for later deployment...
...done

Pushing image 172.30.144.245:5000/myproject/backend:latest ...
Pushed 0/12 layers, 2% complete
Pushed 1/12 layers, 25% complete
Pushed 2/12 layers, 17% complete
Pushed 3/12 layers, 26% complete
[...]
Pushed 9/12 layers, 90% complete
Pushed 10/12 layers, 97% complete
Pushed 11/12 layers, 98% complete
Pushed 12/12 layers, 100% complete
Push successful
Component 'backend' was created.

Component 'backend' is now set as active component.
```

This means the application is successfully deployed on OpenShift. With a single `odo create` command, OpenShift has built our backend component's `.war` file into a container along with the WildFly server needed to run it. That container is then pushed into OpenShift's built-in container registry. From there, the container is deployed into a Pod on the OpenShift cluster.

Let's verify that by running:

`odo list`{{execute}}

which should report one component, named `backend`:

```
ACTIVE     NAME        TYPE
*          backend     wildfly
```
