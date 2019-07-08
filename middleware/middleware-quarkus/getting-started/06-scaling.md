Now that we have our app running on OpenShift, let's see what we can do.

## Restrict resources

Let's make _sure_ our Quarkus app doesn't go beyond a reasonable amount of memory for each instance by setting _resource constraints_ on it. We'll go with 50 MB of memory as an upper limit (which is pretty thin, compared to your average Java app!). This will let us scale up quite a bit. Click here to set this limit:

`oc set resources dc/quarkus-quickstart --limits=memory=50Mi`{{execute T1}}

## Scale the app

With that set, let's see how fast our app can scale up to 10 instances:

`oc scale --replicas=10 dc/quarkus-quickstart`{{execute T1}}

Back in the [Overview in the OpenShift Console](https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com/console/project/quarkus/overview) you'll see the app scaling dynamically up to 10 pods:

![Scaling](/openshift/assets/middleware/quarkus/scaling.png)

This should only take a few seconds to complete the scaling. Now that we have 10 pods running, let's hit it with some load:

`for i in {1..50} ; do curl http://quarkus-quickstart-quarkus.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/hello/greeting/quarkus-on-openshift ; sleep .05 ; done`{{execute T1}}

You can see the 10 instances of our Quarkus app being load-balanced and responding evenly:

```console
hello quarkus-on-openshift from quarkus-quickstart-2-tfvn4
hello quarkus-on-openshift from quarkus-quickstart-2-8f45l
hello quarkus-on-openshift from quarkus-quickstart-2-xgg97
hello quarkus-on-openshift from quarkus-quickstart-2-8xw8b
...
```

> For more fun with load balancing and apps, checkout the [Red Hat Developer Istio Tutorial](https://bit.ly/istio-tutorial) and learn how to control this with much greater precision and flexibility!

10 not enough? Let's try 50:

`oc scale --replicas=50 dc/quarkus-quickstart`{{execute T1}}

Back in the [Overview in the OpenShift Console](https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com/console/project/quarkus/overview) you'll see the app scaling dynamically up to 50 pods:

![Scaling to 50](/openshift/assets/middleware/quarkus/50pods.png)

Once they are all up and running, try the same load again:

`for i in {1..50} ; do curl http://quarkus-quickstart-quarkus.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/hello/greeting/quarkus-on-openshift ; sleep .05 ; done`{{execute T1}}

And witness all 50 pods responding evenly to requests. Try doing that with your average Java app running in a container! This tutorial uses a single node OpenShift cluster, but in practice you'll have many more nodes, and can scale to hundreds or thousands of replicas if and when load goes way up.

> 50 still not enough? Are you feeling lucky? Try **100**: `oc scale --replicas=100 dc/quarkus-quickstart`{{execute T1}} and watch the magic on the [OpenShift Console](https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com/console/project/quarkus/overview)

## Congratulations

In this scenario you got a glimpse of the power of Quarkus apps, both traditional JVM-based as well as native builds. There is much more to Quarkus than fast startup times and low resource usage, so keep on exploring additional scenarios to learn more, and be sure to visit [quarkus.io](https://quarkus.io) to learn even more about the architecture and capabilities of this exciting new framework for Java developers. 
