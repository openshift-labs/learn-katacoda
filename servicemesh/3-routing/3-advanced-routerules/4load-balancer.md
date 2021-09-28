By default, you will see "round-robin" style load-balancing, but you can change it up, with the RANDOM option being fairly visible to the naked eye.

Add another v2 pod to the mix `oc scale deployment recommendation-v2 --replicas=2 -n tutorial`{{execute T1}}

Watch the creation of the pods executing `oc get pods -w`{{execute T1}}

Once that the recommendation pods READY column are 2/2, you can hit `CTRL+C`. 

Now, send several requests to the microservices on `Terminal 2` to see their responses
`while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .5; done`{{execute T2}}

Add a 3rd v2 pod to the mix `oc scale deployment recommendation-v2 --replicas=3 -n tutorial`{{execute interrupt T1}}

Watch the creation of the pods executing `oc get pods -w`{{execute T1}}

Once that the recommendation pods READY column are 2/2, you can hit `CTRL+C`. 

Make sure that the following command is running on `Terminal 2` `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .2; done`{{execute T2}}

The results should follow a fairly normal round-robin distribution pattern where `v2` receives the request 3 times more than `v1`

```
customer => preference => recommendation v1 from '99634814-d2z2t': 1145
customer => preference => recommendation v2 from '2819441432-525lh': 1
customer => preference => recommendation v2 from '2819441432-rg45q': 2
customer => preference => recommendation v2 from '2819441432-bs5ck': 181
customer => preference => recommendation v1 from '99634814-d2z2t': 1146
customer => preference => recommendation v2 from '2819441432-rg45q': 3
customer => preference => recommendation v2 from '2819441432-rg45q': 4
customer => preference => recommendation v2 from '2819441432-bs5ck': 182
```

Now, explore the file `istiofiles/destination-rule-recommendation_lb_policy_app.yml`{{open}}, and add the Random LB trafficPolicy defined in this `DestinationRule`:

`istioctl create -f ~/projects/istio-tutorial/istiofiles/destination-rule-recommendation_lb_policy_app.yml -n tutorial`{{execute interrupt T1}}

Make sure that the following command is running on `Terminal 2` `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .2; done`{{execute T2}}

After a while you should see a different pattern.

## Clean up

Don't forget to remove the `virtualservice` and `destinationrule` executing `~/projects/istio-tutorial/scripts/clean.sh`{{execute interrupt T1}}

and 

`oc scale deployment recommendation-v2 --replicas=1 -n tutorial`{{execute T1}}