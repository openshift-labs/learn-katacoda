## Readiness Error

The Pod, _bad-frontend_ is an HTTP service that will return a 500 error indicating it hasn't started correctly. You can view the status of the Pod with `oc get pods --selector="name=bad-frontend"`{{execute}}

While the Pod will have a status of _Running_, _0_ pods will be ready. That's because Liveness check hasn't successfully completed indicating it hasn't started yet.

To find out more details of why it's failing, describe the Pod.

`pod=$(oc get pods --selector="name=bad-frontend" --output=jsonpath={.items..metadata.name})
oc describe pod $pod
`{{execute}}


## Readiness OK

The other Pod, _frontend_, returns an OK status on launch. As such the pod will be _Running_ with _1_ pod ready.

`oc get pods --selector="name=frontend"`{{execute}}

Using these probes will ensure that applications are not delivered traffic before they're ready.
