To demonstrate transferring files to and from a running container we first need to deploy an application. To do this run the command:

``oc new-app openshiftkatacoda/blog-django-py --name blog``{{execute}}

So that we can access it from a web browser, we also need to expose it by creating a _Route_.

``oc expose svc/blog``{{execute}}

To monitor the deployment of the application run:

``oc rollout status dc/blog``{{execute}}

The command will exit once the deployment has completed and the web application is ready.