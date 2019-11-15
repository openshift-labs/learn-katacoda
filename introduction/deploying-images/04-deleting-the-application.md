Instead of deploying the existing container image from the web console, you can use the command line. Before we do that, lets delete the application we have already deployed.

To do this from the web console you could visit each resource type created and delete them one at a time. The simpler way to delete an application is from the command line using the ``oc`` program.

To see a list of all the resources that have been created in the project so far, you can run the command:

``oc get all -o name``{{execute}}

This will display output similar to:

```
pod/blog-django-py-1-cbp96
pod/blog-django-py-1-deploy
replicationcontroller/blog-django-py-1
service/blog-django-py
deploymentconfig.apps.openshift.io/blog-django-py
imagestream.image.openshift.io/blog-django-py
route.route.openshift.io/blog-django-py
```

You have only created one application, so you would know that all the resources listed will relate to it. When you have multiple applications deployed, you need to identify those which are specific to the application you may want to delete. You can do this by applying a command to a subset of resources using a label selector.

To determine what labels may have been added to the resources, select one and display the details on it. To look at the _Route_ which was created, you can run the command:

``oc describe route/blog-django-py``{{execute}}

This should display output similar to:

```
Name:                   blog-django-py
Namespace:              myproject
Created:                2 minutes ago
Labels:                 app=blog-django-py
                        app.kubernetes.io/component=blog-django-py
                        app.kubernetes.io/instance=blog-django-py
                        app.kubernetes.io/part-of=blog-django-py-app
Annotations:            openshift.io/generated-by=OpenShiftWebConsole
                        openshift.io/host.generated=true
Requested Host:         blog-django-py-myproject.2886795274-80-frugo03.environments.katacoda.com
                          exposed on router default (host apps-crc.testing) 2 minutes ago
Path:                   <none>
TLS Termination:        <none>
Insecure Policy:        <none>
Endpoint Port:          8080-tcp

Service:        blog-django-py
Weight:         100 (100%)
Endpoints:      10.128.0.205:8080
```

In this case when deploying the existing container image via the OpenShift web console, OpenShift has applied automatically to all resources the label ``app=blog-django-py``. You can confirm this by running the command:

``oc get all --selector app=blog-django-py -o name``{{execute}}

This should display the same list of resources as when ``oc get all -o name`` was run. To double check that this is doing what is being described, run instead:

``oc get all --selector app=blog -o name``{{execute}}

In this case, because there are no resources with the label ``app=blog``, the result will be empty.

Having a way of selecting just the resources for the one application, you can now schedule them for deletion by running the command:

``oc delete all --selector app=blog-django-py``{{execute}}

To confirm that the resources have been deleted, run again the command:

``oc get all -o name``{{execute}}

If you do still see any resources listed, keep running this command until it shows they have all been deleted. You can find that resources may not be deleted immediately as you only scheduled them for deletion and how quickly they can be deleted will depend on how quickly the application can be shutdown.

Although label selectors can be used to qualify what resources are to be queried, or deleted, do be aware that it may not always be the ``app`` label that you need to use. When an application is created from a template, the labels applied and their names are dictated by the template. As a result, a template may use a different labelling convention. Always use ``oc describe`` to verify what labels have been applied and use ``oc get all --selector`` to verify what resources are matched before deleting any resources.
