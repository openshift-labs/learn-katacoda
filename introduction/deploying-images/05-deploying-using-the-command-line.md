You now have a clean project again, so lets deploy the same existing container image, but this time using the ``oc`` command line program.

The name of the image you used previously was:

```
openshiftkatacoda/blog-django-py
```

If you have been given the name of an image to deploy and want to verify that it is valid from the command line, you can use the ``oc new-app --search`` command. For this image run:

``oc new-app --search openshiftkatacoda/blog-django-py``{{execute}}

This should display output similar to:

```
Docker images (oc new-app --docker-image=<docker-image> [--code=<source>])
-----
openshiftkatacoda/blog-django-py
  Registry: Docker Hub
  Tags:     latest
```

It confirms that the image is found on the Docker Hub Registry.

To deploy the image, you can run the command:

``oc new-app openshiftkatacoda/blog-django-py``{{execute}}

This will display out similar to:

```
--> Found container image 927f823 (4 months old) from Docker Hub for "openshiftkatacoda/blog-django-py"

    Python 3.5
    ----------
    Python 3.5 available as container is a base platform for building and running various Python 3.5 applications and frameworks. Python is an easy to learn, powerful programming language. It has efficient high-level data structures and a simple but effective approach to object-oriented programming. Python's elegant syntax and dynamic typing, together with its interpreted nature, make it an ideal language for scripting and rapid application development in many areas on most platforms.

    Tags: builder, python, python35, python-35, rh-python35

    * An image stream tag will be created as "blog-django-py:latest" that will track this image
    * This image will be deployed in deployment config "blog-django-py"
    * Port 8080/tcp will be load balanced by service "blog-django-py"
      * Other containers can access this service through the hostname "blog-django-py"

--> Creating resources ...
    imagestream.image.openshift.io "blog-django-py" created
    deploymentconfig.apps.openshift.io "blog-django-py" created
    service "blog-django-py" created
--> Success
    Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
     'oc expose svc/blog-django-py'
    Run 'oc status' to view your app.
```

OpenShift will assign a default name based on the name of the image, in this case ``blog-django-py``. You can specify a different name to be given to the application, and the resources created, by supplying the ``--name`` option along with the name you wish to use as an argument.

Unlike how it is possible when deploying an existing container image from the web console, the application is not exposed outside of the OpenShift cluster by default. To expose the application created so it is available outside of the OpenShift cluster, you can run the command:

``oc expose service/blog-django-py``{{execute}}

Switch to the OpenShift web console by selecting on _Console_ to verify that the application has been deployed. Select on the URL shortcut icon displayed for the application on the _Topology_ view for the project to visit the application.

Alternatively, to view the hostname assigned to the route created from the command line, you can run the command:

``oc get route/blog-django-py``{{execute}}
