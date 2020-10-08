#### Run a subscriber investor service

We are going to deploy a service that will listen to the events from the simple predictor.And Display the result from in log.

Go to the text editor on the right, under the folder /root/camel-eventing. Right click on the directory and choose New -> File and name it `Investor.java`.


<pre class="file" data-filename="Investor.java " data-target="replace">
// camel-k: language=java

import org.apache.camel.builder.RouteBuilder;

public class Investor extends RouteBuilder {
  @Override
  public void configure() throws Exception {

    from("knative:event/predictor.simple")
      .unmarshal().json()
      .log("Let's ${body[operation]} at price ${body[value]} immediately!!")
      .setBody().constant("");

  }
}
</pre>

To run it:
``kamel run camel-eventing/Investor.java --logs``{{execute}}

You will see the following log if everything is working correctly.
```
[1] 2020-10-02 00:19:19.308 INFO  [main] RuntimeSupport - Apply ContextCustomizer with id=platform-http and type=org.apache.camel.k.http.PlatformHttpServiceContextCustomizer
[1] 2020-10-02 00:19:19.335 INFO  [main] VertxPlatformHttpServer - Creating new Vert.x instance
[1] 2020-10-02 00:19:19.685 INFO  [main] ApplicationRuntime - Listener org.apache.camel.k.listener.ContextConfigurer@93cf163 executed in phase ConfigureContext
[1] 2020-10-02 00:19:19.806 INFO  [main] KnativeComponent - found knative transport: org.apache.camel.component.knative.http.KnativeHttpTransport@1de6932a for protocol: http
[1] 2020-10-02 00:19:20.428 INFO  [main] AbstractCamelContext - Apache Camel 3.4.0 (camel-k) is starting
[1] 2020-10-02 00:19:20.431 INFO  [main] AbstractCamelContext - StreamCaching is not in use. If using streams then its recommended to enable stream caching. See more details at http://camel.apache.org/stream-caching.html
[1] 2020-10-02 00:19:20.456 INFO  [main] JacksonDataFormat - The option autoDiscoverObjectMapper is set to false, Camel won't search in the registry
[1] 2020-10-02 00:19:20.773 INFO  [vert.x-eventloop-thread-1] VertxPlatformHttpServer - Vert.x HttpServerstarted on 0.0.0.0:8080
[1] 2020-10-02 00:19:20.786 INFO  [main] InternalRouteStartupManager - Route: route1 started and consuming from: knative://event/predictor.simple
[1] 2020-10-02 00:19:20.787 INFO  [main] AbstractCamelContext - Total 1 routes, of which 1 are started
[1] 2020-10-02 00:19:20.788 INFO  [main] AbstractCamelContext - Apache Camel 3.4.0 (camel-k) started in 0.359 seconds
```
To exit the log view, just click here or hit ctrl+c on the terminal window. The integration will keep running on the cluster.


#### Loading the Bitcoin live data
Now, let's go ahead and start taking live data from the Bitcoin market and pushing it to the event mesh.
Go to the text editor on the right, under the folder /root/camel-eventing. Right click on the directory and choose New -> File and name it `market-source.yaml`.
Create the camel route loads Bitcoin market data every 10 seconds.   

Paste the following code into the application.

<pre class="file" data-filename="market-source.yaml" data-target="replace">
- from:
    uri: "timer:tick"
    parameters:
      period: 10000
    steps:
      - to: "xchange:binance?currencyPair=BTC/USDT&service=marketdata&method=ticker"
      - marshal:
          json: {}
      - log:
          message: "Sending BTC/USDT data to the broker: ${body}"
      - set-header:
          constant: market.btc.usdt
          name: CE-Type
      - to: "knative:event"
</pre>

Start the Camel K application

``kamel run camel-eventing/market-source.yaml -d camel-jackson``{{execute}}

The integration will be deployed on the cluster.

After successfully deployed, you will be able to see it in the [Developer Console Topology](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com/topology/ns/camel-knative/graph).

When the Bitcoin data start floating into the data, all predictor services and the investor service will automatically start up.

![startsup](/openshift/assets/middleware/middleware-camelk/camel-k-eventing/Eventing-Step3-01-startsup.png)
