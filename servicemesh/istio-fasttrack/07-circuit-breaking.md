In this step you will configure an Istio Circuit Breaker to protect the calls from `reviews` to `ratings` service.
If the `ratings` service gets overloaded due to call volume, Istio (in conjunction with Kubernetes) will limit
future calls to the service instances to allow them to recover.

Circuit breaking is a critical component of distributed systems.
It’s nearly always better to fail quickly and apply back pressure downstream
as soon as possible. Istio enforces circuit breaking limits at the network
level as opposed to having to configure and code each application independently.

Istio supports various types of circuit breaking:

* **Cluster maximum connections**: The maximum number of connections that Istio will establish to all hosts in a cluster.
* **Cluster maximum pending requests**: The maximum number of requests that will be queued while waiting for a
ready connection pool connection.
* **Cluster maximum requests**: The maximum number of requests that can be outstanding to all hosts in a
cluster at any given time. In practice this is applicable to HTTP/2 clusters since HTTP/1.1 clusters are
governed by the maximum connections circuit breaker.
* **Cluster maximum active retries**: The maximum number of retries that can be outstanding to all hosts
in a cluster at any given time. In general Istio recommends aggressively circuit breaking retries so that
retries for sporadic failures are allowed but the overall retry volume cannot explode and cause large
scale cascading failure.

> Note that HTTP 2 uses a single connection and never queues (always multiplexes), so max connections and
max pending requests are not applicable.

Each circuit breaking limit is configurable and tracked on a per upstream cluster and per priority basis.
This allows different components of the distributed system to be tuned independently and have different limits.
See the [Istio Circuit Breaker Spec](https://istio.io/docs/reference/config/traffic-rules/destination-policies.html#istio.proxy.v1.config.CircuitBreaker) for more details.

## Enable Circuit Breaker
Let's add a circuit breaker to the calls to the `ratings` service. Instead of using a _RouteRule_ object,
circuit breakers in Istio are defined as _DestinationPolicy_ objects. DestinationPolicy defines client/caller-side policies
that determine how to handle traffic bound to a particular destination service. The policy specifies
configuration for load balancing and circuit breakers.

Add a circuit breaker to protect calls destined for the `ratings` service:

```
oc create -f - <<EOF
    apiVersion: config.istio.io/v1alpha2
    kind: DestinationPolicy
    metadata:
      name: ratings-cb
    spec:
      destination:
        name: ratings
        labels:
          version: v1
      circuitBreaker:
        simpleCb:
          maxConnections: 1
          httpMaxPendingRequests: 1
          httpConsecutiveErrors: 1
          sleepWindow: 15m
          httpDetectionInterval: 10s
          httpMaxEjectionPercent: 100
EOF
```{{execute T1}}

We set the `ratings` service's maximum connections to 1 and maximum pending requests to 1. Thus, if we send more
than 2 requests within a short period of time to the reviews service, 1 will go through, 1 will be pending,
and any additional requests will be denied until the pending request is processed. Furthermore, it will detect any hosts that
return a server error (5XX) and eject the pod out of the load balancing pool for 15 minutes. You can visit
here to check the
[Istio spec](https://istio.io/docs/reference/config/traffic-rules/destination-policies.html#istio.proxy.v1.config.CircuitBreaker.SimpleCircuitBreakerPolicy)
for more details on what each configuration parameter does.

## Overload the service
Let's use some simple `curl` commands to send multiple concurrent requests to our application, and witness the
circuit breaker kicking in opening the circuit.

Execute this to simulate a number of users attempting to access the application simultaneously:


```
    for i in {1..10} ; do
        curl 'http://istio-ingress-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/productpage?foo=[1-1000]' >& /dev/null &
    done
```{{execute T2 interrupt}}

Due to the very conservative circuit breaker, many of these calls will fail with HTTP 503 (Server Unavailable). To see this,
open the Grafana console:

* [Grafana Dashboard](http://grafana-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/dashboard/db/istio-dashboard)

Notice at the top, the increase in the number of **5xxs Responses** at the top right of the dashboard:

![5xxs](/openshift/assets/middleware/resilient-apps/5xxs.png)

Below that, in the **Service Mesh** section of the dashboard observe that the services are returning 503 (Service Unavailable) quite a lot:

![5xxs](/openshift/assets/middleware/resilient-apps/5xxs-services.png)

That's the circuit breaker in action, limiting the number of requests to the service. In practice your limits would be much higher.

### Stop overloading

Before moving on, stop the traffic generator by clicking here to stop them:

`for i in {1..10} ; do kill %${i} ; done`{{execute T2 interrupt}}

## Pod Ejection

In addition to limiting the traffic, Istio can also forcibly eject pods out of service if they are running slowly
or not at all. To see this, let's deploy a pod that doesn't work (has a bug).

First, let's define a new circuit breaker, very similar to the previous one but without the arbitrary connection
limits. To do this, execute:

```
oc replace -f - <<EOF
    apiVersion: config.istio.io/v1alpha2
    kind: DestinationPolicy
    metadata:
      name: ratings-cb
    spec:
      destination:
        name: ratings
        labels:
          version: v1
      circuitBreaker:
        simpleCb:
          httpConsecutiveErrors: 1
          sleepWindow: 15m
          httpDetectionInterval: 10s
          httpMaxEjectionPercent: 100
EOF
```{{execute T1}}

This policy says that if any instance of the `ratings` service fails more than once, it will be ejected for
15 minutes.

Next, deploy a new instance of the `ratings` service **which has been misconfigured** and will return a failure
(HTTP 500) value for any request. Execute:

`${ISTIO_HOME}/bin/istioctl kube-inject -f ~/broken.yaml | oc create -f -`{{execute T1}}

Verify that the broken pod has been added to the `ratings` load balancing service:

`oc get pods -l app=ratings`{{execute T1}}

You should see 2 pods, including the broken one:

```console
NAME                                 READY     STATUS    RESTARTS   AGE
ratings-v1-3080059732-5ts95          2/2       Running   0          3h
ratings-v1-broken-1694306571-c6zlk   2/2       Running   0          7s
```

Wait for the deployment of the broken pod to complete:

`oc rollout status -w deployment/ratings-v1-broken`{{execute T1}}

Then save the name of this pod to an environment variable:

`BROKEN_POD_NAME=$(oc get pods -l app=ratings,broken=true -o jsonpath='{.items[?(@.status.phase=="Running")].metadata.name}')`{{execute T1}}

Requests to the `ratings` service will be load-balanced across these two pods. The circuit breaker will
detect the failures in the broken pod and eject it from the load balancing pool for a minimum of 15 minutes.
In the real world this would give the failing pod a chance to recover or be killed and replaced. For mis-configured
pods that will never recover, this means that the pod will very rarely be accessed (once every 15 minutes,
and this would also be very noticeable in production environment monitoring like those we are
using in this workshop).

To trigger this, simply access the application:

* [Application Link](http://istio-ingress-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/productpage)

Reload the webpage 5-10 times (click the reload icon, or press `CMD-R`, or `CTRL-R`) and notice that you
only see a failure (no stars) ONE time, due to the
circuit breaker's policy for `httpConsecutiveErrors=1`.  After the first error, the pod is ejected from
the load balancing pool for 15 minutes and you should see red stars from now on.

Verify that the broken pod only received one request that failed:

`oc logs -c ratings $BROKEN_POD_NAME`{{execute T1}}

You should see:

```console
Server listening on: http://0.0.0.0:9080
GET /ratings/0
```

You should see one and only one `GET` request, no matter how many times you reload the webpage.
This indicates that the pod has been ejected from the load balancing pool and will not be accessed
for 15 minutes. You can also see this in the Prometheus logs for the Istio Mixer. Open the Prometheus query
console:

* [Prometheus UI](http://prometheus-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com)

In the “Expression” input box at the top of the web page, enter the text: `envoy_cluster_out_ratings_istio_system_svc_cluster_local_http_version_v1_outlier_detection_ejections_active` and click
**Execute**. This expression refers to the number of _active ejections_ of pods from the `ratings:v1` destination that have failed more than the value of the `httpConsecutiveErrors` which
we have set to 1 (one).

Then, click the Execute button.

You should see a result of `1`:

![5xxs](/openshift/assets/middleware/resilient-apps/prom-outlier.png)

In practice this means that the failing pod will not receive any traffic for the timeout period, giving it a chance
to recover and not affect the user experience.

## Congratulations!

Circuit breaking is a critical component of distributed systems. When we apply a circuit breaker to an
entity, and if failures reach a certain threshold, subsequent calls to that entity should automatically
fail without applying additional pressure on the failed entity and paying for communication costs.

In this step you implemented the Circuit Breaker microservice pattern without changing any of the application code.
This is one additional way to build resilient applications, ones designed to deal with failure rather than go to great lengths
to avoid it.

In the next step, we will explore rate limiting, which can be useful to give different service levels to
different customers based on policy and contractual requirements.

#### Before moving on

Before moving on, in case your simulated user loads are still running, kill them with:

`for i in {1..10} ; do kill %${i}; done`{{execute T2}}

## More references

* [Istio Documentation](https://istio.io/docs)
* [Christian Posta's Blog on Envoy and Circuit Breaking](http://blog.christianposta.com/microservices/01-microservices-patterns-with-envoy-proxy-part-i-circuit-breaking/)
