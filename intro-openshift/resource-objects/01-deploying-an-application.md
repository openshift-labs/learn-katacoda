Before you can start this course you need to deploy a sample application to work with.

The first step is to ensure you are logged in as the ``developer`` user.

``oc login --user developer --password developer``{{execute}}

Next create a new project to add the application to, by running:

``oc new-project myproject``{{execute}}

This should automatically switch you to the new project, so you are ready to deploy the application.

The application you are going to deploy is the Apache HTTPD server. The image for this is S2I enabled. This means that it can be run against a Git repository containing the files you want the Apache HTTPD server to host. In this case you are going to deploy a small web site to tell people about an awesome new web site that you are working on and which is coming soon.

``oc new-app getwarped/s2i-httpd-server~https://github.com/getwarped/httpd-parked-domain.git --name coming-soon``{{execute}}

By default when using ``oc new-app`` from the command line to deploy an application, the application will not be exposed to the public. As our final step you therefore need to expose the service so that people can access it.

``oc expose svc/coming-soon``{{execute}}

You are now ready to start investigating the resource objects which were created.
