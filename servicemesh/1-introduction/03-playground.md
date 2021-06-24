As you might have noticed in the terminal, Red Hat OpenShift Service Mesh is being installed.  Once completed you will have access to an OpenShift cluster with Service Mesh available.

## Authentication
There are two user accounts available to you.

An administrator account:
* **Username:** `admin`
* **Password:** `admin`

A developer or non-elevated account:
* **Username:** `developer`
* **Password:** `developer`

## Add your project to the service mesh
A quick and easy way to add a new project to the service mesh can be found below.  Be sure to set the NEWPROJECT environment variable to your project's name using:

```
CONTROL_PLANE_NS=istio-system
NEW_PROJECT=UPDATE-ME
```{{execute}}

Now you can add your project to the mesh:

``` 
oc patch -n ${CONTROL_PLANE_NS} --type='json' smmr default -p '[{"op": "add", "path": "/spec/members", "value":["'"${NEW_PROJECT}"'"]}]'
```{{execute}}

## Kiali and Jaeger
Be sure to also check out the Kiali and Jaeger consoles using the links above your terminal window or below.  Login using the OpenShift credentials above.
* [Kiali](https://kiali-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com)
* [Jaeger](https://jaeger-istio-system.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com)

## Bookinfo
The installation script deployed the Istio Bookinfo application in the `bookinfo` project.

Play around using the examples that can be found here: https://istio.io/latest/docs/examples/bookinfo/

For example:
```
oc get virtualservices -n bookinfo
```{{execute}}

