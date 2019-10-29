When you deploy an application using ``oc new-app`` a label is automatically applied to the resource objects created. The name of the label is ``app`` and it will be set to the name of the application. This label can be used to select a subset of resource objects when running queries.

When you have multiple applications deployed, you can list all resource objects related to a specific application using the command ``oc get all``, passing the command a selector which describes the label to match.

To query the resources just for the application you deployed run:

``oc get all -o name --selector app=parksmap``{{execute}}

This should yield:

```
pod/parksmap-1-dvsqf
replicationcontroller/parksmap-1
service/parksmap
deploymentconfig.apps.openshift.io/parksmap
imagestream.image.openshift.io/parksmap
route.route.openshift.io/parksmap
route.route.openshift.io/parksmap-fqdn
```

If you need to apply additional labels to a resource object you can use the ``oc label`` command.

To add the label ``web`` to the service object for your application, and give it the value ``true``, run:

``oc label service/parksmap web=true``{{execute}}

Then query all resource objects with just that label.

``oc get all -o name --selector web=true``{{execute}}

Only the service object should be returned in the output.

To remove a label from a resource object you can use:

``oc label service/parksmap web-``{{execute}}

The label declaration in this command is of the form ``name-``. The trailing ``-``, rather than ``=value`` indicates the label should be removed.
