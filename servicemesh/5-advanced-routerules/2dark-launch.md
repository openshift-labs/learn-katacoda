You should have 2 pods for recommendation based on the command bellow:

`oc get pods -l app=recommendation -n tutorial`{{execute T1}}

Check the file `istiofiles/route-rule-recommendation-v1-mirror-v2.yml`{{open}}

Note that it routes `100%` of the requests to `v1` and `0%` to `v2`. However it also `mirror` these requests to `recommendation` with the label `version=v2`.

Let's apply this rule: `istioctl create -f ~/projects/istio-tutorial/istiofiles/route-rule-recommendation-v1-mirror-v2.yml -n tutorial`{{execute T1}}

Now, send several requests to the microservices on `Terminal 2` to see their responses
`while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .5; done`{{execute T2}}

Note that it only replies from `v1`.

Check the logs of `recommendation:v2` to make sure that it received the request although we saw only `v1` response.

`oc logs -f $(oc get pods|grep recommendation-v2|awk '{ print $1 }') -c recommendation`{{execute T1}}

Hit CTRL+C when you are satisfied.

## Clean up

To remove the `mirror` behavior, delete the `routerule`.

`istioctl delete routerule recommendation-mirror -n tutorial`{{execute T1}}