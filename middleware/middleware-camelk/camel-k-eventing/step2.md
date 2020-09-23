## Bitcoin realtime trading analyzes system

The example shows a simplified trading system that analyzes price variations of Bitcoins (BTC / USDT), using different prediction algorithms, and informs downstream services when it's time to buy or sell bitcoins (via CloudEvents). It uses real data from the bitcoin exchange market, obtained in real time via the Camel XChange component.

####Enabling the Knative Eventing Broker

The central piece of the event mesh that we're going to create is the Knative Eventing broker. It is a publish/subscribe entity that Camel K integrations will use to publish events or subscribe to it in order to being triggered when events of specific types are available. Subscribers of the eventing broker are Knative serving services, that can scale down to zero when no events are available for them.

Go back to the working namespace
``oc project camel-knative``{{execute}}

To enable the eventing broker, we create a default broker in the current namespace using namespace labeling:
``oc label namespace camel-knative knative-eventing-injection=enabled``{{execute}}

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

``oc apply -f camel-knative/market-source.yaml -n camel-knative`` {{execute}}

<pre class="file" data-filename="minio.properties" data-target="replace">
# Bucket (referenced in the routes)
api.bucket=camel-k

# Minio information injected into the MinioCustomizer
minio.endpoint=http://minio:9000
minio.access-key=minio
minio.secret-key=minio123


# General configuration
camel.context.rest-configuration.api-context-path=/api-doc
</pre>


We are now ready to start up the application, simply point to the OpenAPI standard document and along with the implemented Camel K application. Notice we are also pointing to the configuration file too.

``kamel run --name api helper/MinioCustomizer.java camel-api/API.java --property-file camel-api/minio.properties --open-api helper/openapi.yaml -d camel-openapi-java``{{execute}}

Wait for the integration to be running (you should see the logs streaming in the terminal window).

```
log
```

After running the integration API, you should be able to call the API endpoints to check its behavior.
Make sure the integration is running, by checking its status:

``oc get integrations``{{execute}}

An integration named api should be present in the list and it should be in status Running. There's also a kamel get command which is an alternative way to list all running integrations.

NOTE: it may take some time, the first time you run the integration, for it to reach the Running state.

After the integration has reached the running state, you can get the route corresponding to it via the following command:

``URL=http://$(oc get route api -o jsonpath='{.spec.host}')``{{execute}}

Get the list of objects:
``curl $URL/``{{execute}}

Since there are nothing in the storage, you won't see anything for now.

Upload an object:
``curl -i -X PUT --header "Content-Type: application/octet-stream" --data-binary "/root/camel-api/API.java" $URL/example``{{execute}}

Get the new list of objects:
``curl -i $URL/``{{execute}}

You will see the *['example']* that we have just uploaded from previous step

Get the content of a file:
``curl -i $URL/example``{{execute}}

You will see what was in your *API.java* file

Delete the file:
``curl -i -X DELETE $URL/example``{{execute}}

Get the list of objects for the last time:
``curl -i $URL/``{{execute}}

The storage is emtpy again, so nothing will return.

Congratulations, you now have a running Restful web Application base on the OpenAPI Document.

Now, let's go ahead and uninstall the API instance.

``kamel delete api``{{execute}}
