You now have a clean project again, so lets deploy the same web application, but this time using the ``oc`` command line tool.

The URL of the Git repository containing the web application is:

`https://github.com/openshift-katacoda/blog-django-py`

We want to deploy it using the S2I builder for the latest version of Python provided by the platform. To do this run the command:

``oc new-app python:latest~https://github.com/openshift-katacoda/blog-django-py``{{execute}}

This should display output similar to:

```
--> Found image 2437334 (6 weeks old) in image stream "openshift/python" under tag "latest" for "python:latest"

    Python 3.6
    ----------
    ...

    Tags: builder, python, python36, python-36, rh-python36

    * A source build using source code from https://github.com/openshift-katacoda/blog-django-py will be created
      * The resulting image will be pushed to image stream tag "blog-django-py:latest"
      * Use 'oc start-build' to trigger a new build
    * This image will be deployed in deployment config "blog-django-py"
    * Port 8080/tcp will be load balanced by service "blog-django-py"
      * Other containers can access this service through the hostname "blog-django-py"

--> Creating resources ...
    imagestream.image.openshift.io "blog-django-py" created
    buildconfig.build.openshift.io "blog-django-py" created
    deploymentconfig.apps.openshift.io "blog-django-py" created
    service "blog-django-py" created
--> Success
    Build scheduled, use 'oc logs -f bc/blog-django-py' to track its progress.
    Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
     'oc expose svc/blog-django-py'
    Run 'oc status' to view your app.
```

OpenShift will assign a default name for the application created based on the name of the Git repository. In this case that is ``blog-django-py``. If you wanted to change the name, you could have supplied the ``--name`` option along with the name you wish to use as an argument.

To monitor the log output from the build as it is running, run the command:

``oc logs bc/blog-django-py --follow``{{execute}}

This command will exit once the build has completed. You can also interrupt the command by typing _CTRL-C_ in the terminal window.

To view the status of any applications deployed to the project you can run the command:

``oc status``{{execute}}

Once the build and deployment of the application has completed you should see output similar to:

```
In project myproject on server https://openshift:6443

svc/blog-django-py - 172.30.54.158:8080
  dc/blog-django-py deploys istag/blog-django-py:latest <-
    bc/blog-django-py source builds https://github.com/openshift-katacoda/blog-django-py on openshift/python:latest
    deployment #1 pending 10 seconds ago - 0/1 pods


3 infos identified, use 'oc status --suggest' to see details.
```

Unlike the case of deploying the application from the web console, the application is not exposed outside of the OpenShift cluster by default. To expose the application so it is available outside of the OpenShift cluster, you can run the command:

``oc expose service/blog-django-py``{{execute}}

Switch to the OpenShift web console by selecting on _Console_ to verify that the application has been deployed.

You will note though that the visualisation on the topology view lacks icons for the build and source code repository. This is because they rely on special annotations and labels added to the deployment when creating an application from the web console. These annotations are not added automatically when creating the application from the command line. You can add the annotations later if you wanted.

The icon for accessing the URL is still present on the visualisation. Alternatively, to view the hostname assigned to the route created from the command line, you can run the command:

``oc get route/blog-django-py``{{execute}}
