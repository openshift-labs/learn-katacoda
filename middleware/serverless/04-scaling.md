At the end of this chapter you will be able to:
- Understand `scale-to-zero` in depth and why it’s important.
- Understand how to configure the `scale-to-zero-grace-period`.
- Understand types of `autoscaling strategies`.
- Enable `concurrency based autoscaling`.
- Configure a `minimum number of replicas` for a service.
- Configure a `Horizontal Pod Autoscaler` for a service.

## In depth: Scaling to Zero
As you might recall from the `Deploying your Service` section of the tutorial, Scale-to-zero is one of the main properties of Serverless. After a defined time of idleness *(called the `stable-window`)* a revision is considered inactive, which causes a few things to happen.  First off, all routes pointing to the now inactive revision will be pointed to the so-called **activator**. 

![serving-flow](/openshift/assets/middleware/serverless/04-scaling/serving-flow.png)

The name `activator` is somewhat misleading these days.  Originally it used to activate inactive revisions, hence the name.  Today it's primary responsibilites are to receive and buffer requests for revisions that are inactive as well as report metrics to the autoscaler.  

After the revision has been deemed idle, by not receiving any traffic during the `stable-window`, the revision will be marked inactive.  If **scaling to zero** is enabled then there is an additional grace period before the inactive revision terminates, called the `scale-to-zero-grace-period`.  When **scaling to zero** is enabled the total termination period is equal to the sum of both the `stable-window` (default=60s) and `scale-to-zero-grace-period` (default=30s) = default=90s.

If we try to access the service while it is scaled to zero the activator will pick up the request(s) and buffer them until the **Autoscaler** is able to quickly create pods for the given revison.

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

In this tutorial we are going to leave the configuration as-is, but if you had reasons to change them you could edit this configmap as needed.

> **Tip:** Another, possibly better, way to make those changes would be to add your configurations to the `KnativeServing` instance that we applied in the `Prepare for Exercises` section early in this tutorial.
>
> We can open and inspect that yaml by executing: `cat 01-prepare/serving.yaml`{{execute}}
>
> *In that defination we can see that there already is a default override for the `config-network` configmap which overrides the `spec.config.network.domainTemplate` field, allowing Serverless routes to work in this specific environment (you likely wouldn't need this configuration).  If, for example, you wanted to disable scaling-to-zero it would be trivial to set `spec.config.autoscaler.enable-scale-to-zero = "false"` in that configuration before installing Serving.*
>
> You can see the other settings of Serverless by describing other configmaps in the `knative-serving` project.
>
> Explore what all is available by running: `oc get cm -n knative-serving`{{execute}}

Now, log back in as the developer as we do not need elevated privileges to continue: `oc login -u developer -p developer`{{execute}}

## Minimum Scale
By default, Serverless Serving allows for 100 concurrent requests into each revision and allows the service to scale down to zero, so you don't use any resources running idle processes!  This is the out of the box configuration, and it works quite well depending on the needs of the specific application.

Sometimes your application traffic is unpredicatble, bursting often, and when the app is scaled to zero it takes some time to come back up -- giving a slow start to your first users.

To solve for this, you might want to allow a few processes sit idle waiting for the initial users by specifying a minimum scale for your service to be able to handle that sudden burst of users.  This can be done via an the annotation `autoscaling.knative.dev/minScale` in your service.

> **Note:** *You can also limit your maximum pods using `autoscaling.knative.dev/maxScale`*

```yaml
# ./assets/04-scaling/service-min-max-scale.yaml

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

In the service definition above you can see that we configure the minimum scale to 2.  You might also have noticed that we also specified a maximum scale to 5.

Deploy the service by executing: `oc apply -n serverless-tutorial -f 04-scaling/service-min-max-scale.yaml`{{execute}}

Now we can see that the `prime-generator` is deployed and it will never be scaled outside of 2-5 pods available by checking: `oc get pods -n serverless-tutorial`{{execute}}

We now guarentee that we will have two instances available at all times to provide us with no initial lag at the cost of consuming additional resources.  Let's test the service won't scale past 5.

To load the service we will use [hey](https://github.com/rakyll/hey).  We will send 2550 total requests `-n 2550`, of which 850 will be preformed concurrently each time `-c 850`.  Immediatly after we will get the deployments in our project to be able to see the number of pods running.

`hey -n 2550 -c 850 -t 60 "http://prime-generator-serverless-tutorial-ks.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/?sleep=3&upto=10000&memload=100" && oc get deployment -n serverless-tutorial`{{execute}}

> **Note:** *This might take a few moments!*

Here we should have noticed that `5/5` pods should be marked as `READY`, confirming our max scale.

## AutoScaling
As mentioned before, Serverless by default is will scale up when there are 100 concurrent requests coming in at one time.  This scaling factor might work well for some applications, but not all -- fortunately this is a tuneable factor!  In our case you might notice that a given app isn't using it's resources too effectively as each request is CPU-bound.

To help with this, we can adjust the service to scale up sooner, say 50 concurrent requests.  All we need to do is add an `autoscaling.knative.dev/target` annotation to the definition below.

```yaml
# ./assets/04-scaling/service-50.yaml

apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: prime-generator
  namespace: serverless-tutorial
spec:
  template:
    metadata:
      annotations:
        # Target 50 in-flight-requests per pod.
        autoscaling.knative.dev/target: "50"
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

Let's update the prime-generator service by executing: `oc apply -n serverless-tutorial -f 04-scaling/service-50.yaml`{{execute}}

Again we can test the scaling by loading our service.  This time we will send 1100 total requests, of which 275 will be preformed concurrently each time.

`hey -n 1100 -c 275 -t 60 "http://prime-generator-serverless-tutorial-ks.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/?sleep=3&upto=10000&memload=100" && oc get deployment -n serverless-tutorial`{{execute}}

Here we should have noticed that at least 6 pods should be up and running.  You might notice more than 6 as `hey` could be overloading the amount of concurrent workers at one time.

This will work well, but given that we are CPU-bound instead of request bound we might want to choose a different autoscaling class that is based on CPU load to be able to manage our scaling more effectively.

## HPA AutoScaling
CPU based autoscaling metrics are acheived using something called a Horizontal Pod Autoscaler (HPA).  In our example we want to scale up when we start using 70% of the CPU.  We do this by adding three new annotations to our service: `autoscaling.knative.dev/{metric,target,class}`


```yaml
# ./assets/04-scaling/service-hpa.yaml

apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: prime-generator
  namespace: serverless-tutorial
spec:
  template:
    metadata:
      annotations:
        autoscaling.knative.dev/metric: cpu
        autoscaling.knative.dev/target: "70"
        autoscaling.knative.dev/class: hpa.autoscaling.knative.dev
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

Let's update the prime-generator service by executing: `oc apply -n serverless-tutorial -f 04-scaling/service-hpa.yaml`{{execute}}

> **Note:** *Getting the service to scale on the large CPU nodes that this tutorial is running on is relatively hard.  If you have any ideas to see this in action let put an issue in at https://github.com/openshift-labs/learn-katacoda*

## Delete the Service

We can cleanup the project using: `oc -n serverless-tutorial delete services.serving.knative.dev prime-generator`{{execute}}

Congrats! You are now a Serverless Scaling Expert!  We can now adjust and tune Serverless scaling using concurrency or CPU based HPAs.
