As mentioned, applications often consist of two or more components that work together to implement the overall application. OpenShift helps organize these modular applications with a concept called, appropriately enough, the application. An OpenShift application represents all of an app's components in a logical management unit. The `odo` tool helps you manage that group of components and link them together as an application.

A selection of runtimes, frameworks, and other components are available on an OpenShift cluster for building your applications. This list is referred to as the *Software Catalog*.

List the supported component types in the catalog by running:

`odo catalog list components`{{execute}}

Administrators can configure the software catalog, so the list will vary on different OpenShift clusters. For this scenario, the cluster's catalog list must include `java` and `nodejs`.

Source code for the backend of our `wildwest` application is available in the command line environment. Change directories into the source directory, `backend`:

`cd ~/backend`{{execute}}

Take a look at the contents of the `backend` directory. It's a regular Java Spring Boot application using the Maven build system.

`ls`{{execute}}

Build the `backend` source files with Maven to create a jar file:

`mvn package`{{execute}}

Since this is the first time running this build, it may take 30-45 seconds to complete. Subsequent builds will run much more quickly.

With the backend's `.jar` file built, we can use `odo` to deploy and run it atop the Java application server we saw earlier in the software catalog. This creates a *component* named `backend` of *component-type* `java`.

`odo create java backend --binary target/wildwest-1.0.jar`{{execute}}

As the container is created, `odo` will print status like the following:

```
✓  Checking component
✓  Checking component version
Please use `odo push` command to create the component with source deployed
```

The component is not yet deployed on OpenShift. With an `odo create` command, a configuration file called `config.yaml` has been created that contains information about the component to be deployed and the container the component will be hosted on.

View the contents of `config.yaml` by running the following:

`odo config view`{{execute}}

Since `backend` is a binary component, as specified in the `odo create` command above, changes to the component's source code should be followed by pushing the jar file to a running container. After `mvn` compiled a new `wildwest-1.0.jar` file, the program would be deployed to OpenShift with the `odo push` command. We can execute such a `push` right now:

`odo push`{{execute}}

As the push is progressing, `odo` will print:

```
✓  Checking component
✓  Checking component version
✓  Creating java component with name backend
✓  Initializing 'backend' component
✓  Creating component backend
✓  Successfully created component backend
✓  Applying component settings to component: backend
✓  The component backend was updated successfully
✓  Successfully updated component with name: backend
✓  Pushing changes to component: backend of type binary
✓  Waiting for component to start
✓  Copying files to component
✓  Building component
✓  Changes successfully pushed to component: backend
```

Using `odo push`, OpenShift has created a container with the server ready to have your application deployed to it, deployed the container into a Pod running on the OpenShift cluster, and deployed the `backend` component to the container. The backend component is started up after its deployment.

If you want to check on the status of an action in `odo`, you can use the `log` command. Let's run that now to follow the progress of our `push` command:

`odo log -f`{{execute}}

You should see output similar to the following to confirm the `backend` is running on a container in a Pod in the OpenShift environment:

```
2019-05-13 12:32:15.986  INFO 729 --- [           main] c.o.wildwest.WildWestApplication         : Started WildWestApplication in 6.337 seconds (JVM running for 7.779)
```

The jar file has now been pushed to the container and is running.

Exit the logs by running the following:

`<ctrl+c>`{{execute}}
