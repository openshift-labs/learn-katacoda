When you deploy an existing container image which resides on an external image registry, the image will be pulled down and stored within the internal OpenShift image registry. The image will then be copied to any node in the OpenShift cluster where an instance of the application is run.

In order to track the image that is pulled down, an _Image Stream_ resource will be created. You can list what image stream resources have been created within a project by running the command:

``oc get imagestream -o name``{{execute}}

This should yield the output:

```
imagestream/blog-django-py
```

To show further details about the image stream resource, run the command:

``oc describe imagestream/blog-django-py``{{execute}}

This should yield output similar to:

```
Name:                   blog-django-py
Namespace:              myproject
Created:                4 minutes ago
Labels:                 app=blog-django-py
Annotations:            openshift.io/generated-by=OpenShiftNewApp
                        openshift.io/image.dockerRepositoryCheck=2019-11-01T03:39:18Z
Image Repository:       default-route-openshift-image-registry.apps-crc.testing/myproject/blog-django-py
Image Lookup:           local=false
Unique Images:          1
Tags:                   1

latest
  tagged from openshiftkatacoda/blog-django-py

  * openshiftkatacoda/blog-django-py@sha256:ec0149d51aac5db76abba4df956021c8d0f58b0e153160bd6b1eb8e967830bb5
      3 minutes ago
```

In the details of the image stream which was created, you will see that the label ``app=blog-django-py`` was applied, identifying the image as relating to this one deployment. Consequently, when the application was deleted by using a label selector with the same value, the image stream would also be deleted.

When you are deploying only a single instance of the application from the image, this is reasonable, but if you need to deploy multiple instances of an application from the same image, with different names, you should import the image as a separate step before attempting to deploy the image.

Once more, delete the application which was already deployed.

``oc delete all --selector app=blog-django-py``{{execute}}

Check that all the resource objects have been deleted by running:

``oc get all -o name``{{execute}}

Now import the existing container image explicitly using the command:

``oc import-image openshiftkatacoda/blog-django-py --confirm``{{execute}}

This should yield the output:

```
imagestream.image.openshift.io/blog-django-py imported

Name:                   blog-django-py
Namespace:              myproject
Created:                Less than a second ago
Labels:                 <none>
Annotations:            openshift.io/image.dockerRepositoryCheck=2019-11-01T03:44:32Z
Image Repository:       image-registry.openshift-image-registry.svc:5000/myproject/blog-django-py
Image Lookup:           local=false
Unique Images:          1
Tags:                   1

latest
  tagged from openshiftkatacoda/blog-django-py

  * openshiftkatacoda/blog-django-py@sha256:ec0149d51aac5db76abba4df956021c8d0f58b0e153160bd6b1eb8e967830bb5
      Less than a second ago

...
```

This is the details of the image stream created.

Of note, no labels have been applied this time.

Verify that only the image stream has been created, and no other resource objects:

``oc get all -o name``{{execute}}

To deploy an instance of the application from the image stream which has been created, run the command:

``oc new-app blog-django-py --name blog-1``{{execute}}

This is using the image stream name, not the full name which identifies the image as being on the Docker Hub Registry.

This should yield output similar to:

```
--> Found image 927f823 (4 months old) in image stream "myproject/blog-django-py" under tag "latest" for "blog-django-py"

    Python 3.5
    ----------
    Python 3.5 available as container is a base platform for building and running various Python 3.5 applications and frameworks. Python is an easy to learn, powerful programming language. It has efficient high-level data structures and a simple but effective approach to object-oriented programming. Python's elegant syntax and dynamic typing, together with its interpreted nature, make it an ideal language for scripting and rapid application development in many areas on most platforms.

    Tags: builder, python, python35, python-35, rh-python35

    * This image will be deployed in deployment config "blog-1"
    * Port 8080/tcp will be load balanced by service "blog-1"
      * Other containers can access this service through the hostname "blog-1"

--> Creating resources ...
    imagestreamtag.image.openshift.io "blog-1:latest" created
    deploymentconfig.apps.openshift.io "blog-1" created
    service "blog-1" created
--> Success
    Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
     'oc expose svc/blog-1'
    Run 'oc status' to view your app.
```

Deploy a second instance of the container image by running:

``oc new-app blog-django-py --name blog-2``{{execute}}

List all the resources which have been created.

``oc get all -o name``{{execute}}

This should yield output similar to:

```
pod/blog-1-1-d8p9n
pod/blog-1-1-deploy
pod/blog-2-1-deploy
replicationcontroller/blog-1-1
replicationcontroller/blog-2-1
service/blog-1
service/blog-2
deploymentconfig.apps.openshift.io/blog-1
deploymentconfig.apps.openshift.io/blog-2
imagestream.image.openshift.io/blog-1
imagestream.image.openshift.io/blog-2
imagestream.image.openshift.io/blog-django-py
```

You will see a deployment config, replication controller, service and pod for each instance of the application. Only the one image stream exists corresponding to the initial image import that was run.

Delete each application by running:

``oc delete all --selector app=blog-1``{{execute}}

``oc delete all --selector app=blog-2``{{execute}}

When the resource objects for each instance of the application have been deleted, you should be left with just the image stream object.

``oc get all -o name``{{execute}}

Importing the existing Docker-formatted container image before hand, therefore means that it is retained when any application instance using it is deleted.
