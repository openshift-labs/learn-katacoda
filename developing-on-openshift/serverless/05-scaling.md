[apachebench]: https://httpd.apache.org/docs/2.4/programs/ab.html 
[learn-katacoda]: https://github.com/openshift-labs/learn-katacoda

At the end of this chapter you will be able to:
- Understand `scale-to-zero` in depth and why it’s important.
- Understand how to configure the `scale-to-zero-grace-period`.
- Understand types of `autoscaling strategies`.
- Enable `concurrency based autoscaling`.
- Configure a `minimum number of replicas` for a service.
- Configure a `Horizontal Pod Autoscaler` for a service.

## In depth: Scaling to Zero
As you might recall from the `Deploying your Service` section of the tutorial, Scale-to-zero is one of the main properties of Serverless. After a defined time of idleness *(called the `stable-window`)* a revision is considered inactive, which causes a few things to happen.  First off, all routes pointing to the now inactive revision will be pointed to the so-called **activator**. 

![serving-flow](/openshift/assets/developing-on-openshift/serverless/05-scaling/serving-flow.png)

The name `activator` is somewhat misleading these days.  Originally it used to activate inactive revisions, hence the name.  Today its primary responsibilites are to receive and buffer requests for revisions that are inactive as well as report metrics to the autoscaler.  

After the revision has been deemed idle, by not receiving any traffic during the `stable-window`, the revision will be marked inactive.  If **scaling to zero** is enabled then there is an additional grace period before the inactive revision terminates, called the `scale-to-zero-grace-period`.  When **scaling to zero** is enabled the total termination period is equal to the sum of both the `stable-window` (default=60s) and `scale-to-zero-grace-period` (default=30s) = default=90s.

If we try to access the service while it is scaled to zero the activator will pick up the request(s) and buffer them until the **Autoscaler** is able to quickly create pods for the given revision.

> **Note:** *You might have noticed an initial lag when trying to access your service.  The reason for that delay is highly likely that your request is being held by the activator!*

First login as an administrator for the cluster: `oc login -u admin -p admin`{{execute}}

It is possible to see the default configurations of the autoscaler by executing: `oc -n knative-serving describe cm config-autoscaler`{{execute}}

Here we can see the `stable-window`, `scale-to-zero-grace-period`, a `enable-scale-to-zero`, amongst other settings.

```bash
...
# When operating in a stable mode, the autoscaler operates on the
# average concurrency over the stable window.
# Stable window must be in whole seconds.
stable-window: "60s"
...
# Scale to zero feature flag
enable-scale-to-zero: "true"
...
# Scale to zero grace period is the time an inactive revision is left
# running before it is scaled to zero (min: 30s).
scale-to-zero-grace-period: "30s"
...
```

In this tutorial leave the configuration as-is, but if there were reasons to change them it is possible to edit this configmap as needed.

> **Tip:** Another, possibly better, way to make those changes would be to add configuration to the `KnativeServing` instance that was applied in the `Prepare for Exercises` section early in this tutorial.
>
> Open and inspect that yaml by executing: `cat 01-prepare/serving.yaml`{{execute}}
>
> There are other settings of Serverless available.  It is possible to describe other configmaps in the `knative-serving` project to find them.
>
> Explore what all is available by running: `oc get cm -n knative-serving`{{execute}}

Now, log back in as the developer as we do not need elevated privileges to continue: `oc login -u developer -p developer`{{execute}}

## Minimum Scale
By default, Serverless Serving allows for 100 concurrent requests into each revision and allows the service to scale down to zero.  This property optimizes the application as it does not use any resources for running idle processes!  This is the out of the box configuration, and it works quite well depending on the needs of the specific application.

Sometimes application traffic is unpredictable, bursting often, and when the app is scaled to zero it takes some time to come back up -- giving a slow start to the first users of the app.

To solve for this, services are able to be configured to allow a few processes to sit idle, waiting for the initial users.  This is configured by specifying a minimum scale for the service via an the annotation `autoscaling.knative.dev/minScale`.

> **Note:** *You can also limit your maximum pods using `autoscaling.knative.dev/maxScale`*

```yaml
# ./assets/05-scaling/service-min-max-scale.yaml

apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: prime-generator
  namespace: serverless-tutorial
spec:
  template:
    metadata:
      annotations:
        # the minimum number of pods to scale down to
        autoscaling.knative.dev/minScale: "2"
        # the maximum number of pods to scale up to
        autoscaling.knative.dev/maxScale: "5"
    spec:
      containers:
        - image: quay.io/rhdevelopers/prime-generator:v27-quarkus
          livenessProbe:
            httpGet:
              path: /healthz
          readinessProbe:
            httpGet:
              path: /healthz

```

In the definition above the minimum scale is configured to 2 and the maximum scale to 5 via two annotations.

Since serverless allows deploying without yaml we will continue to use the `kn` command instead of the above yaml service definition.

Deploy the service by executing:
```bash
kn service create prime-generator \
   --namespace serverless-tutorial \
   --annotation autoscaling.knative.dev/minScale=2 \
   --annotation autoscaling.knative.dev/maxScale=5 \
   --image quay.io/rhdevelopers/prime-generator:v27-quarkus
```{{execute}}

See that the `prime-generator` is deployed and it will never be scaled outside of 2-5 pods available by checking: `oc get pods -n serverless-tutorial`{{execute}}

This now guarantee that there will always be at least two instances available at all times to provide the service with no initial lag at the cost of consuming additional resources.  Next, test the service won't scale past 5.

To load the service we will use [apachebench (ab)][apachebench].  We will configure `ab` to send 2550 total requests `-n 2550`, of which 850 will be performed concurrently each time `-c 850`.  Immediatly after we will show the deployments in the project to be able to see the number of pods running.

`ab -n 2550 -c 850 -t 60 "http://prime-generator-serverless-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/?sleep=3&upto=10000&memload=100" && oc get deployment -n serverless-tutorial`{{execute}}

> **Note:** *This might take a few moments!*

Notice that `5/5` pods should be marked as `READY`, confirming the max scale.

## AutoScaling
As mentioned before, Serverless by default will scale up when there are 100 concurrent requests coming in at one time.  This scaling factor might work well for some applications, but not all -- fortunately this is a tuneable factor!  In some cases you might notice that a given app is not using its resources too effectively as each request is CPU-bound.

To help with this, it is possible to adjust the service to scale up sooner, say 50 concurrent requests via configuring an annotation of `autoscaling.knative.dev/target`.

Update the prime-generator service by executing:
```bash
kn service update prime-generator \
   --annotation autoscaling.knative.dev/target=50
```{{execute}}

> **Note:** *The equivalent yaml for the service above can be seen by executing: `cat 05-scaling/service-50.yaml`{{execute}}*.

Again test the scaling by loading the service.  This time send 275 concurrent requests totaling 1100.

`ab -n 1100 -c 275 -t 60 "http://prime-generator-serverless-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/?sleep=3&upto=10000&memload=100" && oc get deployment -n serverless-tutorial`{{execute}}

Notice that at least 6 pods should be up and running.  There might be more than 6 as `ab` could be overloading the amount of concurrent workers at one time.

This will work well, but given that this application is CPU-bound instead of request bound we might want to choose a different autoscaling class that is based on CPU load to be able to manage scaling more effectively.

## HPA AutoScaling
CPU based autoscaling metrics are achieved using something called a Horizontal Pod Autoscaler (HPA).  In this example we want to scale up when the service starts using 70% of the CPU.  Do this by adding three new annotations to the service: `autoscaling.knative.dev/{metric,target,class}`

Update the prime-generator service by executing:
```bash
kn service update prime-generator \
   --annotation autoscaling.knative.dev/minScale- \
   --annotation autoscaling.knative.dev/maxScale- \
   --annotation autoscaling.knative.dev/target=70 \
   --annotation autoscaling.knative.dev/metric=cpu \
   --annotation autoscaling.knative.dev/class=hpa.autoscaling.knative.dev
```{{execute}}

> **Note:** *Notice that the above `kn` command removes, adds, and updates existing annotations to the service.  To delete use `—annotation name-`.*
>
> *Getting the service to scale on the large CPU nodes that this tutorial is running on is relatively hard.  If you have any ideas to see this in action put an issue in at [this tutorial's github][learn-katacoda]*
>
> *The equivalent yaml for the service above can be seen by executing: `cat 05-scaling/service-hpa.yaml`{{execute}}*.


## Delete the Service

Cleanup the project using: `kn service delete prime-generator`{{execute}}

Congrats! You are now a Serverless Scaling Expert!  We can now adjust and tune Serverless scaling using concurrency or CPU based HPAs.
