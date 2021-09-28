Pool ejection or *outlier detection* is a resilience strategy that takes place whenever we have a pool of instances/pods to serve a client request. If the request is forwarded to a certain instance and it fails (e.g. returns a 50x error code), then Istio will eject this instance from the pool for a certain *sleep window*. In our example the sleep window is configured to be 15s. This increases the overall availability by making sure that only healthy pods participate in the pool of instances.

First, you need to insure you have a `destinationrule` and `virtualservice` in place. Let's use a 50/50 split of traffic:

`istioctl create -f ~/projects/istio-tutorial/istiofiles/destination-rule-recommendation-v1-v2.yml -n tutorial; \
istioctl create -f ~/projects/istio-tutorial/istiofiles/virtual-service-recommendation-v1_and_v2_50_50.yml -n tutorial`{{execute T1}}

Scale number of instances of v2 deployment

`oc scale deployment recommendation-v2 --replicas=2 -n tutorial`{{execute T1}}

Execute `oc get pods -w`{{execute T1}}

Once that the microservices pods READY column are 2/2, you can hit `CTRL+C`. 

## Test behavior without failing instances

Execute on `Terminal 2` `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .1; done`{{execute T2}}

You will see the load balancing 50/50 between the two different versions of the `recommendation` service. And within version `v2`, you will also see that some requests are handled by one pod and some requests are handled by the other pod.

```
customer => preference => recommendation v1 from '2039379827-jmm6x': 447
customer => preference => recommendation v2 from '2036617847-spdrb': 26
customer => preference => recommendation v1 from '2039379827-jmm6x': 448
customer => preference => recommendation v2 from '2036617847-spdrb': 27
customer => preference => recommendation v1 from '2039379827-jmm6x': 449
customer => preference => recommendation v1 from '2039379827-jmm6x': 450
```

## Test behavior with failing instance and without pool ejection

Let's get the name of the pods from recommendation v2:

`oc get pods -l app=recommendation,version=v2`{{execute interrupt T1}}

You should see something like this:

```
recommendation-v2-2036617847-hdjv2   2/2       Running   0          1h
recommendation-v2-2036617847-spdrb   2/2       Running   0          7m
```

Now we'll get into one the pods and add some erratic behavior on it. 

`oc exec -it $(oc get pods|grep recommendation-v2|awk '{ print $1 }'|head -1) -c recommendation  /bin/bash`{{execute T1}}

You will be inside the application container of your pod. Now execute the following command inside the recommenation-v2 pod:

`curl localhost:8080/misbehave`{{execute T1}}

Now exit from the recommendation-v2 pod:

`exit`{{execute T1}}

This is a special endpoint that will make our application return only `503`s.

Make sure that the following command is running on `Terminal 2` `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .1; done`{{execute interrupt T2}}

You'll see that whenever the pod that you ran the command `curl localhost:8080/misbehave` receives a request, you get a 503 error:

```
customer => preference => recommendation v2 from '2036617847-hdjv2': 248
customer => preference => recommendation v1 from '2039379827-jmm6x': 496
customer => preference => recommendation v1 from '2039379827-jmm6x': 497
customer => 503 preference => 503 recommendation misbehavior from '2036617847-spdrb'
customer => preference => recommendation v2 from '2036617847-hdjv2': 249
customer => preference => recommendation v1 from '2039379827-jmm6x': 498
customer => 503 preference => 503 recommendation misbehavior from '2036617847-spdrb'
customer => preference => recommendation v2 from '2036617847-hdjv2': 250
```

## Test behavior with failing instance and with pool ejection

Now let's add the pool ejection behavior:

Check the file `/istiofiles/destination-rule-recommendation_cb_policy_pool_ejection.yml`{{open}}.

Now execute:

`istioctl replace -f ~/projects/istio-tutorial/istiofiles/destination-rule-recommendation_cb_policy_pool_ejection.yml -n tutorial`{{execute T1}}

Make sure that the following command is running on `Terminal 2` `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .1; done`{{execute interrupt T2}}

You will see that whenever you get a failing request with 503 from the pod, it gets ejected from the pool, and it doesn't receive any more requests until the sleep window expires - which takes at least 15s.

```bash
customer => preference => recommendation v1 from '2039379827-jmm6x': 509
customer => 503 preference => 503 recommendation misbehavior from '2036617847-spdrb'
customer => preference => recommendation v1 from '2039379827-jmm6x': 510
customer => preference => recommendation v1 from '2039379827-jmm6x': 511
customer => preference => recommendation v1 from '2039379827-jmm6x': 512
customer => preference => recommendation v1 from '2039379827-jmm6x': 513
customer => preference => recommendation v1 from '2039379827-jmm6x': 514
customer => preference => recommendation v2 from '2036617847-hdjv2': 256
customer => preference => recommendation v2 from '2036617847-hdjv2': 257
customer => preference => recommendation v1 from '2039379827-jmm6x': 515
customer => preference => recommendation v2 from '2036617847-hdjv2': 258
customer => preference => recommendation v2 from '2036617847-hdjv2': 259
customer => preference => recommendation v2 from '2036617847-hdjv2': 260
customer => preference => recommendation v1 from '2039379827-jmm6x': 516
customer => preference => recommendation v1 from '2039379827-jmm6x': 517
customer => preference => recommendation v1 from '2039379827-jmm6x': 518
customer => 503 preference => 503 recommendation misbehavior from '2036617847-spdrb'
customer => preference => recommendation v1 from '2039379827-jmm6x': 519
```

Hit CTRL+C when you are satisfied.