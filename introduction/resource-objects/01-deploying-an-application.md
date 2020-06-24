Before you can start this course you need to deploy a sample application to work with.

The first step is to ensure you are logged in as the ``developer`` user.

``oc login --username developer --password developer``{{execute}}

Next create a new project to add the application to, by running:

``oc new-project myproject``{{execute}}

This should automatically switch you to the new project, so you are ready to deploy the application.

The application you are going to deploy is the ParksMap web application used in the _Getting Started with OpenShift for Developers_ Katacoda course.

``oc new-app openshiftroadshow/parksmap-katacoda:1.2.0 --name parksmap``{{execute}}

By default when using ``oc new-app`` from the command line to deploy an application, the application will not be exposed to the public. As our final step you therefore need to expose the service so that people can access it.

``oc expose svc/parksmap``{{execute}}

You are now ready to start investigating the resource objects which were created.
