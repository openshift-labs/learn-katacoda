Deployed applications are not accessible outside of the cluster. To simplify access and configuration to services, OpenShift is configured with a Router that maps URLs to exposed services. By default, each URL is defined based on the application name and context. The URL format follows &lt;app-name&gt;-&lt;context&gt;.&lt;top-level-dns-name&gt;. OpenShift assigns the top level DNS name _default.svc.cluster.local_ which is customisable when the cluster starts.

The application deployed was assigned the name _docker-http-server_ and deployed into the _default_ context.


## Task

1) Visit the overview page.  https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com/console/project/webapp/overview

2) From here there is a link in the top right called **Create Route**.

3) This page enables you to create a route configuration. The defaults will define a route URL which directs traffic to the service. Click the **Create** button to accept the defaults.

4) This will have created a link called _docker-http-server-webapp.router.default.svc.cluster.local_. It can be accessed via `curl docker-http-server-webapp.router.default.svc.cluster.local`{{execute}}

The OpenShift Router will receive the request. The router proxies the request to the underlying service to be processed by individual pods.
