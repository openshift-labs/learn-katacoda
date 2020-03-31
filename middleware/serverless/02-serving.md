[ocp-serving-components]: https://docs.openshift.com/container-platform/4.2/serverless/serverless-architecture.html#knative-serving-components_serverless-architecture

At the end of this chapter you will be able to:
- Deploy your very first application as an OpenShift Serverless `Service`.
- Learn the underlying components of a Serverless Service, such as: `configurations`, `revisions`, and `routes`.
- Watch the service `scale to zero`.
- `Delete` the Serverless Service.

Now that we have the `OpenShift Serverles Operator` and a `Serverless Serving` Custom Resource deployed on the cluster we can explore `Serving` by deploying our first `Serverless Service`.

# Explore Serving

Let's take a moment to see what new api resources there are in the cluster since installing `Serving`.

Like before, we can see what `api-resources` by running: `oc api-resources --api-group serving.knative.dev`{{execute}}

> **Note:** *Before we searched for anything with KnativeServing using `grep`, now that we have completed the previous section and created a Custom Resource (CR) of `serving.knative.dev` we have additional api-resources.*

You should see that we now have access to `configurations`, `knativeservings` *(We deployed this one already)*, `revisions`, `routes`, and `services`.

```bash
NAME              SHORTNAMES      APIGROUP              NAMESPACED   KIND
configurations    config,cfg      serving.knative.dev   true         Configuration
knativeservings   ks              serving.knative.dev   true         KnativeServing
revisions         rev             serving.knative.dev   true         Revision
routes            rt              serving.knative.dev   true         Route
services          kservice,ksvc   serving.knative.dev   true         Service
```

We will discuss what each one of these new resources are used for in the coming sections.  Let's start with `services`.

# OpenShift Serverless Services

As discussed in the [OpenShift Serverless Documentation][ocp-serving-components] a **Knative Service Resource** automatically manages the whole lifecycle of a serverless workload on a cluster. It controls the creation of other objects to ensure that an app has a route, a configuration, and a new revision for each update of the service. Services can be defined to always route traffic to the latest revision or to a pinned revision.

Before you deploy your first Serverless Service, let us take a moment to understand it's structure

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

As you can see, we now are deploying an instance of a `Service`.  In our simple example we only define a container `image` and both a `livenessProbe` as well as a `readinessProbe`.

## Deploy the service

To deploy the service execute `oc apply -n serverless-tutorial -f basics/service.yaml`{{execute}}

You can watch the status using the command `oc -n serverless-tutorial get pods -w`{{execute}}

A successful service deployment will show the following `greeter` pods:

```shell
NAME                                       READY   STATUS              RESTARTS   AGE
greeter-q2j7w-deployment-55d67f957-xn5p7   0/2     ContainerCreating   0          22s
```

## See what you have deployed

The OpenShift Serverless Service deployment will create many serverless resources, the following commands will help you to query and find what has been deployed.

### service

`oc get -n serverless-tutorial services.serving.knative.dev`{{execute}}

### configuration

`oc get -n serverless-tutorial configurations.serving.knative.dev`{{execute}}

### revisions

`oc get -n serverless-tutorial revisions.serving.knative.dev`{{execute}}

### routes

`oc get -n serverless-tutorial routes.serving.knative.dev`{{execute}}

## Invoke the service

We need to use the URL returned by the serverless route to invoke the service, execute the command `curl http://greeter.serverless-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute}}

The service will return a response like **Hi  greeter => '6fee83923a9f' : 1**

## Scale to zero

The `greeter` service will automatically scale down to zero if it does not get request for approximately 60 seconds. Try watching the service scaling down from [OpenShift Dev Console](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com).

TODO **screen shot of OpenShift Developer Console**

Try invoking the service again as you did earlier to see the service scaling up.

## Delete the Service

Awesome! You have successfully deployed your very first serverless service using OpenShift serverless. In next chapter we go a bit deep in understanding how to distribute traffic between multiple revisions of same service.

