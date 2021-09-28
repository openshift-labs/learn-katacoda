[ocp-serving-components]: https://docs.openshift.com/container-platform/4.7/serverless/architecture/serverless-serving-architecture.html

At the end of this chapter you will be able to:
- Deploy your very first application as an OpenShift Serverless `Service`.
- Learn the underlying components of a Serverless Service, such as: `configurations`, `revisions`, and `routes`.
- Watch the service `scale to zero`.
- `Delete` the Serverless Service.

Now that we have OpenShift Serverless installed on the cluster, we can deploy our first Serverless application, creating a Knative service. But before doing that, let's explore the Serving module.

## Explore Serving
Let's take a moment to explore the new API resources available in the cluster since installing `Serving`.

Like before, we can see what `api-resources` are available now by running: `oc api-resources --api-group serving.knative.dev`{{execute}}

> **Note:** *Before we searched for any `api-resource` which had `KnativeServing` in any of the output using `grep`.  In this section we are filtering the `APIGROUP` which equals `serving.knative.dev`.*

The Serving module consists of a few different pieces.  These pieces are listed in the output of the previous command: `configurations`, `revisions`, `routes`, and `services`.  The `knativeservings` api-resource was existing, and we already created an instance of it to install KnativeServing. 

```bash
NAME              SHORTNAMES      APIGROUP              NAMESPACED   KIND
configurations    config,cfg      serving.knative.dev   true         Configuration
knativeservings   ks              serving.knative.dev   true         KnativeServing
revisions         rev             serving.knative.dev   true         Revision
routes            rt              serving.knative.dev   true         Route
services          kservice,ksvc   serving.knative.dev   true         Service
```

The diagram below shows how each of the components of the Serving module fit together.

![Serving](/openshift/assets/developing-on-openshift/serverless/02-serving/serving.png)

We will discuss what each one of these new resources are used for in the coming sections.  Let's start with `services`.

## OpenShift Serverless Services
As discussed in the [OpenShift Serverless Documentation][ocp-serving-components], a **Knative Service Resource** automatically manages the whole lifecycle of a serverless workload on a cluster. It controls the creation of other objects to ensure that an app has a route, a configuration, and a new revision for each update of the service. Services can be defined to always route traffic to the latest revision or to a pinned revision.

Before deploying your first Serverless Service, let us take a moment to understand it's structure:

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

We now are deploying an instance of a `Service` that is provided by `serving.knative.dev`.  In our simple example we define a container `image` and the paths for `health checking` of the service.  We also provided the `name` and `namespace`.

## Deploy the Serverless Service
To deploy the service we could deploy the yaml above by executing `oc apply -n serverless-tutorial -f 02-serving/service.yaml`, but one of the best features of serverless is the ability to deploy and work with serverless resources without ever working with yaml.  In this tutorial we will use the `kn` CLI tool to work with serverless. 

To deploy the service execute:
```bash
kn service create greeter \
   --image quay.io/rhdevelopers/knative-tutorial-greeter:quarkus \
   --namespace serverless-tutorial
```{{execute}}

> **Note:** *The equivalent yaml for the service above can be seen by executing: `cat 02-serving/service.yaml`{{execute}}*.

Watch the status using the commands:
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
We can see the Serverless Service that we just created by executing: `kn service list`{{execute}}

The output should be similar to:

```bash
NAME      URL                                                     LATEST            AGE     CONDITIONS   READY   REASON
greeter   http://greeter-serverless-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com  greeter-fyrxn-1   6m28s   3 OK / 3     True    
```

> **Note:** *It also is possible to use the `oc` command to see the serverless resources, to see the services execute: `oc get -n serverless-tutorial services.serving.knative.dev`{{execute}}*

The Serverless `Service` gives us information about it's `URL`, it's `LATEST` revision, it's `AGE`, and it's status for each service we have deployed.  It is also important to see that `READY=True` to validate that the service has deployed successfully even if there were no pods running in the previous section.

It also is possible to `describe` a specific service to gather detailed information about that service by executing: `kn service describe greeter`{{execute}}

The output should be similar to:
```bash
Name:       greeter
Namespace:  serverless-tutorial
Age:        15m
URL:        http://greeter-serverless-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com

Revisions:  
  100%  @latest (greeter-fyrxn-1) [1] (15m)
        Image:  quay.io/rhdevelopers/knative-tutorial-greeter:quarkus (pinned to 767e2f)

Conditions:  
  OK TYPE                   AGE REASON
  ++ Ready                  14m 
  ++ ConfigurationsReady    14m 
  ++ RoutesReady            14m 
```

> **Note:** *Most resources can be `described` via the `kn` tool.  Be sure to check them out while continuing along the tutorial.*

Next, we will inspect the `Route`.  Routes manage the ingress and URL into the service.

> *How is it possible to have a service deployed and `Ready` but no pods are running for that service?*
>
> See a hint by inspecting the `READY` column from `oc get deployment`{{execute}}

### Route
As the [OpenShift Serverless Documentation][ocp-serving-components] explains, a `Route` resource maps a network endpoint to one or more Knative revisions. It is possible to manage the traffic in several ways, including fractional traffic and named routes.  Currently, since our service is new, we have only one revision to direct our users to -- in later sections we will show how to manage multiple revisions at once using a `Canary Deployment Pattern`.

We can see the route by executing: `kn route list`{{execute}}

See the `NAME` of the route, the `URL`, as well as if it is `READY`:
```bash
NAME      URL                                                     READY
greeter   http://greeter-serverless-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com  True
```

### Revision
Lastly, we can inspect the `Revisions`.  As per the [OpenShift Serverless Documentation][ocp-serving-components], a `Revision` is a point-in-time snapshot of the code and configuration for each modification made to the workload. Revisions are immutable objects and can be retained for as long as needed. Cluster administrators can modify the `revision.serving.knative.dev` resource to enable automatic scaling of Pods in an OpenShift Container Platform cluster.

Before inspecting revisions, update the image of the service by executing:
```bash
kn service update greeter \
   --image quay.io/rhdevelopers/knative-tutorial-greeter:latest \
   --namespace serverless-tutorial
```{{execute}}.

> **Note:** *Updating the image of the service will create a new revision, or point-in-time snapshot of the workload.*
 
We can see the revision by executing: `kn revision list`{{execute}}

The output should be similar to:
```bash
NAME              SERVICE   TRAFFIC   TAGS   GENERATION   AGE     CONDITIONS   READY   REASON
greeter-qxcrc-2   greeter   100%             2            6m35s   3 OK / 4     True    
greeter-fyrxn-1   greeter                    1            33m     3 OK / 4     True   
```

Here we can see each revision and details including the percantage of `TRAFFIC` it is receiving.  We can also see the generational number of this revision, **which is incremented on each update of the service**.

### Invoke the Service
Now that we have seen a a few of the underlying resouces that get created when deploying a Serverless Service, we can test the deployment.  To do so we will need to use the URL returned by the serverless route.  To invoke the service we can execute the command `curl http://greeter-serverless-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute}}

The service will return a response like **Hi  greeter => '6fee83923a9f' : 1**

> **NOTE:** *You can also open this in your own local browser to test the service!*

### Scale to Zero
The `greeter` service will automatically scale down to zero if it does not get request for approximately 90 seconds.  Try watching the service scaling down by executing `oc get pods -n serverless-tutorial -w`{{execute}}

Try invoking the service again using the `curl` from earlier to see the service scaling back up from zero.

> **Question:** *Do you see now why the pod might not have been running earlier? The service scaled to zero before you checked!*

## Delete the Service
We can easily delete our service by executing: `kn service delete greeter`{{execute}}

Awesome! You have successfully deployed your very first serverless service using OpenShift Serverless. In the next chapter we will go a bit deeper in understanding how to distribute traffic between multiple revisions of the same service.
