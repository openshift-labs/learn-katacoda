
In these exercises you will learn to scale up an application, by increasing the number of *Pods* running which contain your application. You will also see what happens when you kill an instance of your application.

### Background: Deployments and Replication Controllers

While *Services* provide routing and load balancing for *Pods*, which may go in and
out of existence, *ReplicationControllers* (RC) are used to specify and then
ensure the desired number of *Pods* (replicas) are in existence. For example, if
you always want your application server to be scaled to 3 *Pods* (instances), a
*ReplicationController* is needed. Without a RC, any *Pods* that are killed or
somehow die/exit are not automatically restarted. *ReplicationControllers* are
how OpenShift "self heals".

Building on replication controllers, OpenShift adds expanded support for the
software development and deployment lifecycle with the concept of a *DeploymentConfig* (DC).
In the simplest case, a deployment just creates a new replication controller and
lets it start up pods. However, OpenShift deployments also provide the ability
to transition from an existing deployment of an image to a new one and also define hooks to be run before or after creating the replication controller.

In almost all cases, you will end up using the *Pod*, *Service*,
*ReplicationController* and *DeploymentConfig* resources together. And, in
almost all of those cases, OpenShift will create all of them for you.

### Exercise: Exploring the Objects Created by a Deployment

Now that you understand what a *ReplicatonController* and
*DeploymentConfig* are, you can explore how they work and are related. Take a
look at the *DeploymentConfig* (DC) that was created for you when you told
OpenShift to deploy the `parksmap-py` image. You can get a list of the *DeploymentConfig* objects in the current project by running:

``oc get dc``{{execute}}

This should output:

```
NAME          REVISION   DESIRED   CURRENT   TRIGGERED BY
parksmap-py   1          1         1         config,image(parksmap-py:1.0.0)
```

To get more details, you can look into the *ReplicationController* (RC).

Take a look at the *ReplicationController* (RC) that was created for you when
you told OpenShift to deploy the `parksmap-py` image. You can get a list of the *ReplicationController* objects in the current project by running:

``oc get rc``{{execute}}

This should output:

```
NAME            DESIRED   CURRENT   READY     AGE
parksmap-py-1   1         1         1         2m
```

This lets you know that, right now, it is expected that one *Pod* should be running
(`Desired`), and that one *Pod* is actually deployed (`Current`). By changing
the desired number, you can tell OpenShift how many *Pods*, or instances of your application you want running.

### Exercise: Scaling Up the Application

To scale the application up to 2 instances you can use
the `oc scale` command. You could also do this by clicking the "up" arrow next to
the *Pod* circle in the OpenShift web console on the overview page. To use the command line run:

``oc scale --replicas=2 dc/parksmap-py``{{execute}}

To verify that the number of replicas has changed, run the ``oc get rc`` command.

``oc get rc``{{execute}}

```
NAME            DESIRED   CURRENT   READY     AGE
parksmap-py-1   2         2         2         3m
```

You should see that you now have 2 replicas. Verify this by listing the *Pods*.

``oc get pods``{{execute}}

You should see two *Pods* listed, one being the *Pod* originally created when the application was first deployed, and the other one having just been created.

```
NAME                  READY     STATUS    RESTARTS   AGE
parksmap-py-1-j3mgx   1/1       Running   0          1m
parksmap-py-1-713cw   1/1       Running   0          4m
```

You can also verify that the *Service* now lists the two endpoints.

``oc describe service/parksmap-py``{{execute}}

You will see something like the following output:

```
Name:                   parksmap-py
Namespace:              myproject
Labels:                 app=parksmap-py
Annotations:            openshift.io/generated-by=OpenShiftWebConsole
Selector:               deploymentconfig=parksmap-py
Type:                   ClusterIP
IP:                     172.30.17.45
Port:                   8080-tcp        8080/TCP
Endpoints:              172.20.0.3:8080,172.20.0.5:8080
Session Affinity:       None
Events:                 <none>
```

Another way to get a list of the endpoints is by running:

``oc get endpoints parksmap-py``{{execute}}

You will see something like the following:

```
NAME          ENDPOINTS                         AGE
parksmap-py   172.20.0.3:8080,172.20.0.5:8080   5m
```

Your IP addresses will likely be different, as each pod receives a unique IP
within the OpenShift environment. The endpoint list is a quick way to see how
many pods are behind a service.

You can also see that two *Pods* are running using the web console:

![Application Scaling](../../assets/introduction/training-workshop/03-overview-of-scaled-application.png)

Overall, that's how simple it is to scale an application (*Pods* in a
*Service*). Application scaling can happen extremely quickly because OpenShift
is just launching new instances of an existing image, especially if that image
is already cached on the node.

### Exercise: Application "Self Healing"

Because OpenShift's *RCs* are constantly monitoring to see that the desired number
of *Pods* actually is running, you might also expect that OpenShift will "fix" the
situation if it is ever not right. You would be correct!

Since you have two *Pods* running right now, let's see what happens if you
"accidentally" kill one. Run the following command to delete one of the *Pods* and immediately query the list of *Pods*.

``oc delete `oc get pods -o name | head -1` && oc get pods``{{execute}}

You will see output similar to:


```
pod "parksmap-py-1-0pp6v" deleted
NAME                  READY     STATUS              RESTARTS   AGE
parksmap-py-1-j3mgx   1/1       Terminating         0          2m
parksmap-py-1-8kfg3   0/1       ContainerCreating   0          0s
parksmap-py-1-j3mgx   1/1       Running             0          5m
```

Did you notice anything? There is a container being terminated (the one you deleted),
and there's a new container already being created.

Also, the names of the *Pods* are slightly changed.
That's because OpenShift almost immediately detected that the current state (1
*Pod*) didn't match the desired state (2 *Pods*), and it fixed it by scheduling
another *Pod*.

In addition to handling the case of a *Pod* being terminated, OpenShift provides rudimentary capabilities around checking the
liveness and/or readiness of application instances. If the basic checks are
insufficient, OpenShift also allows you to run a command inside the container in
order to perform the check. That command could be a complicated script that uses
any installed language.

Based on these health checks, if OpenShift decided that the
application instance wasn't alive, it would kill the instance and then restart
it, always ensuring that the desired number of replicas was in place.

### Exercise: Scaling Down the Application

Before continuing, scale down the application to a single replica.

``oc scale --replicas=1 dc/parksmap-py``{{execute}}
