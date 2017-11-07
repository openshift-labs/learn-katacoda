Before you get started we recommend reading the following tips. They explain
a bit about how they playground environment is setup and what access you have.

## Logging in to the Cluster

When the OpenShift playground is created you will be logged in initially as
a cluster admin on the command line. This will allow you to perform
operations which would normally be performed by a cluster admin.

Before creating any applications, it is recommended you login as a distinct
user. This will be required if you want to be able to log in to the web
console and use it.

To login to the OpenShift cluster used for this course from the _Terminal_,
run:

``oc login -u developer -p developer``{{execute}}

This will log you in using the credentials:

* **Username:** ``developer``
* **Password:** ``developer``

Use the same credentials to log into the web console.

In order that you can still run commands from the command line as a cluster
admin, the ``sudoer`` role has been enabled for the ``developer`` account.
To execute a command as a cluster admin use the ``--as system:admin`` option
to the command.

## Creating your own Project

To create a new project called ``myproject`` run the command:

``oc new-project myproject``{{execute}}

You could instead create the project from the web console. If you do this,
to change to the project from the command line run the command:

``oc project myproject``{{execute}}
