The ``oc edit`` command would be used to change an existing resource object, it cannot be used to create a new object. To create a new object you need to use the ``oc create`` command.

The ``oc create`` command provides a generic way of creating any resource object from a JSON or YAML definition, as well as a simpler option driven method for a subset of resource object types.

If for example you wanted to create a secure route for the application with your own host name, you would create a ``parksmap-fqdn.json`` file containing the definition of the route:

``cat > parksmap-fqdn.json << !
{
    "kind": "Route",
    "apiVersion": "v1",
    "metadata": {
        "name": "parksmap-fqdn",
        "labels": {
            "app": "parksmap"
        }
    },
    "spec": {
        "host": "www.example.com",
        "to": {
            "kind": "Service",
            "name": "parksmap",
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

To create the route from the ``parksmap-fqdn.json`` file you would run the command:

``oc create -f parksmap-fqdn.json``{{execute}}.

The definition for this route had a unique value for ``route.metadata.name``, which wasn't previously in use. If you now run:

``oc get routes``{{execute}}

you should see two routes listed.

```
NAME            HOST/PORT                                                            PATH   SERVICES   PORT       TERMINATION   WILDCARD
parksmap        parksmap-myproject.2886795273-80-frugo03.environments.katacoda.com          parksmap   8080-tcp          None
parksmap-fqdn   www.example.com                                                             parksmap   8080-tcp   edge/Allow    None
```

In the case of a route, ``oc create`` provides a sub command specifically for creating a route. You could therefore also have run ``oc create route`` using the command:

``oc create route edge parksmap-fqdn --service parksmap --insecure-policy Allow --hostname www.example.com``

To see the list of resource object types that ``oc create`` has more specific support for, run:

``oc create --help``{{execute}}
