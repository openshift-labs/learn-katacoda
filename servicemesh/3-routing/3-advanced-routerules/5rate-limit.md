**Important:** The Rate Limiting rules take some time to be applied and reflected. Be patient here!

We can limit the request count rate in a specific microservice.

Examine the file that contains the rate limit handler `istiofiles/recommendation_rate_limit_handler.yml`{{open}} and apply it

`istioctl create -f ~/projects/istio-tutorial/istiofiles/recommendation_rate_limit_handler.yml`{{execute T1}}

Now examine the file that contains the requestcount quota `istiofiles/rate_limit_rule.yml`{{open}} and apply it

`istioctl create -f ~/projects/istio-tutorial/istiofiles/rate_limit_rule.yml`{{execute T1}}

To check the new behavior, try the microservice several times by typing `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .1; done`{{execute T1}}

After some seconds, you should see some 429 errors:

```
customer => preference => recommendation v2 from '2819441432-f4ls5': 108
customer => preference => recommendation v1 from '99634814-d2z2t': 1932
customer => preference => recommendation v2 from '2819441432-f4ls5': 109
customer => preference => recommendation v1 from '99634814-d2z2t': 1933
customer => 503 preference => 429 Too Many Requests
customer => preference => recommendation v1 from '99634814-d2z2t': 1934
customer => preference => recommendation v2 from '2819441432-f4ls5': 110
customer => preference => recommendation v1 from '99634814-d2z2t': 1935
customer => 503 preference => 429 Too Many Requests
customer => preference => recommendation v1 from '99634814-d2z2t': 1936
customer => preference => recommendation v2 from '2819441432-f4ls5': 111
customer => preference => recommendation v1 from '99634814-d2z2t': 1937
customer => 503 preference => 429 Too Many Requests
customer => preference => recommendation v1 from '99634814-d2z2t': 1938
customer => preference => recommendation v2 from '2819441432-f4ls5': 112
```

Hit CTRL+C when you are satisfied.

## Clean up

Don't forget to remove the `rate limiting` by executing `oc delete -f projects/istio-tutorial/istiofiles/rate_limit_rule.yml`{{execute interrupt T1}}

