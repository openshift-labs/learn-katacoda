With one of the Pods running in a health state, it's possible to simulate a failure occurring.

At present, no crashes should have occurred.
`oc get pods --selector="name=frontend"`{{execute}}

## Crash Service

The HTTP server has an additional endpoint that will cause it to return 500 errors. Using _oc exec_ it's possible to call the endpoint.

`pod=$(oc get pods --selector="name=frontend" --output=jsonpath={.items..metadata.name})
oc exec $pod -- /usr/bin/curl -s localhost:8080/unhealthy`{{execute}}

## Liveness

Based on the configuration, OpenShift will execute the Liveness Probe. If the Probe fails, OpenShift will destroy and re-create the failed container. Execute the above command to crash the service and watch OpenShift recover it automatically.

`oc get pods --selector="name=frontend"`{{execute}}

The check may take a few moments to detect. When OpenShift detects that it's entered into an unhealthy state, it will restart the Pod in an attempt to bring it back to life. If you run _get pods_ multiple times, you'll see the restart count increase.

To find out more details of why it's failing, describe the Pod to view the event details.

`pod=$(oc get pods --selector="name=frontend" --output=jsonpath={.items..metadata.name})
oc describe pod $pod
`{{execute}}

Using these probes it's possible to have a self-healing system, knowing when to automatically restart applications which are failing.
