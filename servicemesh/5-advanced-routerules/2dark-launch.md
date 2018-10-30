You should have 2 pods for recommendation based on the command bellow:

`oc get pods -l app=recommendation -n tutorial`{{execute T1}}

Check the files `istiofiles/destination-rule-recommendation-v1-v2.yml`{{open}} and `istiofiles/virtual-service-recommendation-v1-mirror-v2.yml`{{open}}.

Note that the `virtualservice` routes the requests to `recommendation`, `subset: version-v1`. However, it also `mirror` these requests to `recommendation`, `subset: version-v2`.

Let's apply these files: `istioctl create -f ~/projects/istio-tutorial/istiofiles/destination-rule-recommendation-v1-v2.yml -n tutorial; \
istioctl create -f ~/projects/istio-tutorial/istiofiles/virtual-service-recommendation-v1-mirror-v2.yml -n tutorial`{{execute T1}}

Now, send several requests to the microservices on `Terminal 2` to see their responses
`while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .5; done`{{execute T2}}

Note that it only replies from `v1`.

Check the logs of `recommendation:v2` to make sure that it received the request although we saw only `v1` response.

`oc logs -f $(oc get pods|grep recommendation-v2|awk '{ print $1 }') -c recommendation`{{execute T1}}

Hit CTRL+C when you are satisfied.

## Clean up

Don't forget to remove the `virtualservice` and `destinationrule` executing `~/projects/istio-tutorial/scripts/clean.sh`{{execute interrupt T1}}