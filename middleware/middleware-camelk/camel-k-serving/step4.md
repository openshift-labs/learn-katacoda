## Making Camel K Serverless


With the same set of code written in Camel K, you can run it as a Serverless integration:

``kamel run camel-api/API.java --open-api helper/openapi.yaml --property-file camel-api/minio.properties --dependency camel-quarkus-openapi-java --profile Knative``{{execute}}

Notice, when you allow, Camel K will automatically deploy the camel routes as Serverless services so the routes can be auto scalable and scale down to zero when not needed.

Check the integrations to see when they are ready:

``oc get integrations``{{execute}}

An integration named api should be present in the list and it should be in status Running.

``
NAME    PHASE   KIT
api     Running kit-bte009bi9eodqqhokkkg
``
We can see the Serverless Service that we just created by executing:

``oc get services.serving.knative.dev api -n camel-api``{{execute}}


We can see the route by executing:

``oc get routes.serving.knative.dev api -n camel-api``{{execute}}


The Camel K API service will automatically scale down to zero if it does not get request for approximately 90 seconds. Try watching the service scaling down from [OpenShift Dev Console](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com/topology/ns/camel-api/graph).

![scalezero](/openshift/assets/middleware/middleware-camelk/camel-k-serving/Serving-Step4-01-scalezero.png)

Invoking the service to see the service scaling up.
``URL=$(oc get routes.serving.knative.dev api -o jsonpath='{.status.url}')``{{execute}}

Get the list of objects:

``curl -i $URL/``{{execute}}

It should be empty.

Watch the service scaling up from [OpenShift Dev Console](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com/topology/ns/camel-api/graph) login with *admin/admin*. If you wait at another 90 seconds without invoking the API, you'll find that the pod will disappear. Calling the API again will make the pod appear to serve the request.

![scaleup](/openshift/assets/middleware/middleware-camelk/camel-k-serving/Serving-Step4-02-scaleup.png)


## Congratulations

In this scenario you got to play with Camel K. Exposing RESTFul service using and OpenAPI Standard document. And also making it SERVERLESS. There are much more to Camel K. Be sure to visit [Camel K](https://camel.apache.org/camel-k/latest/index.html) to learn even more about the architecture and capabilities of this exciting new framework.
