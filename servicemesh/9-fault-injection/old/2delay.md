The most insidious of possible distributed computing faults is not a "down" service but a service that is responding slowly, potentially causing a cascading failure in your network of services.

Check the file `/istiofiles/virtual-service-recommendation-delay.yml`{{open}}.
and the file `/istiofiles/destination-rule-recommendation.yml`{{open}}.

The `VirtualService` provides `httpFault` that will `delay` the request `50% of the time` with a `fixedDelay=7s`.

Let's apply these files: 

`istioctl create -f ~/projects/istio-tutorial/istiofiles/virtual-service-recommendation-delay.yml -n tutorial; \
istioctl create -f ~/projects/istio-tutorial/istiofiles/destination-rule-recommendation.yml -n tutorial`{{execute T1}}

To check the new behavior, send several requests to the microservices on `Terminal 2` to see their responses
`while true; do time curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .5; done`{{execute T2 }}

You will notice many requets to the customer endpoint now have a delay of seven seconds.

**NOTE:** It might take a couple of seconds until you see the new behavior

## Clean up

Don't forget to remove the `virtualservice` and `destinationrule` executing `~/projects/istio-tutorial/scripts/clean.sh`{{execute interrupt T1}}

To check if you have random load-balance without delays, try the microservice on `Terminal 2`: `while true; do time curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .5; done`{{execute interrupt T2}}
