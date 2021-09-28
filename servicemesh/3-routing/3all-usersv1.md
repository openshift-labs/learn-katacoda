Open the file `/istiofiles/virtual-service-recommendation-v1.yml`{{open}}.

Note that it specifies that the destination will be the `recommendation` deployment with the name `version-v1`.

Let's replace the `VirtualService`.

`istioctl replace -f ~/projects/istio-tutorial/istiofiles/virtual-service-recommendation-v1.yml -n tutorial`{{execute T1}}

**Note**: We used `replace` instead of `create` since we are overlaying the previous `VirtualService`.

Make sure that the following command is running on `Terminal 2` `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .2; done`{{execute T2}}

you should only see v1 being returned.

## Explore the VirtualService object

You can check the existing route rules by typing `istioctl get virtualservice`{{execute T1}}. It will show that we only have a `VirtualService` object called `recommendations`. The name has been specified in the `VirtualService` metadata.

You can check the contents of this `VirtualService` by executing `istioctl get virtualservice recommendation -o yaml -n tutorial`{{execute T1}}
