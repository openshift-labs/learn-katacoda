Now that you've logged into OpenShift, let's deploy a single Red Hat JBoss Data Grid (JDG) instance.

**1. Deploy JDG image**

OpenShift supports a wide range of [Deployment configuration options](https://docs.openshift.org/latest/architecture/core_concepts/deployments.html) for apps).


In this tutorial we'll pull an image of JDG from Docker repository and deploy it in the example project using the following command:

```oc new-app registry.access.redhat.com/jboss-datagrid-7/datagrid71-openshift:latest --name jdg```{{execute}}

The command new-app will pull a Docker image from internal RedHat repository and create a service named jdg. You'll see the following output:

```console

--> Creating resources ...
    imagestream "jdg" created
    deploymentconfig "jdg" created
    service "jdg" created
--> Success
    Run 'oc status' to view your app.
```    


**2. Expose JDG service route**

Now that we have a jdg service created, we need to expose it to the outside world using Openshift expose command.
Let's do that next.

```oc expose svc jdg --name=jdgroute```{{execute}}

Let's look at the details of jdgroute route resource. We'll use Openshift describe command:

```oc describe route jdgroute```{{execute}}

You'll see the output similar to this:

```console
Name:                   jdgroute
Namespace:              example
Created:                5 minutes ago
Labels:                 app=jdg
Annotations:            openshift.io/host.generated=true
Requested Host:         jdgroute-example.2886795312-80-simba02.environments.katacoda.com
                          exposed on router router 5 minutes ago
Path:                   <none>
TLS Termination:        <none>
Insecure Policy:        <none>
Endpoint Port:          8080-tcp

Service:        jdg
Weight:         100 (100%)
Endpoints:      172.20.0.3:8080, 172.20.0.3:11333, 172.20.0.3:8443 + 3 more...
```

Now that we have JDG instance running and exposed to the outside world, let's make some use of it.
