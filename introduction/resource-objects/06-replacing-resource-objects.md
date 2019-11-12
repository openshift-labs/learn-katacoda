The ``oc create`` command allows you to create a new resource object from a JSON or YAML definition contained in a file. To change an existing resource object using ``oc edit`` was an interactive process. To be able to change an existing resource from a JSON or YAML definition contained in a file, you can use the ``oc replace`` command.

To disallow an insecure route you create a modified definition of the route object:

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
            "insecureEdgeTerminationPolicy": "Redirect"
        }
    }
}
!``{{execute}}

and then run:

``oc replace -f parksmap-fqdn.json``{{execute}}

In order for ``oc replace`` to target the correct resource object, the ``metadata.name`` value of the JSON or YAML definition must be the same as that to be changed.

To script the updating of a value in an existing resource object using ``oc replace``, it is necessary to fetch the definition of the existing resource object using ``oc get``. The definition can then be edited and ``oc replace`` used to update the existing resource object.

To edit the definition will require a way of editing the JSON or YAML definition on the fly. The alternative to this process is to use the ``oc patch`` command, which will edit a value in place for you based on a supplied specification.

The ``route.spec.tls.insecureEdgeTerminationPolicy`` value could for example be switched back to allowing an insecure route by running:

``oc patch route/parksmap-fqdn --patch '{"spec":{"tls": {"insecureEdgeTerminationPolicy": "Allow"}}}'``{{execute}}

For both cases, the resource object to be updated must already exist or the command will fail. If you do not know whether the resource object will already exist, and want it updated if it does, but created if it does not, instead of using ``oc replace``, you can use ``oc apply``.
