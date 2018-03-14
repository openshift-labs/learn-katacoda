To send a file to `v1` and `v2` by simply removing the rule

`istioctl delete routerule recommendation-default -n tutorial`{{execute T1}}

Then you should see the default behavior of load-balancing between v1 and v2

Make sure that the following command is running on `Terminal 2` `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .2; done`{{execute T2}}

you should see v1 and v2 being returned.