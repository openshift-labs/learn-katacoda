At the end of this chapter you will be able to  deploy your very first application as an OpenShift Serverless Service. 

## Explore the Service

Before you deploy the serverless service, let us take a moment to understand its structure

Open the file **/root/serverless/assets/basics/service.yaml** `/root/serverless/assets/basics/service.yaml`{{open}}

TODO **some explanation about the service yaml**

## Deploy the service

Clear our terminal `clear`{{execute interrupt}} before running the next exercises.

To deploy the service execute `oc apply -n serverless-tutorial -f basics/service.yaml`{{execute}}

As it will take some time for the service to come up you can watch the status using the command `oc -n serverless-tutorial get pods -w`{{execute}}

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
