Tracing requires a bit of work on the Java side. Each microservice needs to pass on the headers which are used to enable the traces.

Look at `/customer/src/main/java/com/redhat/developer/demos/customer/tracing/HttpHeaderForwarderHandlerInterceptor.java`{{open}}

and 

`/customer/src/main/java/com/redhat/developer/demos/customer/CustomerApplication.java`{{open}} on lines 21 to 31.

## Install Jaeger console

Jaeger allow you to trace the invocation.

Install Jaeger console by executing: `oc process -f https://raw.githubusercontent.com/jaegertracing/jaeger-openshift/master/all-in-one/jaeger-all-in-one-template.yml | oc create -n istio-system -f -`{{execute T1}}

Execute `oc get pods -w -n istio-system`{{execute T1}} and wait until `jaeger` pod READY column is 1/1.

Hit `CTRL+C`.

Make sure that the following command is running on `Terminal 2` `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .2; done`{{execute T2}}

Check `Jaeger` route by typing `oc get routes -n istio-system`{{execute T1}}

Now that you know the URL of `Jaeger`, access it at  

http://jaeger-query-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com 

Select `customer` from the list of services and click on `Find Traces`

![](../../assets/servicemesh/monitoring/jaegerUI.png)