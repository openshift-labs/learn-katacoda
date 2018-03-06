Open the file `/istiofiles/route-rule-recommendation-v1.yml`{{open}}.

Note that it specifies that the destination will be the recommendation that contains the label `version=v1`.

Let's replace the RouteRule.

`istioctl replace -f ~/projects/istio-tutorial/istiofiles/route-rule-recommendation-v1.yml -n tutorial`{{execute T1}}

**Note**: "replace" instead of "create" since we are overlaying the previous rule

Make sure that the following command is running on `Terminal 2` `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .2; done`{{execute T2}}

you should only see v1 being returned.

## Explore the routerules object

You can check the existing route rules by typing `istioctl get routerules`{{execute T1}}. It will show that we only have a `routerule` object called `recommendations-default`. The name has been specified in the route rule metadata.

You can check the contents of this `routerule` by executing `istioctl get routerule recommendation-default -o yaml -n tutorial`{{execute T1}}