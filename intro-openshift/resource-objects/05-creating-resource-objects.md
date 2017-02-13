The ``oc edit`` command would be used to change an existing resource object, it cannot be used to create a new object. To create a new object you need to use the ``oc create`` command.

The ``oc create`` option provides a generic way of creating any resource object from a JSON or YAML definition, as well as a simpler option driven method for a subset of resource object types.

If for example you wanted to create a secure route for the application with your own host name, you would create a ``coming-soon-fqdn.json`` file containing the definition of the route:

``cat > coming-soon-fqdn.json << !
{
    "kind": "Route",
    "apiVersion": "v1",
    "metadata": {
        "name": "coming-soon-fqdn",
        "labels": {
            "app": "coming-soon"
        }
    },
    "spec": {
        "host": "www.example.com",
        "to": {
            "kind": "Service",
            "name": "coming-soon",
            "weight": 100
        },
        "port": {
            "targetPort": "8080-tcp"
        },
        "tls": {
            "termination": "edge",
            "insecureEdgeTerminationPolicy": "Allow"
        }
    }
}
!``{{execute}}

To create the route from the ``coming-soon-fqdn.json`` file you would run the command:

``oc create -f coming-soon-fqdn.json``{{execute}}.

The definition for this route had a unique value for ``route.metadata.name``, which wasn't previously in use. If you now run:

``oc get routes``{{execute}}

you should see two routes listed.

```
NAME               HOST/PORT                                                              PATH   SERVICES      PORT       TERMINATION
coming-soon        coming-soon-myproject.2886795322-80-ollie01.environments.katacoda.com         coming-soon   8080-tcp
coming-soon-fqdn   www.example.com                                                               coming-soon   8080-tcp   edge/Allow
```

In the case of a route, ``oc create`` provides a sub command specifically for creating a route. You could therefore also have run ``oc create route`` using the command:

``oc create route edge coming-soon-fqdn --service coming-soon --insecure-policy Allow --hostname www.example.com``

To see the list of resource object types that ``oc create`` has more specific support for, run:

``oc create --help``{{execute}}
