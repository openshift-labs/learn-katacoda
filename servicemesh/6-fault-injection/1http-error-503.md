By default, recommendation v1 and v2 are being randomly load-balanced as that is the default behavior in Kubernetes/OpenShift

If you look for all recommendations pods that contains the label `app=recommendation`, you will find `v1` and `v2`.

Try: `oc get pods -l app=recommendation -n tutorial`{{execute T1}}

To check the random load-balance, send several requests to the microservices on `Terminal 2` to see their responses
`while true; do time curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .5; done`{{execute T2}}

Now check the file `/istiofiles/route-rule-recommendation-503.yml`{{open}}.

Note that this `RouteRule` provides `httpFault` that will `abort` the request `50% of the time` with a `httpStatus=503`.

Let's apply this rule: `istioctl create -f ~/projects/istio-tutorial/istiofiles/route-rule-recommendation-503.yml -n tutorial`{{execute T1}}

To check the new behavior, make sure that the following command is running on `Terminal 2`:
`while true; do time curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .5; done`{{execute T2}}

**NOTE:** It might take a couple of seconds until you see the new behavior

## Clean up

To remove the HTTP Error 503 behavior, simply delete this `routerule` by executing `istioctl delete routerule recommendation-503 -n tutorial`{{execute T1}}

To check if you have random load-balance without `503`'s, try the microservice on `Terminal 2`: `while true; do time curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .5; done`{{execute T2}}

