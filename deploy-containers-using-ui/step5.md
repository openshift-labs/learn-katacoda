NO IDEA?!

With the application running, it's possible to apply rolling updates to ensure deployments never taken the application offline.

Deploying a new version of the container is completed by re-tagging the application with a new Docker Image.

In this case, we're tagging our application _ws-app1:openshift-v1_ to the v2 version of the Docker Image.

`oc tag --source=docker katacoda/docker-http-server:openshift-v2 ws-app1:openshift-v1`{{execute}}

The status and history of the deployment can be viewed using the command `oc describe dc ws-app1`{{execute}}.

You can see new Pods being deployed via `oc get pods`{{execute}}

Over time you should see the response of the service changing from V1 to V2.

`curl ws-app1-default.router.default.svc.cluster.local`{{execute}}
