## When the market closes...

Bitcoin market never closes, but closing hours are expected to be present for standard markets. We're going to simulate a closing on the market by stopping the source integration.

When the market closes and updates are no longer pushed into the event mesh, all downstream services will scale down to zero. This includes the two prediction algorithms, the two services that receive events from the mesh and also the external investor service.

To simulate a market close, we will delete the market-source:

``kamel delete market-source``{{execute}}

To see the other services going down, go to the [Developer Console Topology view](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com/topology/ns/camel-knative/graph) after two minutes, you will see the pod slowly shutdown.

![marketclose](/openshift/assets/middleware/middleware-camelk/camel-k-eventing/Eventing-Step4-01-marketclose.png)

## Congratulations

In this scenario you got to play with Camel K and Serverless - Knative Eventing. We use Camel K as a Source to load data into event mesh based on Broker. And create couple of functions using Camel K that subscribe to the events in the mesh. There are much more to Camel K. Be sure to visit [Camel K](https://camel.apache.org/camel-k/latest/index.html) to learn even more about the architecture and capabilities of this exciting new framework.
