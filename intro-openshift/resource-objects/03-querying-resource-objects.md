To get a more detailed description of a specific resource object, you can use the ``oc describe`` command.

Running ``oc describe route/coming-soon``{{execute}} would yield something similar to:

```
Name:                   coming-soon
Namespace:              myproject
Created:                5 minutes ago
Labels:                 app=coming-soon
Annotations:            openshift.io/host.generated=true
Requested Host:         coming-soon-myproject.router.default.svc.cluster.local
                          exposed on router router 5 minutes ago
Path:                   <none>
TLS Termination:        <none>
Insecure Policy:        <none>
Endpoint Port:          8080-tcp

Service:        coming-soon
Weight:         100 (100%)
Endpoints:      172.18.0.2:8080
```

Whenever passing a specific resource object as argument to an ``oc`` command, there are two conventions which can be used. The first is to use a single string of the form ``type/name``. The second is to pass the ``type`` and ``name`` as separate consecutive arguments. The command ``oc describe route coming-soon``{{execute}} is therefore equivalent.

The output produced by ``oc describe`` is intended to be a human readable format. To get the raw object details as JSON or YAML, you can use the ``oc get`` command, listing the name of the resource and the output format.

For JSON output, you can use ``oc get route/coming-soon -o json``{{execute}}.

For YAML output, you can use ``oc get route/coming-soon -o yaml``{{execute}}.

An abbreviated example of the JSON description for a ``route`` object is:

```
{
    "kind": "Route",
    "apiVersion": "v1",
    "metadata": {
        "name": "coming-soon",
        "namespace": "myproject",
        "labels": {
            "app": "coming-soon"
        },
    },
    "spec": {
        "host": "coming-soon-myproject.router.default.svc.cluster.local",
        "to": {
            "kind": "Service",
            "name": "coming-soon",
            "weight": 100
        },
        "port": {
            "targetPort": "8080-tcp"
        },
        "wildcardPolicy": "None"
    },
    ...
}
```

To see a description of the purpose of specific fields in the raw object, you can use the ``oc explain`` command, providing it with a path selector for the field.

To see the description of the ``host`` field of the ``spec`` object, you can run ``oc explain route.spec.host``{{execute}}:

```
FIELD: host <string>

DESCRIPTION:
     host is an alias/DNS that points to the service. Optional. If not specified
     a route name will typically be automatically chosen. Must follow DNS952
     subdomain conventions.
```
