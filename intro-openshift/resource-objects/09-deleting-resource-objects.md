If you need to delete an entire application, or just a single resource, you can use the ``oc delete`` command. Specific resource objects can be deleted by their names, or by matching on a subset of resource objects using labels.

To delete a single resource object by name supply the name:

``oc delete route/coming-soon-fqdn``{{execute}}

To delete all resources objects of a specific type using labels, supply the resource object type name and the selector.

``oc delete route --selector app=coming-soon``{{execute}}

When using a label selector, you can list more than one resource object type name by separating them with a comma.

``oc delete svc,route --selector app=coming-soon``{{execute}}

The short cut of ``all`` can also be used to match all key resource objects types that are directly associated with the build and deployment of an application.

``oc delete all --selector app=coming-soon``{{execute}}

A resource object type, or value of ``all`` can be used without a label selector, however it is necessary to also supply the ``--all`` option to confirm that you do really wish to delete the resources objects. This is because it will delete all resource objects in the project matched by ``all``.

``oc delete all --all``{{execute}}

This last one will actually show that there are no resource to delete, but that is only because you had already deleted them with the previous commands.

It is recommended that before deleting any resource objects, you use ``oc get`` with the same parameters to confirm what would be deleted.
