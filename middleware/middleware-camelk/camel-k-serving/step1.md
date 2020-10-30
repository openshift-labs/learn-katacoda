In order to run Camel K, you will need access to an Kubernetes/OpenShift environment. Let's setup the fundamentals.

## Logging in to the Cluster via Dashboard

Click the [Console](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com) tab to open the dashboard.

You will then able able to login with admin permissions with:

* **Username:** ``admin``{{copy}}
* **Password:** ``admin``{{copy}}


## Logging in to the Cluster via CLI

Before creating any applications, login as admin. This will be required if you want to log in to the web console and
use it.

To login to the OpenShift cluster from the _Terminal_ run:

``oc login -u admin -p admin``{{execute}}

This will log you in using the credentials:

* **Username:** ``admin``
* **Password:** ``admin``

Use the same credentials to log into the web console.


## Creating your own Project

To create a new project called ``camel-api`` run the command:

``oc new-project camel-api``{{execute}}

## Install Camel K Operator

The Catalog Operator is responsible for building, deploying Camel Applications and also creating surrounding resources. It is also responsible for watching any code or configuration updates and automatically updates it. To install simply run the command.


``kamel install``{{execute}}

 you will see this prompt:

```
Camel K installed in namespace camel-api
```

To check if Camel K operator has successfully installed,
``oc get pod -w``{{execute}}

once camel-k-operator starts the Running status, it means it is successfully installed.
```
NAME                                READY   STATUS    RESTARTS   AGE
camel-k-operator-554df8d75c-d2dx5   1/1     Running   0          84s
```


## Setup the generic object datastore

Lets start Minio, it provide a S3 compatible protocol for storing the objects.
To create the minio backend, just apply the provided file:

``oc apply -f minio/minio.yaml``{{execute}}

Now you have a working generic object datastore.
