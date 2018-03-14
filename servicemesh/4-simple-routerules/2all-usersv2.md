Open the file `istiofiles/route-rule-recommendation-v2.yml`{{open}}.

Note that the `RouteRule` specifies that the destination will be the recommendation that contains the label `version=v2`.

Let's apply this file.

`istioctl create -f ~/projects/istio-tutorial/istiofiles/route-rule-recommendation-v2.yml -n tutorial`{{execute T1}}

Make sure that the following command is running on `Terminal 2` `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .2; done`{{execute T2}}

you should only see v2 being returned.