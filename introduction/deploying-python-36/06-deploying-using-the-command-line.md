You now have a clean project again, so lets deploy the same web application, but this time using the ``oc`` command line program.

The URL of the Git repository containing the web application is:

`https://github.com/openshift-katacoda/blog-django-py`

We want to deploy it using the S2I builder for the latest version of Python provided by the platform. To do this run the command:

``oc new-app python:latest~https://github.com/openshift-katacoda/blog-django-py --name blog``{{execute}}

This should display output similar to:

```
--> Found image 1101339 (18 hours old) in image stream "openshift/python" under tag "latest" for "python:latest"

    Python 3.5
    ----------
    ...

    Tags: builder, python, python35, rh-python35

    * A source build using source code from https://github.com/openshift-katacoda/blog-django-py will be created
      * The resulting image will be pushed to image stream "blog:latest"
      * Use 'start-build' to trigger a new build
    * This image will be deployed in deployment config "blog"
    * Port 8080/tcp will be load balanced by service "blog"
      * Other containers can access this service through the hostname "blog"

--> Creating resources ...
    imagestream "blog" created
    buildconfig "blog" created
    deploymentconfig "blog" created
    service "blog" created
--> Success
    Build scheduled, use 'oc logs -f bc/blog' to track its progress.
    Run 'oc status' to view your app.
```

OpenShift will assign a default name for the application created based on the name of the Git repository. In this case that would have been ``blog-django-py``. By supplying the ``--name`` option along with the name you wish to use as an argument, as we did here, you can override the name used.

To monitor the log output from the build as it is running, run the command:

``oc logs bc/blog --follow``{{execute}}

This command will exit once the build has completed. You can also interrupt the command by typing _CTRL-C_ in the terminal window.

To view the status of any applications deployed to the project you can run the command:

``oc status``{{execute}}

Once the build and deployment of the application has completed you should see output similar to:

```
In project myproject on server https://172.17.0.23:8443

svc/blog - 172.30.35.238:8080
  dc/blog deploys istag/blog:latest <-
    bc/blog source builds https://github.com/openshift-katacoda/blog-django-py on openshift/python:latest
    deployment #1 deployed 4 minutes ago - 1 pod

View details with 'oc describe <resource>/<name>' or list everything with 'oc get all'.
```

Unlike the case of deploying the application from the web console, the application is not exposed outside of the OpenShift cluster by default. To expose the application created so it is available outside of the OpenShift cluster, you can run the command:

``oc expose service/blog``{{execute}}

Switch to the OpenShift web console by selecting on _Dashboard_ to verify that the application has been deployed. Select on the URL displayed on the _Overview_ page for the project to visit the application.

Alternatively, to view the hostname assigned to the route created from the command line, you can run the command:

``oc get route/blog``{{execute}}
