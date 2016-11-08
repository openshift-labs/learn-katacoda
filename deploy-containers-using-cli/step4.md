With OpenShift having an understanding of how the application is deployed, it's capable of running multiple instances of the containers. Scaling is based on the number of desired replicas of the deployment. Under the covers, OpenShift will start or stop the pods required to match the state you want.  

The CLI command is _oc scale_. An example of scaling the deployed application across three instances is `oc scale dc/ws-app1 --replicas=3`{{execute}}

The current state can be verified using `oc get dc`{{execute}}.

This will output the number of running Pods along with the desired state. A more detailed decision is available by describing the deployment configuration with the command `oc describe dc ws-app1`{{execute}}

Once all the pods are in a running state, the service will load balance all requests across the active containers. Issuing multiple requests to the URL will be processed by different Pods `curl ws-app1-default.router.default.svc.cluster.local`{{execute}}

If Pods are stopped, they'll automatically be removed from the service and stop receiving traffic.
