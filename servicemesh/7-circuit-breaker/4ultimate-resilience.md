Even with pool ejection your application doesn't look that resilient. That's probably because we're still letting some errors to be propagated to our clients. But we can improve this. If we have enough instances and/or versions of a specific service running into our system, we can combine multiple Istio capabilities to achieve the ultimate backend resilience:

- **Circuit Breaker** to avoid multiple concurrent requests to an instance;
- **Pool Ejection** to remove failing instances from the pool of responding instances;
- **Retries** to forward the request to another instance just in case we get an open circuit breaker and/or pool ejection;

By simply adding a **retry** configuration to our current `routerule`, we'll be able to get rid completely of our `503`s requests. This means that whenever we receive a failed request from an ejected instance, Istio will forward the request to another supposably healthy instance.

Check the file `/istiofiles/virtual-service-recommendation-v1_and_v2_retry.yml`{{open}}.

Execute:

`istioctl replace -f ~/projects/istio-tutorial/istiofiles/virtual-service-recommendation-v1_and_v2_retry.yml -n tutorial`{{execute T1}}

Make sure that the following command is running on `Terminal 2` `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .2; done`{{execute interrupt T2}}

You won't receive 503s anymore. But the requests from recommendation v2 are still taking more time to get a response. Our misbehaving pod never shows up in the console, thanks to pool ejection and retry.

## Clean up

Reduce the number of `v2` replicas to 1: `oc scale deployment recommendation-v2 --replicas=1 -n tutorial`{{execute T1}}

Delete the failing pod: `oc delete pod -l app=recommendation,version=v2`{{execute T1}}

Don't forget to remove the `virtualservice` and `destinationrule` executing `~/projects/istio-tutorial/scripts/clean.sh`{{execute interrupt T1}}
