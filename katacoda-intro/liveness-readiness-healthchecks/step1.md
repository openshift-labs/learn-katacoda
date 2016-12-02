OpenShift has built-in support for testing if an application is in a health state. When an application is in an unhealthy state, OpenShift will ensure that no data is sent to the process. Instead, data will be sent to healthy

These checks, known as probes, are an important of automated deployments. When rolling out changes, they check to see if an application is ready to start receiving requests, ensuring that a minimum capacity is always available. If applications start failing after deployment, OpenShift will take this into account and can rollback to a previous version if required.

## Deploy Replication Controllers

First, deploy two controllers for managing two applications, one which starts healthy, another which causes errors. We'll just health checks to verify if they should or shouldn't process traffic.

`oc create -f deploy.yaml`{{execute}}


## Deploy Frontend checks

Use the _oc_ command line to create our readiness and liveness probes. This can also be defined in the yaml when a controller is deployed.

`oc set probe rc/frontend --readiness --get-url=http://:8080/`{{execute}}

`oc set probe rc/frontend --liveness --get-url=http://:8080/`{{execute}}


## Deploy Bad Frontend Checks

Repeat the same steps for the bad frontend. This is the application containing bugs.

`oc set probe rc/bad-frontend --readiness --get-url=http://:8080/`{{execute}}

`oc set probe rc/bad-frontend --liveness --get-url=http://:8080/`{{execute}}

## Restart Pods

For the readiness and liveness checks to be taken into account, the pods need to be restarted with the command below. The replication controller will automatically re-create the pods which will include the healthcheck probes.

```
pod=$(oc get pods --selector="name=frontend" --output=jsonpath={.items..metadata.name})
oc delete pod $pod
pod=$(oc get pods --selector="name=bad-frontend" --output=jsonpath={.items..metadata.name})
oc delete pod $pod
```{{execute}}


In the next steps you'll see how OpenShift uses these checks to verify the application health.
