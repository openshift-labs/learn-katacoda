The most insidious of possible distributed computing faults is not a "down" service but a service that is responding slowly, potentially causing a cascading failure in your network of services.

Now check the file `/istiofiles/route-rule-recommendation-delay.yml`{{open}}.

Note that this `RouteRule` provides `httpFault` that will `delay` the request `50% of the time` with a `fixedDelay=7s`.

Let's apply this rule: `istioctl create -f ~/projects/istio-tutorial/istiofiles/route-rule-recommendation-delay.yml -n tutorial`{{execute T1}}

To check the new behavior, send several requests to the microservices on `Terminal 2` to see their responses
`while true; do time curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .5; done`{{execute T2 }}

You will notice many requets to the customer endpoint now have a delay of seven seconds.

## Clean up

To remove the delay behavior, simply delete this `routerule` by executing `istioctl delete routerule recommendation-delay -n tutorial`{{execute T1}}

To check if you have random load-balance without delays, try the microservice on `Terminal 2`: `while true; do time curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .5; done`{{execute T2 }}
