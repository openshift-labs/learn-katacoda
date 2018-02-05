Now that you've logged into OpenShift, let's deploy a single Red Hat Data Grid (RHDG) instance.
The deployed instance of RHDG will not be clustered. The main goal of this tutorial is familiarize you
with the most simple RHDG deployment on OpenShift and to show how to use RHDG as a REST based cache.

One of the common usages of RHDG is exposing caches and their data through a REST endpoint.
HTTP PUT and POST methods are used to place data in the cache, with URLs encoding the cache name
and key(s) - the data being the body of the request (the data can be anything you like). We'll
cover these details in the next step. First, let's deploy an instance of RHDG on OpenShift.

**1. Deploy RHDG image**

OpenShift supports a wide range of [Deployment configuration options](https://docs.openshift.org/latest/architecture/core_concepts/deployments.html) for apps).


In this tutorial we'll pull an image of RHDG from Docker repository and deploy it in the example project using the following command:

```oc new-app registry.access.redhat.com/jboss-datagrid-7/datagrid71-openshift:latest --name rhdg```{{execute}}

The command new-app will pull a Docker image from internal RedHat repository and create a service named rhdg. You'll see the following output:

```console

--> Creating resources ...
    imagestream "rhdg" created
    deploymentconfig "rhdg" created
    service "rhdg" created
--> Success
    Run 'oc status' to view your app.
```    


**2. Expose RHDG service route**

Now that we have a rhdg service created, we need to expose it to the outside world using OpenShift expose command.
Let's do that next.

```oc expose svc rhdg --name=rhdgroute```{{execute}}

Let's look at the details of rhdg route route resource. We'll use OpenShift describe command:

```oc describe route rhdgroute```{{execute}}

You'll see the output similar to this:

```console
Name:                   rhdgroute
Namespace:              example
Created:                5 minutes ago
Labels:                 app=rhdg
Annotations:            openshift.io/host.generated=true
Requested Host:         jdgroute-example.2886795312-80-simba02.environments.katacoda.com
                          exposed on router router 5 minutes ago
Path:                   <none>
TLS Termination:        <none>
Insecure Policy:        <none>
Endpoint Port:          8080-tcp

Service:        rhdg
Weight:         100 (100%)
Endpoints:      172.20.0.3:8080, 172.20.0.3:11333, 172.20.0.3:8443 + 3 more...
```

Now that we have a single RHDG instance running and exposed to the outside world, let's make some use of it.
