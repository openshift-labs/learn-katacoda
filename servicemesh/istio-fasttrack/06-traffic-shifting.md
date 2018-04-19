This step shows you how to gradually migrate traffic from an old to new version of a service.
With Istio, we can migrate the traffic in a gradual fashion by using a sequence of rules with
weights less than 100 to migrate traffic in steps, for example 10, 20, 30, … 100%. For simplicity
this task will migrate the traffic from `reviews:v1` to `reviews:v3` in just two steps: 50%, 100%.

## Remove test routes
Now that we've identified and fixed the bug, let's undo our previous testing routes. Execute:

`oc delete -f samples/bookinfo/kube/route-rule-reviews-test-v2.yaml \
           -f samples/bookinfo/kube/route-rule-ratings-test-delay.yaml`{{execute T1}}

At this point, we are back to sending all traffic to `reviews:v1`. [Access the application](http://istio-ingress-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/productpage)
and verify that no matter how many times you reload your browser, you'll always get no ratings stars, since
`reviews:v1` doesn't ever access the `ratings` service:

![no stars](/openshift/assets/middleware/resilient-apps/stars-none.png)

Open the Grafana dashboard and verify that the ratings service is receiving no traffic at all:

* [Grafana Dashboard](http://grafana-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/dashboard/db/istio-dashboard)

Scroll down to the `reviews` service and observe that all traffic from `productpage` to to `reviews:v2` and
`reviews:v3` have stopped, and that only `reviews:v1` is receiving requests:

![no traffic](/openshift/assets/middleware/resilient-apps/ratings-no-traffic.png)

In Grafana you can click on each service version below each graph to only show one graph at a time. Try it by
clicking on `productpage.istio-system-v1 -> v1 : 200`. This shows a graph of all requests coming from
`productpage` to `reviews` version `v1` that returned HTTP 200 (Success). You can then click on
`productpage.istio-system-v1 -> v2 : 200` to verify no traffic is being sent to `reviews:v2`:

![no traffic 2](/openshift/assets/middleware/resilient-apps/ratings-no-traffic-v2.png)

## Migrate users to v3

To start the process, let's send half (50%) of the users to our new `v3` version with the fix, to do a canary test.
Execute the following command which replaces the `reviews-default` rule with a new rule:

`oc replace -f samples/bookinfo/kube/route-rule-reviews-50-v3.yaml`{{execute T1}}

Inspect the new rule:

`oc get routerule reviews-default -o yaml`{{execute T1}}

Notice the new `weight` elements:

```yaml
  route:
  - labels:
      version: v1
    weight: 50
  - labels:
      version: v3
    weight: 50
```

Open the Grafana dashboard and verify this:

* [Grafana Dashboard](http://grafana-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/dashboard/db/istio-dashboard)

Scroll down to the `reviews` service and observe that half the traffic goes to each of `v1` and `v3` and none goes
to `v2`:

![half traffic](/openshift/assets/middleware/resilient-apps/reviews-v1-v3-half.png)


At this point, we see some traffic going to `v3` and are happy with the result. [Access the application](http://istio-ingress-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/productpage)
and verify that you either get no ratings stars (`v1`) or _red_ ratings stars (`v3`).

We are now happy with the new version `v3` and want to migrate everyone to it. Execute:

`oc replace -f samples/bookinfo/kube/route-rule-reviews-v3.yaml`{{execute T1}}

Once again, open the Grafana dashboard and verify this:

* [Grafana Dashboard](http://grafana-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/dashboard/db/istio-dashboard)

Scroll down to the `reviews` service and observe that all traffic is now going to `v3`:

![all v3 traffic](/openshift/assets/middleware/resilient-apps/reviews-v3-all.png)

Also, [Access the application](http://istio-ingress-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/productpage)
and verify that you always get _red_ ratings stars (`v3`).

## Congratulations!

In this task we migrated traffic from an old to new version of the reviews service using Istio’s
weighted routing feature. Note that this is very different than version migration using deployment
features of OpenShift, which use instance scaling to manage the traffic. With Istio, we can allow
the two versions of the reviews service to scale up and down independently, without affecting the
traffic distribution between them. For more about version routing with autoscaling, check out
[Canary Deployments using Istio](https://istio.io/blog/canary-deployments-using-istio.html).

In the next step, we will explore circuit breaking, which is useful for avoiding cascading failures
and overloaded microservices, giving the system a chance to recover and minimize downtime.
