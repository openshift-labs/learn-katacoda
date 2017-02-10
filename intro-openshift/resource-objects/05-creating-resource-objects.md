The ``oc edi`` command would be used to change an existing resource object, it cannot be used to create a new object. To create a new object you need to use the ``oc create`` command.

The ``oc create`` option provides a generic way of creating any resource object from a JSON or YAML definition, as well as a simpler option driven method for a subset of resource object types.

If for example we wished to create a secure route for the application with our own host name, we would create a ``fqdn-route.json`` file containing the definition of the route:

```
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
```

To create the route from the ``fqdn-route.json`` file we would run the command ``oc create -f fqdn-route.json``{{execute}}. The output of the command would be the list of the resources created.

```
route "coming-soon-fqdn" created
```

The definition for this route had a unique value for ``route.metadata.name``, which wasn't previously in use. This means we now have two routes, as can be seen by running ``oc get routes``{{execute}}.

```
NAME               HOST/PORT                                                PATH      SERVICES      PORT       TERMINATION
coming-soon        coming-soon-myproject.router.default.svc.cluster.local             coming-soon   8080-tcp
coming-soon-fqdn   www.example.com                                                    coming-soon   8080-tcp   edge/Allow
```

In the case of a route, ``oc create`` provides a sub command specifically for creating a route. We could therefore also have run ``oc create route`` using the command:

``oc create route edge httpd-fqdn --service httpd --insecure-policy Allow --hostname www.example.com``

To see the list of resource object types that ``oc create`` has more specific support for, run ``oc create --help``.
