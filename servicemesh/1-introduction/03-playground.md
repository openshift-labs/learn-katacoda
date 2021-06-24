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
A quick and easy way to add a new project to the service mesh can be found below.  Be sure to set the NEWPROJECT environment variable before running as an administrator:

```
CONTROL_PLANE_NS=istio-system
NEWPROJECT=default
oc patch -n ${CONTROL_PLANE_NS} --type='json' smmr default -p '[{"op": "add", "path": "/spec/members", "value":["'"${NEWPROJECT}"'"]}]'
```

## Bookinfo
The installation script deployed the Istio Bookinfo application in the `bookinfo` project.

Play around using the examples that can be found here: https://istio.io/latest/docs/examples/bookinfo/
