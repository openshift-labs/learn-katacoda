For monitoring, Istio offers out of the box monitoring via Prometheus and Grafana.

**Note:** Before we take a look at Grafana, we need to send some requests to our application using on `Terminal 2`: `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .2; done`{{execute T2}}

Check the `grafana` route by typing `oc get route -n istio-system`{{execute interrupt T1}}

Now that you know the URL of `Grafana`, access it at http://grafana-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/d/1/istio-dashboard?refresh=5s&orgId=1

![](../../assets/servicemesh/monitoring/grafana1.png)

You can also check the workload of the services at http://grafana-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/d/UbsSZTDik/istio-workload-dashboard?refresh=5s&orgId=1

![](../../assets/servicemesh/monitoring/grafana2.png)
