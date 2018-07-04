In this step we will use Istio's Quota Management feature to apply
a rate limit on the `ratings` service.

## Quotas in Istio
Quota Management enables services to allocate and free quota
based on rules called _dimensions_. Quotas are used as a relatively
simple resource management tool to provide some fairness between
service consumers when contending for limited resources.
Rate limits are examples of quotas, and are handled by the
[Istio Mixer](https://istio.io/docs/concepts/policy-and-control/mixer.html).

## Generate some traffic

As before, let's start up some processes to generate load on the app. Execute this command:

`while true; do
    curl -o /dev/null -s -w "%{http_code}\n" \
      http://istio-ingress-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/productpage
  sleep .2
done`{{execute T2}}

This command will endlessly access the application and report the HTTP status result in a separate terminal window.

With this application load running, we can witness rate limits in action.

## Add a rate limit

Execute the following command:

`oc create -f samples/bookinfo/kube/mixer-rule-ratings-ratelimit.yaml`{{execute T1}}

This configuration specifies a default 1 qps (query per second) rate limit. Traffic reaching
the `ratings` service is subject to a 1qps rate limit. Verify this with Grafana:

* [Grafana Dashboard](http://grafana-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/dashboard/db/istio-dashboard)

Scroll down to the `ratings` service and observe that you are seeing that some of the requests sent
from `reviews:v3` service to the `ratings` service are returning HTTP Code 429 (Too Many Requests).

![5xxs](/openshift/assets/middleware/resilient-apps/ratings-overload.png)

In addition, at the top of the dashboard, the '4xxs' report shows an increase in 4xx HTTP codes. We are being
rate-limited to 1 query per second:

![5xxs](/openshift/assets/middleware/resilient-apps/ratings-4xxs.png)


## Inspect the rule

Take a look at the new rule:

`oc get memquota handler -o yaml`{{execute T1}}

In particular, notice the _dimension_ that causes the rate limit to be applied:

```yaml
# The following override applies to 'ratings' when
# the source is 'reviews'.
- dimensions:
    destination: ratings
    source: reviews
  maxAmount: 1
  validDuration: 1s
```

You can also conditionally rate limit based on other dimensions, such as:

* Source and Destination project names (e.g. to limit developer projects from overloading the production services during testing)
* Login names (e.g. to limit certain customers or classes of customers)
* Source/Destination hostnames, IP addresses, DNS domains, HTTP Request header values, protocols
* API paths
* [Several other attributes](https://istio.io/docs/reference/config/mixer/attribute-vocabulary.html)

## Remove the rate limit

Before moving on, execute the following to remove our rate limit:

`oc delete -f samples/bookinfo/kube/mixer-rule-ratings-ratelimit.yaml`{{execute T1}}

Verify that the rate limit is no longer in effect. Open the dashboard:

* [Grafana Dashboard](http://grafana-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/dashboard/db/istio-dashboard)

Notice at the top that the `4xx`s dropped back down to zero.

![5xxs](/openshift/assets/middleware/resilient-apps/ratings-4xxs-gone.png)

## Congratulations!

In the final step, we'll explore distributed tracing and how it can help diagnose and fix issues in
complex microservices architectures. Let's go!
