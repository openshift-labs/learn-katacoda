# Scaling your Services
At the end of this chapter you will be able to:
- Understand what scale-to-zero is and why it’s important.
- Configure the scale-to-zero time period.
- Configure the autoscaler.
- Understand types of autoscaling strategies.
- Enable concurrency based autoscaling.
- Configure a minimum number of replicas for a service.

## Deploy Service
The following snippet shows what a Knative service YAML will look like:

#TODO Service.yaml
```yaml
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: greeter
spec:
  template:
    spec:
      containers:
      - image: quay.io/rhdevelopers/knative-tutorial-greeter:quarkus
        livenessProbe:
          httpGet:
            path: /healthz
        readinessProbe:
          httpGet:
            path: /healthz
```

The service can be deployed using the command: `oc -n serverless-tutorial apply -f service.yaml`

After the **deployment** of the service was successful we should see a Kubernetes deployment like `greeter-v1-deployment`.

```
export SVC_URL=`oc get rt greeter -o yaml | yq read - 'status.url'` && http $SVC_URL{{execute}}
```

The last http command should return a response like `Hi greeter ⇒ '9be9ccd9a2e3' : 1`

Check deployed Knative resources for more details on which Knative objects and resources have been created with the service deployment above.

## Scale to Zero
Assuming that Greeter service has been deployed, once no more traffic is seen going into that service, we’d like to scale this service down to zero replicas. That’s called **scale-to-zero**.

Scale-to-zero is one of the main properties making Knative a serverless platform. After a defined time of idleness (the so called `stable-window`) a revision is considered inactive. Now, all routes pointing to the now inactive revision will be pointed to the so-called activator. This reprogramming of the network is asynchronous in nature so the `scale-to-zero-grace-period` should give enough slack for this to happen. Once the `scale-to-zero-grace-period` is over, the revision will finally be scaled to zero replicas.

If another request tries to get to this revision, the activator will get it, instruct the autoscaler to create new pods for the revision as quickly as possible and buffer the request until those new pods are created.

By default the **scale-to-zero-grace-period** is `30s`, and the **stable-window** is `60s`. Firing a request to the greeter service will bring up the pod (if it is already terminated, as described above) to serve the request. Leaving it without any further requests will automatically cause it to scale to zero in approx `60-70 secs`. There are at least 20 seconds after the pod starts to terminate and before it’s completely terminated. This gives Istio enough time to leave out the pod from its own networking configuration.

For better clarity and understanding let us clean up the deployed Knative resources before going to next section.

## Auto Scaling
By default Knative Serving allows 100 concurrent requests into a pod. This is defined by the `container-concurrency-target-default` setting in the configmap **config-autoscaler** in the **knative-serving** namespace.

For this exercise let us make our service handle only 10 concurrent requests. This will cause Knative autoscaler to scale to more pods as soon as we run more than 10 requests in parallel against the revision.

Open the `service-10.yaml` here: **/root/serverless/scaling/service-10.yaml** `/root/serverless/scaling/service-10.yaml`{{open}}

The Knative service definition above will allow each service pod to handle max of 10 in-flight requests per pod (configured via `autoscaling.knative.dev/target` annotation) before automatically scaling to new pod(s)

### Deploy the service:
`oc apply -n serverless-tutorial -f /root/serverless/sacaling/service-10.yaml`{{execute}}

### Invoke the service:
We will not invoke the service directly as we need to send the load to see the autoscaling.  `watch 'oc get pods -n serverless-tutorial'`{{execute}}

### Load the service
We will now send some load to the greeter service. The command below sends 50 concurrent requests (`-c 50`) for the next 10s (`-z 30s`): `hey -c 50 -z 10s "${SVC_URL}/?sleep=3&upto=10000&memload=100"`{{execute}}

After you’ve successfully run this small load test, you will notice the number of greeter service pods will have scaled to 5 automatically.

The autoscale pods is computed using the formula:

`totalPodsToScale = inflightRequests / concurrencyTarget`

With this current setting of **concurrencyTarget=10** and **inflightRequests=50** , you will see Knative automatically scales the greeter services to `50/10 = 5 pods`.

For more clarity and understanding let us clean up existing deployments before proceeding to next section.

## Minium Scale
In real world scenarios your service might need to handle sudden spikes in requests. Knative starts each service with a default of 1 replica. As described above, this will eventually be scaled to zero as described above. If your app needs to stay particularly responsive under any circumstances and/or has a long startup time, it might be beneficial to always keep a minimum number of pods around. This can be done via an the annotation `autoscaling.knative.dev/minScale`.

The following example shows how to make Knative create services that start with a replica count of 2 and never scale below it.

Open the `service-min-max-scale.yaml` here: **/root/serverless/scaling/service-min-max-scale.yaml** `/root/serverless/scaling/service-min-max-scale.yaml`{{open}}

- The deployment of this service will always have a minimum of 2 pods.
- Will allow each service pod to handle max of 10 in-flight requests per pod before automatically scaling to new pods.

`oc apply -n serverless-tutorial -f service-min-max-scale.yaml`{{execute}}

After the deployment was successful we should see a Kubernetes Deployment called `prime-generator-v2-deployment` with **two** pods available.

Open a new terminal and run the following command: `watch 'oc get pods -n serverless-tutorial'`{{execute}}

Let us send some load to the service to trigger autoscaling. ##TODO SCRIPT

When all requests are done and if we are beyond the `scale-to-zero-grace-period`, we will notice that Knative has terminated only 3 out 5 pods. This is because we have configured Knative to always run two pods via the annotation `autoscaling.knative.dev/minScale: "2"`.

## Cleanup
```
oc -n serverless-tutorial delete services.serving.knative.dev greeter &&\
oc -n serverless-tutorial delete services.serving.knative.dev prime-generator
```
