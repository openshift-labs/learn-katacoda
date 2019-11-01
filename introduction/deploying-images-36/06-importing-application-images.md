When you deploy an existing Docker-formatted container image which resides on an external image registry, the image will be pulled down and stored within the internal OpenShift image registry. The image will then be copied to any node in the OpenShift cluster where an instance of the application is run.

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
                        openshift.io/image.dockerRepositoryCheck=2017-03-20T02:51:09Z
Docker Pull Spec:       172.30.125.109:5000/myproject/blog-django-py
Image Lookup:           local=false
Unique Images:          1
Tags:                   1

latest
  tagged from openshiftkatacoda/blog-django-py

  * openshiftkatacoda/blog-django-py@sha256:43e78e610a3181a4b710f938598acaf43d511ab38c4e84a98e59f29dbdb62c62
      4 minutes ago
```

In the details of the image stream which was created, you will see that the label ``app=blog-django-py`` was applied, identifying the image as relating to this one deployment. Consequently, when the application was deleted by using a label selector with the same value, the image stream would also be deleted.

When you are deploying only a single instance of the application from the image, this is reasonable, but if you need to deploy multiple instances of an application from the same image, with different names, you should import the image as a separate step before attempting to deploy the image.

Once more, delete the application which was already deployed.

``oc delete all --selector app=blog-django-py``{{execute}}

Check that all the resource objects have been deleted by running:

``oc get all -o name``{{execute}}

Now import the existing Docker-formatted container image explicitly using the command:

``oc import-image openshiftkatacoda/blog-django-py --confirm``{{execute}}

This should yield the output:

```
The import completed successfully.

Name:                   blog-django-py
Namespace:              myproject
Created:                Less than a second ago
Labels:                 <none>
Annotations:            openshift.io/image.dockerRepositoryCheck=2017-03-20T03:20:35Z
Docker Pull Spec:       172.30.235.4:5000/myproject/blog-django-py
Image Lookup:           local=false
Unique Images:          1
Tags:                   1

latest
  tagged from openshiftkatacoda/blog-django-py

  * openshiftkatacoda/blog-django-py@sha256:43e78e610a3181a4b710f938598acaf43d511ab38c4e84a98e59f29dbdb62c62
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
--> Found image d29f1bb (2 days old) in image stream "myproject/blog-django-py" under tag "latest" for "blog-django-py"

    Python 3.5
    ----------
    ...

    Tags: builder, python, python35, rh-python35

    * This image will be deployed in deployment config "blog-1"
    * Port 8080/tcp will be load balanced by service "blog-1"
      * Other containers can access this service through the hostname "blog-1"

--> Creating resources ...
    deploymentconfig "blog-1" created
    service "blog-1" created
--> Success
    Run 'oc status' to view your app.
```

Jump back to the OpenShift web console, click on _Add to project_ in the menu bar, then click on _Deploy Image_.

This time select _Image Stream Tag_ and from the drop down menus select the project ``myproject``, and the image stream ``blog-django-py`` with tag ``latest``.

![Deploy Image Stream Tag](../../assets/introduction/deploying-images-36/06-deploy-image-stream-tag.png)

Change the _Name_ to be used for the deployed application to ``blog-2``. Click on _Create_ at the bottom of the page to start the deployment.

From the command line, list all the resources which have been created.

``oc get all -o name``{{execute}}

This should yield output similar to:

```
imagestreams/blog-django-py
deploymentconfigs/blog-1
deploymentconfigs/blog-2
replicationcontrollers/blog-1-1
replicationcontrollers/blog-2-1
services/blog-1
services/blog-2
pods/blog-1-1-mzpbf
pods/blog-2-1-d2snt
```

You will see a deployment config, replication controller, service and pod for each instance of the application. Only the one image stream exists corresponding to the initial image import that was run.

Delete each application by running:

``oc delete all --selector app=blog-1``{{execute}}

``oc delete all --selector app=blog-2``{{execute}}

When the resource objects for each instance of the application have been deleted, you should be left with just the image stream object.

``oc get all -o name``{{execute}}

Importing the existing Docker-formatted container image before hand, therefore means that it is retained when any application instance using it is deleted.
