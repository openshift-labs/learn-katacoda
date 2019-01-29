In this Tutorial you are going to learn how to test an HTTP/Rest driven application with [Citrus Framework](https://citrusframework.org/). One benefit of this framework is, that it tests systems based on messages and protocals. This makes the tests independet from the implementation technology of the system under test. In this tutorial you'll test a HTTP-Api wich is written in JavaScript and running on node.js in an OpenShift-cluster.

But first things first: You need a running system under test in order to test it.

We prepared a simple api-application on [Github](https://github.com/tnobody/todo-example-api.git) which you'll deploy on OpenShift in this step.

Thanks to OpenShifts capabilites to deploy applications from a Dockerfile this requires only a few steps.

First of all you need a project in OpenShift, so login to the OpenShift cluster:

`
oc login -u developer -p developer
`{{execute}}

This will log you in using the credentials:
- __Username__: `developer`
- __Password__: `developer`

Then run

`
oc new-project todo-api-sut
`{{execute}}

to create a new Project __todo-api-sut__ in Openshift (this project is automatically set as your active project).

Now you can deploy he application by the Dockerfile directly from Github.

`
oc new-app https://github.com/tnobody/todo-example-api.git --name=todo-api --image-stream=openshift/nodejs:latest
`{{execute}}

Since the deployment might take a little time you can follow the progress with (abort with CTRL+c):

`
oc logs bc/todo-api --follow
`{{execute}}

Now the api shoudl be deployed to OpenShift. To make the endpoints accessible for a HTTP-Client you have to create a Route with:

`
oc expose svc/todo-api
`{{execute}}

If everything works fine you should be able to access the [index page](http://todo-api-todo-api-project.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com).