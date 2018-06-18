This step shows how to inject faults and test the resiliency of your application.

Istio provides a set of failure recovery features that can be taken advantage of by the services
in an application. Features include:

* Timeouts
* Bounded retries with timeout budgets and variable jitter between retries
* Limits on number of concurrent connections and requests to upstream services
* Active (periodic) health checks on each member of the load balancing pool
* Fine-grained circuit breakers (passive health checks) – applied per instance in the load balancing pool

These features can be dynamically configured at runtime through Istio’s traffic management rules.

A combination of active and passive health checks minimizes the chances of accessing an unhealthy service.
When combined with platform-level health checks (such as readiness/liveness probes in OpenShift), applications
can ensure that unhealthy pods/containers/VMs can be quickly weeded out of the service mesh, minimizing the
request failures and impact on latency.

Together, these features enable the service mesh to tolerate failing nodes and prevent localized failures
from cascading instability to other nodes.

## Fault Injection
While Istio provides a host of failure recovery mechanisms outlined above, it is still imperative to test the
end-to-end failure recovery capability of the application as a whole. Misconfigured failure
recovery policies (e.g., incompatible/restrictive timeouts across service calls) could result
in continued unavailability of critical services in the application, resulting in poor user experience.

Istio enables protocol-specific fault injection into the network (instead of killing pods) by
delaying or corrupting packets at TCP layer.

Two types of faults can be injected: delays and aborts. Delays are timing failures, mimicking
increased network latency, or an overloaded upstream service. Aborts are crash failures that
mimic failures in upstream services. Aborts usually manifest in the form of HTTP error codes,
or TCP connection failures.

## Inject a fault
To test our application microservices for resiliency, we will inject a 7 second delay between the
`reviews:v2` and `ratings` microservices, for user `jason`. This will be a simulated bug in the code which
we will discover later.

Since the `reviews:v2` service has a
built-in 10 second timeout for its calls to the ratings service, we expect the end-to-end flow
to continue without any errors. Execute:

`oc create -f samples/bookinfo/kube/route-rule-ratings-test-delay.yaml`{{execute T1}}

And confirm that the delay rule was created:

`oc get routerule ratings-test-delay -o yaml`{{execute T1}}

Notice the `httpFault` element:

```yaml
  httpFault:
    delay:
      fixedDelay: 7.000s
      percent: 100
```

Now, [access the application](http://istio-ingress-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/productpage) and click **Login** and login with:

* Username: `jason`
* Password: `jason`

If the application’s front page was set to correctly handle delays, we expect it to load within
approximately 7 seconds. To see the web page response times, open the Developer Tools menu in
IE, Chrome or Firefox (typically, key combination `Ctrl`+`Shift`+`I` or `Alt`+`Cmd`+`I`), tab Network,
and reload the Bookinfo web page.

You will see and feel that the webpage loads in about 6 seconds:

![Delay](/openshift/assets/middleware/resilient-apps/testuser-delay.png)

The reviews section will show: **Sorry, product reviews are currently unavailable for this book**:

## Use tracing to identify the bug
The reason that the entire reviews service has failed is because our Bookinfo application has
a bug. The timeout between the `productpage` and `reviews` service is less (3s times 2 retries == 6s total)
than the timeout between the reviews and ratings service (10s). These kinds of bugs can occur in
typical enterprise applications where different teams develop different microservices independently.

Identifying this timeout mismatch is not so easy by observing the application, but is very easy when using
Istio's built-in tracing capabilities. We will explore tracing in depth later on in this scenario and re-visit
this issue.

## Fixing the bug
At this point we would normally fix the problem by either increasing the `productpage` timeout or
decreasing the `reviews` -> `ratings` service timeout, terminate and restart the fixed microservice,
and then confirm that the `productpage` returns its response without any errors.

However, we already have this fix running in `v3` of the reviews service, so we can simply fix the
problem by migrating all traffic to `reviews:v3`. We'll do this in the next step!
