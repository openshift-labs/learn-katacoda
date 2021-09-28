Think about the following scenario: *Push v2 into the cluster but slowing send end-user traffic to it, if you continue to see success, continue shifting more traffic over time.*

Let's now how we would create a `VirtualService` that sends 90% of requests to v1 and 10% to v2.

Take a look at the file `/istiofiles/virtual-service-recommendation-v1_and_v2.yml`{{open}}

It specifies that `recommendation` with name `version-v1` will have a weight of `90`, and `recommendation` with name `version-v2` will have a weight of `10`.

Create this `VirtualService`: `istioctl create -f ~/projects/istio-tutorial/istiofiles/virtual-service-recommendation-v1_and_v2.yml -n tutorial`{{execute T1}}

Make sure that the following command is running on `Terminal 2` `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .2; done`{{execute interrupt T2}}

You should see a rate of 90/10 between v1 and v2.

## Recommendations 75/25

Let's change the routing weight to be 75/25 by applying the following file `/istiofiles/virtual-service-recommendation-v1_and_v2_75_25.yml`{{open}}

Replace the previously created `VirtualService` with: `oc replace -f ~/projects/istio-tutorial/istiofiles/virtual-service-recommendation-v1_and_v2_75_25.yml -n tutorial`{{execute T1}}

Make sure that the following command is running on `Terminal 2` `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .2; done`{{execute interrupt T2}}

You should see a rate of 75/25 between v1 and v2.

## Clean up

You can remove the `VirtualService` called `recommendation` to have the load balacing behavior back:

`istioctl delete virtualservice recommendation -n tutorial`{{execute T1}}

On `Terminal 2` you should see v1 and v2 being returned in a 50/50 round-robin load-balancing.
