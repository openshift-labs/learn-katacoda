In this Tutorial you are going to learn how to test an HTTP/REST driven application with [Citrus Framework](https://citrusframework.org/). One benefit of this Framework is its ability to test systems based on real messages and with all kinds of protocols. This makes the tests independent from the implementation technology of the system under test. You will now test a HTTP-API which is written in Javascript and running on nodejs in an Openshift-cluster.

But first things first: You need a running system under test in order to test it.

We prepared a simple API-application on [Github](https://github.com/tnobody/todo-example-api.git) which you will deploy on openshift in this step.

Thanks to Openshifts capabilities to deploy applications from a Dockerfile this requires only a few steps.

First of all, you will need an Openshift project, so login to the OpenShift cluster:

`
oc login -u developer -p developer [[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com
`{{execute}}

This will log you in using the credentials:
- __Username__: `developer`
- __Password__: `developer`

Then run:

`
oc new-project todo-api-sut
`{{execute}}

to create a new project __todo-api-sut__ in Openshift (this project is automatically set as your active project).

Now you can deploy the application by the Dockerfile directly from Github:

`
oc new-app https://github.com/tnobody/todo-example-api.git --name=todo-api
`{{execute}}

Since the deployment might take a little time, you can follow the progress with:

`
oc logs bc/todo-api --follow
`{{execute}}

To have access to the deployed application on Openshift as an endpoint, you have to create a Route with:

`
oc expose svc/todo-api
`{{execute}}

If everything worked fine, you should be able to access the [index page]
(http://todo-api-todo-api-sut.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com).
