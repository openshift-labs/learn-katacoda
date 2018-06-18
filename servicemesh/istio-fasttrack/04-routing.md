This task shows you how to configure dynamic request routing based on weights and HTTP headers.

_Route rules_ control how requests are routed within an Istio service mesh. Route rules provide:

* **Timeouts**
* **Bounded retries** with timeout budgets and variable jitter between retries
* **Limits** on number of concurrent connections and requests to upstream services
* **Active (periodic) health checks** on each member of the load balancing pool
* **Fine-grained circuit breakers** (passive health checks) – applied per instance in the load balancing pool

Requests can be routed based on
the source and destination, HTTP header fields, and weights associated with individual service versions.
For example, a route rule could route requests to different versions of a service.

Together, these features enable the service mesh to tolerate failing nodes and prevent localized failures from cascading instability to other nodes.
However, applications must still be designed to take appropriate fallback actions.

For example, when all instances in a load balancing pool have failed, Istio will return HTTP 503. It is
the responsibility of the application to implement any fallback logic that is needed to handle the HTTP
503 error code from an upstream service. However, you as the developer do not need to write the code that
handles the monitoring and retrying and network failure handling that you previously needed. Score!

If your application already provides some defensive measures (e.g. using [Netflix Hystrix](https://github.com/Netflix/Hystrix)), then that's OK:
Istio is completely transparent to the application. A failure response returned by Istio would not be
distinguishable from a failure response returned by the upstream service to which the call was made.

## Service Versions
Istio introduces the concept of a service version, which is a finer-grained way to subdivide
service instances by versions (`v1`, `v2`) or environment (`staging`, `prod`). These variants are not
necessarily different API versions: they could be iterative changes to the same service, deployed
in different environments (prod, staging, dev, etc.). Common scenarios where this is used include
A/B testing or canary rollouts. Istio’s [traffic routing rules](https://istio.io/docs/concepts/traffic-management/rules-configuration.html) can refer to service versions to
provide additional control over traffic between services.

![Versions](/openshift/assets/middleware/resilient-apps/versions.png)

As illustrated in the figure above, clients of a service have no knowledge of different versions of the service. They can continue to access the services using the hostname/IP address of the service. The Envoy sidecar/proxy intercepts and forwards all requests/responses between the client and the service.

## RouteRule objects
In addition to the usual OpenShift object types like `BuildConfig`, `DeploymentConfig`, `Service` and `Route`,
you also have new object types installed as part of Istio like `RouteRule`. Adding these objects to the running
OpenShift cluster is how you configure routing rules for Istio.

## Install a default route rule
Because the Bookinfo sample deploys 3 versions of the reviews microservice, we need to set a default route.
Otherwise if you access the application several times, you’ll notice that sometimes the output contains star
ratings. This is because without an explicit default version set, Istio will route requests to all available
versions of a service in a random fashion, and anytime you hit `v1` version you'll get no stars.

First, let's set an environment variable to point to Istio:

`export ISTIO_VERSION=0.6.0; export ISTIO_HOME=${HOME}/istio-${ISTIO_VERSION}; export PATH=${PATH}:${ISTIO_HOME}/bin; cd ${ISTIO_HOME}`{{execute T1}}

Now let's install a default set of routing rules which will direct all traffic to the `reviews:v1` service version:

`oc create -f samples/bookinfo/kube/route-rule-all-v1.yaml`{{execute T1}}

You can see this default set of rules with:

`oc get routerules -o yaml`{{execute T1}}

There are default routing rules for each service, such as the one that forces all traffic to the `v1` version of the `reviews` service:

`oc get routerules/reviews-default -o yaml`{{execute T1}}

```yaml
    apiVersion: config.istio.io/v1alpha2
    kind: RouteRule
    metadata:
      name: reviews-default
      namespace: default
      ...
    spec:
      destination:
        name: reviews
      precedence: 1
      route:
      - labels:
          version: v1
```

Now, access the application again in your browser using the below link and reload the page several times - you should not see any rating stars since `reviews:v1` does not access the `ratings` service.

* [Bookinfo Application with no rating stars](http://istio-ingress-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/productpage)

To verify this, open the Grafana Dashboard:

* [Grafana Dashboard](http://grafana-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/dashboard/db/istio-dashboard)

Scroll down to the `ratings` service and notice that the requests coming from the reviews service have stopped:

![Versions](/openshift/assets/middleware/resilient-apps/ratings-stopped.png)

## A/B Testing with Istio
Lets enable the ratings service for a test user named “jason” by routing `productpage` traffic to `reviews:v2`, but only for our test user. Execute:

`oc create -f samples/bookinfo/kube/route-rule-reviews-test-v2.yaml`{{execute T1}}

Confirm the rule is created:

`oc get routerule reviews-test-v2 -o yaml`{{execute T1}}

Notice the `match` element:

```yaml
  match:
    request:
      headers:
        cookie:
          regex: ^(.*?;)?(user=jason)(;.*)?$
```

This says that for any incoming HTTP request that has a cookie set to the `jason` user to direct traffic to
`reviews:v2`.

Now, [access the application](http://istio-ingress-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/productpage) and click **Sign In** (at the upper right) and sign in with:

* Username: `jason`
* Password: `jason`

> If you get any certificate security exceptions, just accept them and continue. This is due to the use of self-signed certs.

Once you login, refresh a few times - you should always see the black ratings stars coming from `ratings:v2`. If you logout,
you'll return to the `reviews:v1` version which shows no stars. You may even see a small blip of access to `ratings:v2` on the
Grafana dashboard if you refresh quickly 5-10 times while logged in as the test user `jason`.

![Ratings for Test User](/openshift/assets/middleware/resilient-apps/ratings-testuser.png)

## Congratulations!

In this step, you used Istio to send 100% of the traffic to the v1 version of each of the Bookinfo services.
You then set a rule to selectively send traffic to version v2 of the reviews service based on a header
(i.e., a user cookie) in a request.

Once the v2 version has been tested to our satisfaction, we could use Istio to send traffic from all users to
v2, optionally in a gradual fashion. We’ll explore this in the next step.
