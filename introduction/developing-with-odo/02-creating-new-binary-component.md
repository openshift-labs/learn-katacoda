A selection of runtimes, frameworks, and other components is available on an OpenShift cluster for building your applications. This list is referred to as the *Software Catalog*. List the Catalog with `odo`:

`odo catalog list`{{execute}}

Sites can configure the Software Catalog, so the list will vary on different OpenShift clusters. For this exercise, the cluster's catalog list must include `php` and `wildfly`, the PHP language runtime and the WildFly Java application server, respectively.

Source code for the backend of our `sample` application is available in the command line environment. Change directories into the source directory, `backend`:

`cd ~/backend`{{execute}}

Take a look at the contents of the `backend` directory. It's a regular Java application using the Maven build system.

`ls`{{execute}}

Build the `backend` source file with Maven to create the deployment artifact `ROOT.war`:

`mvn package`{{execute}}

With the backend's `.war` file built, we can use `odo` to deploy and run it atop the WildFly app server we saw earlier in the Software Catalog. This creates a *component* named `backend`, of *component-type* `wildfly`.

`odo create wildfly backend --binary target/ROOT.war`{{execute}}

As the container is created, `odo` will print status like the following:

```
Please wait, creating backend component ...
Component 'backend' was created.
To push source code to the component run 'odo push'

Component 'backend' is now set as active component.
```

The application is not yet deployed on OpenShift. With a single `odo create` command, OpenShift has created a container with the WildFly server ready to have your application deployed to it. This container is not pushed into OpenShift's integrated container registry as it will be used for developing your application in an iterative way. This container is deployed into a Pod running on the OpenShift cluster.

Let's verify that the component exists already on the platform and is ready for your application:

`odo list`{{execute}}

which should report one component, named `backend`:

```
ACTIVE     NAME        TYPE
*          backend     wildfly
```

Since `backend` is a binary component, as specified in the `odo create` command above, changes to the program's source code should be followed by pushing the artifact to the running container. After `mvn` compiled a new `ROOT.war` file, the updated program would be updated in the `backend` component with the `odo push` subcommand. We can execute such a `push` right now:

`odo push`{{execute}}

When the push completes, `odo` will print:

```
Pushing changes to component: backend
Please wait, building component....
...
run: stopped
run: started
changes successfully pushed to component: backend
```

As you would probably have noticed, the artifact has been pushed to the container running Wildfly and the Wildfly server has been restarted to acknowledge for the new application.
