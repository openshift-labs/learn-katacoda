As mentioned, applications often consist of two or more components that work together to implement the overall application. OpenShift helps organize these modular applications with a concept called, appropriately enough, the application. An OpenShift application represents all of an app's components in a logical management unit. The `odo` tool helps you manage that group of components and link them together, as an application.

A selection of runtimes, frameworks, and other components is available on an OpenShift cluster for building your applications. This list is referred to as the *Software Catalog*. List the supported component types in the catalog, run:

`odo catalog list components`{{execute}}

Administrators can configure the software catalog, so the list will vary on different OpenShift clusters. For this scenario, the cluster's catalog list must include `java` and `nodejs`.

Source code for the backend of our `wildwest` application is available in the command line environment. Change directories into the source directory, `backend`:

`cd ~/backend`{{execute}}

Take a look at the contents of the `backend` directory. It's a regular Java Spring Boot application using the Maven build system.

`ls`{{execute}}

Build the `backend` source files with Maven to create a JAR:

`mvn package`{{execute}}

Since this is the first time running this build, it may take 30-45 seconds to complete. Subsequent builds will run much more quickly.

With the backend's `.jar` file built, we can use `odo` to deploy and run it atop the Java application server we saw earlier in the software catalog. This creates a *component* named `backend` of *component-type* `java`.

`odo create java backend --binary target/wildwest-1.0.jar`{{execute}}

As the container is created, `odo` will print status like the following:

```
 ✓   Checking component
 ✓   Checking component version
 ✓   Creating component backend
 OK  Component 'backend' was created and ports 8080/TCP,8443/TCP,8778/TCP were opened
 OK  Component 'backend' is now set as active component
To push source code to the component run 'odo push'
```

The application is not yet deployed on OpenShift. With a single `odo create` command, OpenShift has created a container with the server ready to have your application deployed to it. This container is deployed into a Pod running on the OpenShift cluster.

If you want to check on the status of an action in `odo`, you can use the `log` command. Let's run that now to follow the progress of our `create` command:

`odo log -f`{{execute}}

You should see the following:

```
--> Scaling backend-wildwest-1 to 1
```

Followed shortly by:
```
--> Success
```

If you want to exit the log before it completes, run the following:

``<ctrl+c>``{{execute}}

Since `backend` is a binary component, as specified in the `odo create` command above, changes to the component's source code should be followed by pushing the jar file to the running container. After `mvn` compiled a new `wildwest-1.0.jar` file, the updated program would be updated in the `backend` component with the `odo push` command. We can execute such a `push` right now:

`odo push`{{execute}}

As the push is progressing, `odo` will print:

```
Pushing changes to component: backend
 ✓   Waiting for pod to start
 ✓   Copying files to pod
 ✓   Building component
 OK  Changes successfully pushed to component: backend
```

The jar file has now been pushed to the container, and the process in that container restarted.
