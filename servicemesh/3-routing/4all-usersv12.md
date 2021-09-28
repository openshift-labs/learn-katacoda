We can now send requests to both `v1` and `v2` by simply removing the rule:

`istioctl delete virtualservice recommendation -n tutorial`{{execute T1}}

Make sure that the following command is running on `Terminal 2` `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .2; done`{{execute interrupt T2}}

You should be able to see the default behavior of round-robin balancing between `v1` and `v2` being returned.
