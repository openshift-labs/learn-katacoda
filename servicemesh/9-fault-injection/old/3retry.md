Instead of failing immediately, retry the Service N more times

We will make pod recommendation-v2 fail 100% of the time. Get one of the pod names from your system and replace on the following command accordingly:

`oc exec -it $(oc get pods|grep recommendation-v2|awk '{ print $1 }'|head -1) -c recommendation /bin/bash`{{execute T1}}

You will be inside the application container of your pod recommendation-v2-2036617847-spdrb. Now execute the following command inside the recommenation-v2 pod:

`curl localhost:8080/misbehave`{{execute T1}}

Now exit from the recommendation-v2 pod:

`exit`{{execute T1}}

This is a special endpoint that will make our application return only `503`s.

Now, if you hit the customer endpoint several times, you should see some 503’s

`while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .5; done`{{execute T2}}

Now, check the file `istiofiles/virtual-service-recommendation-v2_retry.yml`{{open}}. 

Note that this `VirtualService` provides simpleRetry that perform 3 attemps on recommendation, using a timeout of 2 seconds per try.

Let's apply this `VirtualService`: 

`istioctl create -f ~/projects/istio-tutorial/istiofiles/virtual-service-recommendation-v2_retry.yml -n tutorial`{{execute T1}}

and after a few seconds, things will settle down and you will see it work every time.

To check this behavior, send several requests to the microservices on Terminal 2 to see their responses:

`while true; do time curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .5; done`{{execute interrupt T2}}

NOTE: You will see it work every time because Istio will retry the recommendation service and it will land on v1 only.

You can see the active Virtual Services via: `istioctl get virtualservices -n tutorial`{{execute T1}}

## Clean up

Now, delete the retry rule and see the old behavior on Terminal 2, where v2 throws 503s: `istioctl delete virtualservice recommendation -n tutorial`{{execute T1}}

Now, make the pod v2 behave well again. Get one of the pod names from your system and replace on the following command accordingly:

`oc exec -it $(oc get pods|grep recommendation-v2|awk '{ print $1 }'|head -1) -c recommendation /bin/bash`{{execute T1}}

Now execute the following command inside the recommenation-v2 pod:

`curl localhost:8080/behave`{{execute T1}}

Now exit from the recommendation-v2 pod:

`exit`{{execute T1}}

The application is back to random load-balancing between v1 and v2. Check it at Terminal 2: `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .5; done`{{execute interrupt T2}}
