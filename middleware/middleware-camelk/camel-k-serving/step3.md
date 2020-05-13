## Setup Serverless

The API integration can also run as Knative service and be able to scale to zero and scale out automatically, based on the received load.

To expose the integration as Knative service, you need to have OpenShift Serverless installed in the cluster. Let's subscribe to the OpenShift Serverless.

``oc apply -f serverless/subscription.yaml``{{execute}}

Next up, you must create a KnativeServing object to install Knative Serving using the OpenShift Serverless Operator.

``oc apply -f serverless/serving.yaml``{{execute}}

The KnativeServing instance will take a minute to install. As you might have noticed, the resources for KnativeServing can be found in the knative-serving project.


We can further validate an install being successful by seeing the following pods in knative-serving project:

``oc get pod -n knative-serving``{{execute}}

When completed, you should see all pods with the status of Running.

```
```
