After the build completes, a deployment begins. This process is the same as if an existing Docker Image was used as the application source.

You can view the status of the deployment configuration with `oc get dc`{{execute}}

As the deployment starts, the Pods are launched with the newly built Docker Image. The Pod creation can be tracked via `oc get pods`{{execute}}

OpenShift has a built-in router to make it possible to give a friendly CNAME to access the server. The JSON definition for this below.
<pre>
{
    "metadata": {
        "name": "frontend"
    },
    "apiVersion": "v1",
    "kind": "Route",
    "spec": {
        "to": {
            "name": "frontend"
        }
    }
}
</pre>

Create the route using `oc create -f route.json`{{execute}}

The service can now be queried via `curl http://frontend-green-hat-store.router.default.svc.cluster.local`{{execute}}
