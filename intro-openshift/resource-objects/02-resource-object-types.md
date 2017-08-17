Now that you have created an application to work with, the list of key resource objects which have been created within the project can be listed using the:

``oc get all``{{execute}}

command. The output you will see from running this command will be similar to the following:

```
NAME          DOCKER REPO                             TAGS      UPDATED
is/parksmap   172.30.204.23:5000/myproject/parksmap   1.0.0     6 seconds ago

NAME          REVISION   DESIRED   CURRENT   TRIGGERED BY
dc/parksmap   1          1         0         config,image(parksmap:1.0.0)

NAME            DESIRED   CURRENT   READY     AGE
rc/parksmap-1   0         0         0         5s

NAME              HOST/PORT                                                            PATH      SERVICES   PORT       TERMINATION
routes/parksmap   parksmap-myproject.2886795339-80-ollie01.environments.katacoda.com             parksmap   8080-tcp

NAME           CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
svc/parksmap   172.30.247.188   <none>        8080/TCP   30s

NAME                   READY     STATUS    RESTARTS   AGE
po/parksmap-1-deploy   0/1       Pending   0          5s
```

You can restrict the output to just the names of the resources by running:

``oc get all -o name``{{execute}}

In other words, supply the ``-o name`` option to change the output format.

```
imagestreams/parksmap
deploymentconfigs/parksmap
replicationcontrollers/parksmap-1
routes/parksmap
services/parksmap
pods/parksmap-1-deploy
```

The ``oc get`` command is the most basic command that exists in OpenShift for querying resource objects. You will use it a lot, so you should become familiar with it, as well as how to update resource objects.

In addition to being able to use the special name ``all`` to query information about the key resource object types, you can also list specific object types by name. You can for example get a list of the routes created when applications have been exposed by running:

``oc get routes``{{execute}}

For the application you have deployed, you should see something like:

```
NAME       HOST/PORT                                                            PATH      SERVICES   PORT       TERMINATION
parksmap   parksmap-myproject.2886795339-80-ollie01.environments.katacoda.com             parksmap   8080-tcp
```

You can get a list of all the different resource object types you can query by running

``oc get``{{execute}}

without any specific object type listed. This will output

```
You must specify the type of resource to get. Valid resource types include:

    * all
    * buildconfigs (aka 'bc')
    * builds
    ...
    * users
    * storageclasses
    * thirdpartyresources
    error: Required resource not specified.
Use "oc explain <resource>" for a detailed description of that resource (e.g. oc explain pods).
See 'oc get -h' for help and examples.
```

In addition to being able to be queried using their full name, many resource object types can be queried using a shorter alias. You can therefore use ``bc`` instead of ``buildconfigs``.

In all cases where the ``type`` of a resource object is listed as a plural, you can also use the ``type`` in its singular form. You can therefore use ``route`` instead of ``routes``.

A high level description of the main resource object types, and other concepts, can be obtained by running the:

``oc types``{{execute}}

command.

```
Concepts and Types

Kubernetes and OpenShift help developers and operators build, test, and deploy
applications in a containerized cloud environment. Applications may be composed
of all of the components below, although most developers will be concerned with
Services, Deployments, and Builds for delivering changes.

Concepts:

* Containers:
    A definition of how to run one or more processes inside of a portable Linux
    environment. Containers are started from an Image and are usually isolated
    from other containers on the same machine.

* Image:
    A layered Linux filesystem that contains application code, dependencies,
    and any supporting operating system libraries. An image is identified by
    a name that can be local to the current cluster or point to a remote Docker
    registry (a storage server for images).

* Pods [pod]:
    A set of one or more containers that are deployed onto a Node together and
    share a unique IP and Volumes (persistent storage). Pods also define the
    security and runtime policy for each container.

...
```
