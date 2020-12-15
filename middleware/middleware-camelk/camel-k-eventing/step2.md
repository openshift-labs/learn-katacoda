## Auto Bitcoin Trading System

The example shows a simplified trading application that analyzes price variations of Bitcoins (BTC / USDT), and automate trading base on the predicted returns. In order to keep the system flexible with pluggable prediction logics, we are going to break the system into three separate parts.
- *Source* - Load realtime Bitcoins values.
- *Predictors* - Pluggable predictors with various strategy.  
- *Seller Alert* - Seller alert (Mainly to display the result).

Assume the market only open for couple of hours, serverless application can optimize resource usage.
In between these separate serverless services, events are pass through an *event mesh*.

![overview](/openshift/assets/middleware/middleware-camelk/camel-k-eventing/Eventing-Step2-00-overview.png)


#### Enabling the Knative Eventing Broker

The central piece of the event mesh that we're going to create is the Knative Eventing broker. It is a publish/subscribe entity that Camel K integrations will use to publish events or subscribe to it in order to being triggered when events of specific types are available. Subscribers of the eventing broker are Knative serving services, that can scale down to zero when no events are available for them.



Create a new OpenShift project ``camel-knative``:
``oc new-project camel-knative``{{execute}}


To enable the eventing broker, we create a default broker in the current namespace using namespace labeling:
``oc label namespace camel-knative knative-eventing-injection=enabled``{{execute}}

Let go ahead create predictors for market and load the market events

#### Run a prediction algorithms

The market data feed available in the mesh can be now used to create different prediction algorithms that can publish events when they believe it's the right time to sell or buy bitcoins, depending on the trend of the exchange.

We're going to run the same (basic) algorithm with different parameters, obtaining two predictors. The algorithm is basic and it's just computing if the BTC variation respect to the last observed value is higher than a threshold (expressed in percentage). The algorithm is bound to the event mesh via the Predictor.java integration file.

In real life, algorithms can be also much more complicated. For example, Camel K can be used to bridge an external machine learning as-a-service system that will compute much more accurate predictions. Algorithms can also be developed with other ad hoc tools and plugged directly inside the Knative mesh using the Knative APIs.


#### Create the first prediction algorithms

Go to the text editor on the right, under the folder /root/camel-eventing. Right click on the directory and choose New -> File and name it `Predictor.java`.
Paste the following code into the application.

<pre class="file" data-filename="Predictor.java" data-target="replace">

// camel-k: language=java
import org.apache.camel.builder.RouteBuilder;

import java.util.HashMap;
import java.util.Map;

import org.apache.camel.BindToRegistry;
import org.apache.camel.PropertyInject;
import org.apache.camel.builder.RouteBuilder;

public class Predictor extends RouteBuilder {

  @Override
  public void configure() throws Exception {

      from("knative:event/market.btc.usdt")
        .unmarshal().json()
        .transform().simple("${body[last]}")
        .log("Latest value for BTC/USDT is: ${body}")
        .to("seda:evaluate?waitForTaskToComplete=Never")
        .setBody().constant("");

      from("seda:evaluate")
        .bean("algorithm")
        .choice()
          .when(body().isNotNull())
            .log("Predicted action: ${body}")
            .to("direct:publish");

      from("direct:publish")
        .marshal().json()
        .removeHeaders("*")
        .setHeader("CE-Type", constant("predictor.{{predictor.name}}"))
        .to("knative:event");

  }
  
  @BindToRegistry("algorithm")
  public static class SimpleAlgorithm {

    @PropertyInject(value="algorithm.sensitivity", defaultValue = "0.0001")
    private double sensitivity;

    private Double previous;
    
    public Map<String, Object> predict(double value) {
      Double reference = previous;
      this.previous = value;

      if (reference != null && value < reference * (1 - sensitivity)) {
        Map<String, Object> res = new HashMap<>();
        res.put("value", value);
        res.put("operation", "buy");
        return res;
      } else if (reference != null && value > reference * (1 + sensitivity)) {
        Map<String, Object> res = new HashMap<>();
        res.put("value", value);
        res.put("operation", "sell");
        return res;
      }
      return null;
    }
  }
}

</pre>

Run the following command to start the first predictor:

``kamel run --name simple-predictor -p predictor.name=simple camel-eventing/Predictor.java -t knative-service.max-scale=1 --logs``{{execute}}

The command above will deploy the integration and wait for it to run, then it will show the logs in the console.

You will see the following log if everything is working correctly.
```
[1] 2020-10-02 00:09:32.499 INFO  [main] JacksonDataFormat - The option autoDiscoverObjectMapper is set to false, Camel won't search in the registry
[1] 2020-10-02 00:09:32.509 INFO  [main] JacksonDataFormat - The option autoDiscoverObjectMapper is set to false, Camel won't search in the registry
[1] 2020-10-02 00:09:32.811 INFO  [vert.x-eventloop-thread-0] VertxPlatformHttpServer - Vert.x HttpServerstarted on 0.0.0.0:8080
[1] 2020-10-02 00:09:32.817 INFO  [main] InternalRouteStartupManager - Route: route1 started and consuming from: knative://event/market.btc.usdt
[1] 2020-10-02 00:09:32.819 INFO  [main] InternalRouteStartupManager - Route: route2 started and consuming from: seda://evaluate
[1] 2020-10-02 00:09:32.820 INFO  [main] InternalRouteStartupManager - Route: route3 started and consuming from: direct://publish
[1] 2020-10-02 00:09:32.821 INFO  [main] AbstractCamelContext - Total 3 routes, of which 3 are started
[1] 2020-10-02 00:09:32.821 INFO  [main] AbstractCamelContext - Apache Camel 3.4.0 (camel-k) started in 0.343 seconds
Condition "Ready" is "True" for Integration simple-predictor
```
To exit the log view, just click here or hit ctrl+c on the terminal window. The integration will keep running on the cluster.



#### Create the second prediction algorithms

The second predictor with more sensitivity called better-predictor, in the command line run:

``kamel run --name better-predictor -p predictor.name=better -p algorithm.sensitivity=0.0005 camel-eventing/Predictor.java -t knative-service.max-scale=1``{{execute}}

You will be prompted with the following result, but please give a couple of minutes for the route to be deployed.
``integration "better-predictor" created``

You can view both predictors from the [Developer Console Topology](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com/topology/ns/camel-knative/graph).
(If Katacoda is slow, you might need to refresh the page to see the correct result.)

![predictors](/openshift/assets/middleware/middleware-camelk/camel-k-eventing/Eventing-Step2-01-predictors.png)

It will be running first and shutdown since there are no activities yet.
