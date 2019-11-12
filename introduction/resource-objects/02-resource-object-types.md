Now that you have created an application to work with, the list of key resource objects which have been created within the project can be listed using the:

``oc get all``{{execute}}

command. The output you will see from running this command will be similar to the following:

```
NAME                    READY   STATUS              RESTARTS   AGE
pod/parksmap-1-deploy   1/1     Running             0          22s
pod/parksmap-1-dvsqf    0/1     ContainerCreating   0          9s

NAME                               DESIRED   CURRENT   READY   AGE
replicationcontroller/parksmap-1   1         1         0       22s

NAME               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/parksmap   ClusterIP   172.30.222.21   <none>        8080/TCP   23s

NAME                                          REVISION   DESIRED   CURRENT   TRIGGERED BY
deploymentconfig.apps.openshift.io/parksmap   1          1         1         config,image(parksmap:1.0.0)

NAME                                      IMAGE REPOSITORY TAGS    UPDATED
imagestream.image.openshift.io/parksmap   default-route-openshift-image-registry.apps-crc.testing/myproject/parksmap 1.0.0   23 seconds ago

NAME                                HOST/PORT                                                            PATH   SERVICES   PORT       TERMINATION   WILDCARD
route.route.openshift.io/parksmap   parksmap-myproject.2886795273-80-frugo03.environments.katacoda.com          parksmap   8080-tcp                 None
```

You can restrict the output to just the names of the resources by running:

``oc get all -o name``{{execute}}

In other words, supply the ``-o name`` option to change the output format.

```
pod/parksmap-1-deploy
pod/parksmap-1-dvsqf
replicationcontroller/parksmap-1
service/parksmap
deploymentconfig.apps.openshift.io/parksmap
imagestream.image.openshift.io/parksmap
route.route.openshift.io/parksmap
```

The ``oc get`` command is the most basic command that exists in OpenShift for querying resource objects. You will use it a lot, so you should become familiar with it, as well as how to update resource objects.

In addition to being able to use the special name ``all`` to query information about the key resource object types, you can also list specific object types by name. You can for example get a list of the routes created when applications have been exposed by running:

``oc get routes``{{execute}}

For the application you have deployed, you should see something like:

```
NAME       HOST/PORT                                                            PATH   SERVICES   PORT       TERMINATION   WILDCARD
parksmap   parksmap-myproject.2886795273-80-frugo03.environments.katacoda.com          parksmap   8080-tcp     None
```

You can get a list of all the different resource object types you can query by running:

``oc api-resources``{{execute}}

This will output a long list starting out as:

```
NAME                                  SHORTNAMES       APIGROUP                              NAMESPACED   KIND
bindings                                                                                     true         Binding
componentstatuses                     cs                                                     false        ComponentStatus
configmaps                            cm                                                     true         ConfigMap
endpoints                             ep                                                     true         Endpoints
events                                ev                                                     true         Event
limitranges                           limits                                                 true         LimitRange
namespaces                            ns                                                     false        Namespace
nodes                                 no                                                     false        Node
...
```

In addition to being able to be queried using their full name, many resource object types can be queried using a shorter alias. You can therefore use ``cm`` instead of ``configmaps``.

In all cases where the ``type`` of a resource object is listed as a plural, you can also use the ``type`` in its singular form. You can therefore use ``route`` instead of ``routes``.
