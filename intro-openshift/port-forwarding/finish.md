In this course you learnt about ``oc`` commands you would use for querying and updating the resource objects that OpenShift uses to track the state of the cluster.

You can find a summary of the key commands covered below. To see more information on each ``oc`` command, run it with the ``--help`` option.

``oc types``: Shows an introduction to core OpenShift concepts and types.

``oc explain <setting-path>``: Shows a description of the purpose of a specific resource object type setting.

``oc get``: Shows a list of all the resource object types you can make queries about.

``oc get <type>``: Shows summary details of all resource objects of a specific type.

``oc get <type> --selector app=<name>``: Shows summary details of all resource objects of a type with the specified label.

``oc get <type/name>``: Show summary details of a resource object.

``oc get <type/name> -o <json|yaml>``: Shows raw details of a resource object type as JSON or YAML.

``oc get all``: Shows summary details of the key resource objects in a project. The list of resource object types matched by ``all`` includes ``buildconfigs``, ``builds``, ``imagestreams``, ``deploymentconfigs``, ``replicationcontrollers``, ``routes``, ``services`` and ``pods``.

``oc get all --selector app=<name>``: Shows summary details of the key resource objects in a project with the specified label.

``oc describe <type/name>``: Shows human readable long form description of a resource object.

``oc edit <type/name> -o <json|yaml>``: Edit the raw details of a resource object type as JSON or YAML.

``oc export <type/name> -o <json|yaml>``: Shows raw details of a resource object type as JSON or YAML where any settings not required when creating a resource object have been removed.

``oc create -f <definition.json>``: Create a resource object from a definition stored in a file. The format of the definition must be JSON or YAML. The ``metadata.name`` field of the definition must not correspond to an existing resource object.

``oc replace -f <definition.json>``: Replace the definition of a resource object with that stored in a file. The format of the definition must be JSON or YAML. The ``metadata.name`` field of the definition must correspond to an existing resource object.

``oc apply -f <definition.json>``: Replace the definition of a resource object if it exists with that stored in a file. The format of the definition must be JSON or YAML. The ``metadata.name`` field of the definition must correspond to an existing resource object. If the resource object does not already exist, it will be created.

``oc patch <type/name> --patch <patch>``: Update a resource object using a patch specification.

``oc label <type/name> <name=value>``: Add a label to a resource object.

``oc label <type/name> <name->``: Remove a label from a resource object.

``oc delete <type/name>``: Delete a resource object.

``oc delete <type> --selector app=<name>``: Delete all resource objects of a type with the specified label.

``oc delete <type> --all``: Delete all resource objects of a specific type.

``oc delete all --all``: Delete all key resource objects in a project. The list of resource object types matched by ``all`` includes ``buildconfigs``, ``builds``, ``imagestreams``, ``deploymentconfigs``, ``replicationcontrollers``, ``routes``, ``services`` and ``pods``.

``oc delete all --selector app=<name>``: Delete all key resource objects in a project with the specified label.
