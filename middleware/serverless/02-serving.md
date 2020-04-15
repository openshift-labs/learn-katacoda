[ocp-serving-components]: https://docs.openshift.com/container-platform/4.2/serverless/serverless-architecture.html#knative-serving-components_serverless-architecture

At the end of this chapter you will be able to:
- Deploy your very first application as an OpenShift Serverless `Service`.
- Learn the underlying components of a Serverless Service, such as: `configurations`, `revisions`, and `routes`.
- Watch the service `scale to zero`.
- `Delete` the Serverless Service.

Now that we have the `OpenShift Serverles Operator` and a `Serverless Serving` Custom Resource (CR) deployed on the cluster we can explore `Serving` by deploying our first `Serverless Service`.

## Explore Serving
Let's take a moment to explore the new API resources available in the cluster since installing `Serving`.

Like before, we can see what `api-resources` are available now by running: `oc api-resources --api-group serving.knative.dev`{{execute}}

> **Note:** *Before we searched for any `api-resource` which had `KnativeServing` in any of the output using `grep`.  In this section we are filtering the `APIGROUP` which equals `serving.knative.dev`.*

You should see that we now have access to `configurations`, `revisions`, `routes`, and `services`.  The `knativeservings` api-resource was existing, and we already created an instance of it to install KnativeServing. 

```bash
NAME              SHORTNAMES      APIGROUP              NAMESPACED   KIND
configurations    config,cfg      serving.knative.dev   true         Configuration
knativeservings   ks              serving.knative.dev   true         KnativeServing
revisions         rev             serving.knative.dev   true         Revision
routes            rt              serving.knative.dev   true         Route
services          kservice,ksvc   serving.knative.dev   true         Service
```

We will discuss what each one of these new resources are used for in the coming sections.  Let's start with `services`.

## OpenShift Serverless Services
As discussed in the [OpenShift Serverless Documentation][ocp-serving-components], a **Knative Service Resource** automatically manages the whole lifecycle of a serverless workload on a cluster. It controls the creation of other objects to ensure that an app has a route, a configuration, and a new revision for each update of the service. Services can be defined to always route traffic to the latest revision or to a pinned revision.

Before you deploy your first Serverless Service, let us take a moment to understand it's structure:

```yaml
# ./assets/02-serving/service.yaml

apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: greeter
  namespace: serverless-tutorial
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

As you can see, we now are deploying an instance of a `Service` that is provided by `serving.knative.dev`.  In our simple example we define a container `image` and the paths for `health checking` of the service.  We also provided the `name` and `namespace`.

## Deploy the Serverless Service
To deploy the service execute: `oc apply -n serverless-tutorial -f 02-serving/service.yaml`{{execute}}

You can watch the status using the commands:
```bash
# ./assets/02-serving/watch-service.bash

#!/usr/bin/env bash
while : ;
do
  output=`oc get pod -n serverless-tutorial`
  echo "$output"
  if [ -z "${output##*'Running'*}" ] ; then echo "Service is ready."; break; fi;
  sleep 5
done

```{{execute}}

A successful service deployment will show the following `greeter` pods:

```shell
NAME                                        READY   STATUS    RESTARTS   AGE
greeter-6vzt6-deployment-5dc8bd556c-42lqh   2/2     Running   0          11s
```

> **Question:** *If you run the watch script too late you might not see any pods running or being created after a few loops and will have to escape out of the watch with `CTRL+C`.  I'll let you think about why this happens.  Continue on for now and validate the deployment.*

## Check out the deployment
As discussed in the [OpenShift Serverless Documentation][ocp-serving-components], Serverless Service deployments will create a few required serverless resources.  We will dive into each of them below.

### Service
We can see the Serverless Service that we just created by executing: `oc get -n serverless-tutorial services.serving.knative.dev`{{execute}}

You should see the output similar to:

```bash
NAME      URL                                                      LATESTCREATED   LATESTREADY     READY   REASON
greeter   http://greeter-serverless-tutorial-ks.apps-crc.testing   greeter-6vzt6   greeter-6vzt6   True
```

The Serverless `Service` gives us information about a `URL` as well as revisions that are `LATESTCREATED` and `LATESTREADY` for each service we have deployed.  It is also important to see that `READY=True` to validate that the service has deployed successfully even if there were no pods running in the previous section.

The URL managed by the route which we will check out next.

> *How is it possible that you could have a service deployed and `Ready` but no pods are running for that service?*
>
> You could see a hint by inspecting the `READY` column from `oc get deployment`{{execute}}

### Route
As the [OpenShift Serverless Documentation][ocp-serving-components] explains, a `Route` resource maps a network endpoint to one or more Knative revisions. You can manage the traffic in several ways, including fractional traffic and named routes.  Currently, since our service is new, we have only one revision to direct our users to -- in later sections we will show how to mahage multiple revisions at once using a `Canary Deployment Pattern`.

We can see the route by executing: `oc get -n serverless-tutorial routes.serving.knative.dev`{{execute}}

You should see the `NAME` of the route, the `URL`, as well as if it is `READY`.

### Configuration
A `Configuration` maintains the required state for your deployment. Modifying a configuration creates a new revision.

Like the previous commands we can see the configuration by executing: `oc get -n serverless-tutorial configurations.serving.knative.dev`{{execute}}

You should see an output similar to:

```bash
NAME      LATESTCREATED   LATESTREADY     READY   REASON
greeter   greeter-6vzt6   greeter-6vzt6   True
```

Here we can see the latest created and latest ready revision to our deployment.  We an also see that it is ready, like the service and route outputs if `Ready` is not `True` then we would see the `Reason` of why not.

We can edit our configuration by pointing our Service to a new container image.  You could edit the original yaml, or use `oc edit configurations.serving.knative.dev greeter` and patching the image there.

In our case we will update the image by executing: `oc get configurations.serving.knative.dev greeter -o yaml | sed 's/knative-tutorial-greeter:quarkus/knative-tutorial-greeter:latest/' | oc replace -f -`{{execute}}

We could quickly check the configurations again to see the changes happening by executing: `oc get -n serverless-tutorial configurations.serving.knative.dev`{{execute}}

```bash
NAME      LATESTCREATED   LATESTREADY     READY     REASON
greeter   greeter-db88f   greeter-6vzt6   Unknown
```

If we get the configurations again after some time to allow for the image to be pulled, we should see:

```bash
NAME      LATESTCREATED   LATESTREADY     READY   REASON
greeter   greeter-db88f   greeter-db88f   True
```

### Revision
Lastly, we can inspect the `Revisions`.  As per the [OpenShift Serverless Documentation][ocp-serving-components], a `Revision` is a point-in-time snapshot of the code and configuration for each modification made to the workload. Revisions are immutable objects and can be retained for as long as needed. Cluster administrators can modify the `revision.serving.knative.dev` resource to enable automatic scaling of Pods in your OpenShift Container Platform cluster.

We can see the revision by executing: `oc get -n serverless-tutorial revisions.serving.knative.dev`{{execute}}

You should see an output similar to:

```bash
NAME            CONFIG NAME   K8S SERVICE NAME   GENERATION   READY   REASON
greeter-2j4j6   greeter       greeter-2j4j6      2            True
greeter-6vzt6   greeter       greeter-6vzt6      1            True
greeter-db88f   greeter       greeter-db88f      3            True
```

Here we can see each revision and the configuration it was generated from, as well as the service that is utilizing this revision.  We can see the generational number of this revision, **which is incremented on each config change**, and the status of the revision.

### Invoke the Service
Now that we have seen a a few of the underlying resouces that get created when deploying a Serverless Service, we can test the deployment.  To do so we will need to use the URL returned by the serverless route.  To invoke the service we can execute the command `curl http://greeter-serverless-tutorial-ks.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute}}

The service will return a response like **Hi  greeter => '6fee83923a9f' : 1**

> **NOTE:** *You can also open this in your own local browser to test the service!*

### Scale to Zero
The `greeter` service will automatically scale down to zero if it does not get request for approximately 90 seconds.  Try watching the service scaling down from [OpenShift Dev Console](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com).

![serving-terminating](/openshift/assets/middleware/serverless/02-serving/terminating.png)

Try invoking the service again as you did earlier to see the service scaling up.

> **Question:** *Do you see now why the pod might not have been running earlier? Your service scaled to zero before you checked!*

## Delete the Service
We can easily delete our service by executing: `oc delete services.serving.knative.dev greeter`{{execute}}

Awesome! You have successfully deployed your very first serverless service using OpenShift Serverless. In the next chapter we will go a bit deeper in understanding how to distribute traffic between multiple revisions of the same service.
