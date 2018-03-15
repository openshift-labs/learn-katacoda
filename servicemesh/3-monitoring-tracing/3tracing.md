Tracing in Istio requires to pass a set of headers to outbound requests. It can be done manually or using OpenTracing framework instrumentations such as [opentracing-spring-cloud](https://github.com/opentracing-contrib/java-spring-cloud). Framework instrumentation automatically propagates tracing headers and also creates in-process spans to better understand what is happening inside the application.

There are different ways to configure the tracer. The Customer Java service is using [tracerresolver](https://github.com/opentracing-contrib/java-tracerresolver) which does not require any code changes and the whole configuration is defined in environmental variables defined at `customer/java/Dockerfile`{{open}}. Whereas the Preference Java service is instantiating the tracer bean directly in Spring configuration class at `preference/java/src/main/java/com/redhat/developer/demos/preference/PreferencesApplication.java`{{open}}.


## Install Jaeger console

Jaeger allow you to trace the invocation.

Install Jaeger console by executing: `oc process -f https://raw.githubusercontent.com/jaegertracing/jaeger-openshift/master/all-in-one/jaeger-all-in-one-template.yml | oc create -n istio-system -f -`{{execute T1}}

Execute `oc get pods -w -n istio-system`{{execute T1}} and wait until `jaeger` pod READY column is 1/1.

Hit `CTRL+C`.

Make sure that the following command is running on `Terminal 2` `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .2; done`{{execute T2}}

Check `Jaeger` route by typing `oc get routes -n istio-system`{{execute interrupt T1}}

Now that you know the URL of `Jaeger`, access it at  

http://jaeger-query-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com 

Select `customer` from the list of services and click on `Find Traces`

![](../../assets/servicemesh/monitoring/jaegerUI.png)