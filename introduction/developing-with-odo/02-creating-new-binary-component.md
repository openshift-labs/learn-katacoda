A selection of runtimes, frameworks, and other components is available on an OpenShift cluster for building your applications. This list is referred to as the *Software Catalog*. List the Catalog with `odo`:

`odo catalog list`{{execute}}

Sites can configure the Software Catalog, so the list will vary on different OpenShift clusters. For this exercise, the cluster's catalog list must include `php` and `wildfly`, the PHP language runtime and the WildFly Java application server, respectively.

Source code for the backend of our `sample` application is available in the command line environment. Change directories into the source directory, `backend`:

`cd ~/backend`{{execute}}

Take a look at the contents of the `backend` directory. It's a regular Java application using the Maven build system.

`ls src/main`{{execute}}

Build the `backend` source file with Maven to create the deployment artifact `ROOT.war`:

`mvn package`{{execute}}

With the backend's `.war` file built, we can use `odo` to deploy and run it atop the WildFly app server we saw earlier in the Software Catalog. This creates a *component* named `backend`, of *component-type* `wildfly`.

`odo create wildfly backend --binary target/ROOT.war`{{execute}}

As the container create, push, and deploy steps happen, `odo` will print status like the following:

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
[...]
Pushed 11/12 layers, 98% complete
Pushed 12/12 layers, 100% complete
Push successful
Component 'backend' was created.

Component 'backend' is now set as active component.
```

The application is successfully deployed on OpenShift. With a single `odo create` command, OpenShift has built our backend component's `.war` file into a container along with the WildFly server needed to run it. That container is then pushed into OpenShift's integrated container registry. From there, the container is deployed into a Pod running on the OpenShift cluster.

Let's verify that by running:

`odo list`{{execute}}

which should report one component, named `backend`:

```
ACTIVE     NAME        TYPE
*          backend     wildfly
```

Since `backend` is a binary component, as specified in the `odo create` command above, changes to the program's source code would be followed by another Maven build. After `mvn` compiled a new `ROOT.war` file, the updated program would be updated in the `backend` component with the `odo push` subcommand. We can emulate such a `push` right now:

`odo push`{{execute}}

When the push completes, `odo` will print:

```
changes successfully pushed to component: backend
```
