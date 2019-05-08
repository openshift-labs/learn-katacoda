In this section, you deploy a single instance of Red Hat Data Grid (RHDG) that exposes cached data through a REST endpoint.

**1. Deploying RHDG**

Run the **oc new-app** command to pull an image from the RHDG repository and create a service named `rhdg` as follows:

`oc new-app registry.access.redhat.com/jboss-datagrid-7/datagrid71-openshift:latest --name rhdg`{{execute}}

The command output is:

```console

--> Creating resources ...
    imagestream "rhdg" created
    deploymentconfig "rhdg" created
    service "rhdg" created
--> Success
    Run 'oc status' to view your app.
```    

**2. Exposing an external service route**

Run the **oc expose** command to expose the `rhdg` externally to OpenShift as follows:

`oc expose svc rhdg --name=rhdgroute`{{execute}}

You can use the **oc describe** command to view details about the `rhdgroute` route as follows:

`oc describe route rhdgroute`{{execute}}

The command output is similar to:

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

Now that you have a single RHDG instance running on OpenShift with an external route, you can start manipulating data in the cache.
