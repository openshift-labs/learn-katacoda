What is your user-agent?

<https://www.whoishostingthis.com/tools/user-agent/>

**Note:** the "user-agent" header is added to OpenTracing baggage in the Customer service. From there it is automatically propagated to all downstream services. To enable automatic baggage propagation all intermediate services have to be instrumented with OpenTracing. The baggage header for `user-agent` has the following form `baggage-user-agent: <value>`.

Let's create a rule that points all request to v1 using the files `/istiofiles/destination-rule-recommendation-v1-v2.yml`{{open}} and `/istiofiles/virtual-service-recommendation-v1.yml`{{open}}.

`istioctl create -f ~/projects/istio-tutorial/istiofiles/destination-rule-recommendation-v1-v2.yml -n tutorial; \
istioctl create -f ~/projects/istio-tutorial/istiofiles/virtual-service-recommendation-v1.yml -n tutorial`{{execute T1}}

Check this behavior trying the microservice several times by typing `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .1; done`{{execute T1}}

Hit CTRL+C when you are satisfied.

Now check the file `/istiofiles/virtual-service-safari-recommendation-v2.yml`{{open}}.

Note that this `VirtualService` will only route request to `recommendations`, `subset: version-v2 `  that contains the label `version=v2`  `http` contains a baggage header `baggage-user-agent` where the value `matches` the `regex` expression to `".*Safari.*"`.

Let's replace the `virtualservice`: `istioctl replace -f ~/projects/istio-tutorial/istiofiles/virtual-service-safari-recommendation-v2.yml -n tutorial`{{execute interrupt T1}}

Now test the URL http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com with a Safari (or even Chrome on Mac since it includes Safari in the string). Safari only sees v2 responses from recommendations

and test with a Firefox browser, it should only see v1 responses from recommendations.


## Try this rule using curl

If you don't have these browsers you can customiza the `curl` command `user-agent` using `-A`.

For example. Try `curl -A Safari http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute T1}}

Alternatively you can try a `Firefox` user-agent with `curl -A Firefox http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute T1}}

You can describe the routerule to see its configuration: `istioctl get virtualservice recommendation -o yaml -n tutorial`{{execute T1}} 

## Remove 'Safari' rule.

To remove the User-Agent behavior, simply delete this `virtualservice` by executing `istioctl delete virtualservice recommendation -n tutorial`{{execute T1}}

To check if you have all requests using `v1`, try the microservice several times by typing `curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute T1}}

You still have the requests going to `v1` because you didn't remove the RouteRule `recommendation-default`.

## Clean up

Don't forget to remove the `virtualservice` and `destinationrule` executing `~/projects/istio-tutorial/scripts/clean.sh`{{execute interrupt T1}}
