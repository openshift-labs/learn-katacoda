Open the file `istiofiles/destination-rule-recommendation-v1-v2.yml`{{open}}.

Open the file `istiofiles/virtual-service-recommendation-v2.yml`{{open}}.

Note that the `DestinationRule` adds a name to each version of our `recommendation` deployments, and `VirtualService` specifies that the destination will be the `recommendation` deployment with name `version-v2`.

Let's apply these files.

`
istioctl create -f ~/projects/istio-tutorial/istiofiles/destination-rule-recommendation-v1-v2.yml -n tutorial
istioctl create -f ~/projects/istio-tutorial/istiofiles/virtual-service-recommendation-v2.yml -n tutorial
`{{execute T1}}

Make sure that the following command is running on `Terminal 2` `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .2; done`{{execute interrupt T2}}

You should only see `v2` being returned.
