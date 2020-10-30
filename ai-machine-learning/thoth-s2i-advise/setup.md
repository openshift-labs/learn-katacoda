Before you get started we recommend reading the following steps. They explain
a bit about how the playground environment is setup and what access you have.

## Logging in to the Cluster via Dashboard

Click the [Console](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com) tab to open the dashboard. 

You will then able able to login with admin permissions with:

* **Username:** ``admin``{{copy}}
* **Password:** ``admin``{{copy}}

## Logging in to the Cluster via CLI

When the OpenShift playground is created you will be logged in initially as
a cluster admin (`oc whoami`{{execute}}) on the command line. This will allow you to perform
operations which would normally be performed by a cluster admin.

Before creating any applications, it is recommended you login as a distinct
user. This will be required if you want to log in to the web console and
use it.

To login to the OpenShift cluster from the _Terminal_ run:

``oc login -u admin -p admin``{{execute}}

This will log you in using the credentials:

* **Username:** ``admin``
* **Password:** ``admin``

Use the same credentials to log into the web console.
For simplicity we are logging in here as admin.

## Creating your own Project

To create a new project called ``myproject`` run the command:

``oc new-project myproject``{{execute}}

You could instead create the project from the web console. If you do this,
to change to the project from the command line run the command:

``oc project myproject``{{execute}}

Now that you have created your own project, me move to the next
step. 