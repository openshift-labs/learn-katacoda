Distributed Tracing involves propagating the tracing context from service to service, usually done by sending certain incoming HTTP headers downstream to outbound requests. For services embedding a [OpenTracing](http://opentracing.io/) framework instrumentations such as [opentracing-spring-cloud](https://github.com/opentracing-contrib/java-spring-cloud), this might be transparent. For services that are not embedding OpenTracing libraries, this context propagation needs to be done manually.

As OpenTracing is "just" an instrumentation library, a concrete tracer is required in order to actually capture the tracing data and report it to a remote server. Our customer and preference services ship with [Jaeger](https://github.com/jaegertracing/jaeger) as the concrete tracer. the Istio platform automatically sends collected tracing data to Jaeger, so that we are able to see a trace involving all three services, even if our recommendation service is not aware of OpenTracing or Jaeger at all.

Our `customer` and `preference` services are using the [TracerResolver](https://github.com/jaegertracing/jaeger-client-java/tree/master/jaeger-tracerresolver) facility from OpenTracing, so that the concrete tracer can be loaded automatically without our code having a hard dependency on Jaeger. Given that the Jaeger tracer can be configured via environment variables, we don’t need to do anything in order to get a properly configured Jaeger tracer ready and registered with OpenTracing. That said, there are cases where it’s appropriate to manually configure a tracer. Refer to the Jaeger documentation for more information on how to do that.

Check the Jaeger route by typing `oc get routes -n istio-system`{{execute interrupt T1}}

Now that you know the URL of Jaeger, access it at http://tracing-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com 

Select `customer` from the list of services and click on `Find Traces`:

![](../../assets/servicemesh/monitoring/jaegerUI.png)
