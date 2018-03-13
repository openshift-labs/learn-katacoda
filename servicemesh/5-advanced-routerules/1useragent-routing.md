What is your user-agent?

<https://www.whoishostingthis.com/tools/user-agent/>

**Note:** the "user-agent" header being forwarded in the Customer and Preferences controllers in order for route rule modications around recommendations.

Let's create a rule that points all request to v1 using the file `/istiofiles/route-rule-recommendation-v1.yml`{{open}}.

`istioctl create -f ~/projects/istio-tutorial/istiofiles/route-rule-recommendation-v1.yml -n tutorial`{{execute T1}}

Check this behavior trying the microservice several times by typing `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .1; done`{{execute T1}}

Hit CTRL+C when you are satisfied.

Now check the file `/istiofiles/route-rule-safari-recommendation-v2.yml`{{open}}.

Note that this `RouteRule` will only route request to `recommendations` that contains the label `version=v2` when the `request` contains a `header` where the `user-agent` value `matches` the `regex` expression to `".*Safari.*"`.

Let's apply this rule: `istioctl create -f ~/projects/istio-tutorial/istiofiles/route-rule-safari-recommendation-v2.yml -n tutorial`{{execute T1}}

Now test the URL http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com with a Safari (or even Chrome on Mac since it includes Safari in the string). Safari only sees v2 responses from recommendations

and test with a Firefox browser, it should only see v1 responses from recommendations.


## Try this rule using curl

If you don't have these browsers you can customiza the `curl` command `user-agent` using `-A`.

For example. Try `curl -A Safari http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute T1}}

Alternatively you can try a `Firefox` user-agent with `curl -A Firefox http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute T1}}

You can describe the routerule to see its configuration: `oc describe routerule recommendation-safari -n tutorial`{{execute T1}} 

## Remove 'Safari' rule.

To remove the User-Agent behavior, simply delete this `routerule` by executing `istioctl delete routerule recommendation-safari -n tutorial`{{execute T1}}

To check if you have all requests using `v1`, try the microservice several times by typing `curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute T1}}

You still have the requests going to `v1` because you didn't remove the RouteRule `recommendation-default`.

## Clean up

Don't forget to remove the RouteRule `recommendation-default` executing `istioctl delete routerule recommendation-default -n tutorial`{{execute T1}}
