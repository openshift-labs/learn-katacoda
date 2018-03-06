Think about the following scenario: *Push v2 into the cluster but slowing send end-user traffic to it, if you continue to see success, continue shifting more traffic over time.*

Let's now create a `routerule` that will send 90% of requests to v1 and 10% to v2

Look at the file `/istiofiles/route-rule-recommendation-v1_and_v2.yml`{{open}}

It specifies that `recommendation` with label`version=v1` will have a weight of `90`, and `recommendations` with label`version=v2` will have a weight of `10`

Let's create that routerule: `istioctl create -f ~/projects/istio-tutorial/istiofiles/route-rule-recommendation-v1_and_v2.yml -n tutorial`{{execute T1}}

Make sure that the following command is running on `Terminal 2` `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .2; done`{{execute T2}}

You should see a rate of 90/10 between v1 and v2.

## Recommendations 75/25

Let's change the mixture to be 75/25 by applying the following file `/istiofiles/route-rule-recommendation-v1_and_v2_75_25.yml`{{open}}

Let's replace the previously created routerule with: `oc replace -f ~/projects/istio-tutorial/istiofiles/route-rule-recommendation-v1_and_v2_75_25.yml -n tutorial`{{execute T1}}

Make sure that the following command is running on `Terminal 2` `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .2; done`{{execute T2}}

You should see a rate of 75/25 between v1 and v2.

## Clean up

You can now remove the routerule called `recommendation-v1-v2` to have the load balacing behavior back.

`istioctl delete routerule recommendation-v1-v2 -n tutorial`{{execute T1}}

On `Terminal 2`you should see v1 and v2 being returned.