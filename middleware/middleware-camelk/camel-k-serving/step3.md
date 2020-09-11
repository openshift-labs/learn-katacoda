## Setup Serverless

The API integration can also run as Knative service and be able to scale to zero and scale out automatically, based on the received load.

To expose the integration as Knative service, you need to have OpenShift Serverless installed in the cluster. Let's subscribe to the OpenShift Serverless.

``oc apply -f serverless/subscription.yaml``{{execute}}

subscription.operators.coreos.com/servicemeshoperator created
subscription.operators.coreos.com/serverless-operator created

Next up, you must create a KnativeServing object to install Knative Serving using the OpenShift Serverless Operator.

``oc apply -f serverless/serving.yaml``{{execute}}

The KnativeServing instance will take a minute to install. As you might have noticed, the resources for KnativeServing can be found in the knative-serving project.



We can further validate an install being successful by seeing the following pods in knative-serving project:

``oc get pod -n knative-serving -w ``{{execute}}

When completed, you should see all pods with the status of Running.

```
NAME                                READY   STATUS    RESTARTS   AGE
activator-d6478496f-x689c           1/1     Running   0          2m10s
autoscaler-6ff6d5659c-5nq44         1/1     Running   0          2m9s
autoscaler-hpa-868c8b56b4-s6jln     1/1     Running   0          2m10s
controller-55b4748bc5-h5wxc         1/1     Running   0          2m6s
networking-istio-679dfcd5d7-mbt8v   1/1     Running   0          2m4s
webhook-55b96d44f6-k7qmk            1/1     Running   0          2m6s
```

Ctrl-C to exit.

Congratulations, you now have a serverless platform installed, lets move on and make our API application serverless.
