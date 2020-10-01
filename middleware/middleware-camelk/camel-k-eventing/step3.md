#### Run a subscriber investor service

We are going to deploy a service that will listen to the events from the simple predictor.And Display the result from in log.

Go to the text editor on the right, under the folder /root/camel-knative. Right click on the directory and choose New -> File and name it `Investor.java`.


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
``kamel run camel-eventing/investor.java --logs``{{execute}}

To exit the log view, just click here or hit ctrl+c on the terminal window. The integration will keep running on the cluster.


#### Loading the external live data
Now, let's go ahead and start taking live data from the Bitcoin market and pushing it to the event mesh.
Go to the text editor on the right, under the folder /root/camel-knative. Right click on the directory and choose New -> File and name it `market-source.yaml`.
Create the camel route loads Bitcoin market data every 10 seconds.   

Paste the following code into the application.

<pre class="file" data-filename="market-source.yaml" data-target="replace">
# Apache Camel Timer Source
#
# Timer Component documentation: https://camel.apache.org/components/latest/timer-component.html
#
# List of available Apache Camel components: https://camel.apache.org/components/latest/
#
apiVersion: sources.knative.dev/v1alpha1
kind: CamelSource
metadata:
  name: market-source
spec:
  source:
    integration:
      dependencies:
      - camel:jackson
    flow:
      from:
        uri: timer:tick
        parameters:
          period: 10000
        steps:
          - to: "xchange:binance?service=marketdata&method=ticker&currencyPair=BTC/USDT"
          - marshal:
              json: {}
          - log:
              message: "Sending BTC/USDT data to the broker: ${body}"
          - set-header:
              name: CE-Type
              constant: market.btc.usdt
  sink:
    ref:
      apiVersion: eventing.knative.dev/v1beta1
      kind: Broker
      name: default

</pre>

Start the Camel K application

``oc apply -f camel-eventing/market-source.yaml -n camel-knative``{{execute}}

To exit the log view, hit ctrl+c on the terminal window. The integration will keep running on the cluster.

After successfully deployed, you will be able to see it in the [Developer Console Topology](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com/topology/ns/camel-knative/graph).

When the Bitcoin data start floating into the data, all predictor services and the investor service will automatically start up.
