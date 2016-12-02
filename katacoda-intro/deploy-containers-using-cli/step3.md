Deployed applications are not accessible outside of the cluster. The CLI command _expose_ configures a service allowing the application to receive external requests.

Services are an abstraction that allows Pods with the same name selector to receive traffic. This separation allows the underlying pods to scale up and down without upstream applications needing to be reconfigured.

## Task

Use the command `oc expose svc/ws-app1`{{execute}} to create a new service for _ws-app1_.

Each service has a unique IP address. Requests to the service will then be load balanced across the available Pods. To find the information of services, use the command `oc get svc`{{execute}}

## Access Service via URL

To simplify access to services, OpenShift is configured with a Router that maps URLs to exposed services. By default, each URL is defined based on the application name and context. The URL format follows &lt;app-name&gt;-&lt;context&gt;.&lt;top-level-dns-name&gt;. OpenShift assigns the top level DNS name _default.svc.cluster.local_ which is customisable when the cluster starts.

The application deployed was assigned the name _ws-app1_ and deployed into the _default_ context. The assigned route can be accessed with the command `curl ws-app1-default.router.default.svc.cluster.local`{{execute}}

The OpenShift Router will receive the request. The router proxies the request to the underlying service to be processed by individual pods.

Services and the router allow for the ability to load balance traffic across multiple running Pods. Scaling the running Pods will be covered in the next step.
