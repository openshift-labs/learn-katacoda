When you deploy an application using ``oc new-app`` a label is automatically applied to the resource objects created. The name of the label is ``app`` and it will be set to the name of the application. This label can be used to select a subset of resource objects when running queries.

When you have multiple applications deployed, you can list all resource objects related to a specific application using the command ``oc get all``, passing the command a selector which describes the label to match.

To query the resources just for the application you deployed run:

``oc get all -o name --selector app=coming-soon``{{execute}}

This should yield:

```
buildconfig/coming-soon
build/coming-soon-1
imagestream/coming-soon
imagestream/s2i-httpd-server
deploymentconfig/coming-soon
replicationcontroller/coming-soon-1
route/coming-soon
route/coming-soon-fqdn
service/coming-soon
pod/coming-soon-1-a41rm
```

If you need to apply additional labels to a resource object you can use the ``oc label`` command.

To add the label ``web`` to the service object for you application, and give it the value ``true``, run:

``oc label service/coming-soon web=true``{{execute}}

Then query all resource objects with just that label.

``oc get all -o name --selector web=true``{{execute}}

Only the service object should be returned in the output.

Labels are useful when exporting a set of resource objects to use as the basis for creating a template.

``oc export is,dc,svc,route --selector app=coming-soon -o json --as-template=coming-soon``{{execute}}
