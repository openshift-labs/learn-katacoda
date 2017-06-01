The source code for an application isn't going to be static, so a way to trigger a new build after making any changes is required.

To do this from the command line using ``oc``, run the command:

``oc new-build blog``{{execute}}

This should display output similar to:

```
build "blog-2" started
```

A new build could also have been triggered from the web console by going to the build configuration for the application and clicking on _Start Build_.

As before you can use ``oc logs`` to monitor the log output as the build runs. You can also monitor the progress of any builds in a project by running the command:

``oc get builds --watch``{{execute}}

As the build progress, this should display output similar to:

```
NAME      TYPE      FROM          STATUS     STARTED         DURATION
blog-1    Source    Git@fcdc38c   Complete   2 minutes ago   1m2s
blog-2    Source    Git           Running    1 seconds ago   1s
NAME      TYPE      FROM          STATUS    STARTED         DURATION
blog-2    Source    Git@fcdc38c   Running   3 seconds ago   3s
blog-2    Source    Git@fcdc38c   Complete   About a minute ago   1m9s
```

To exit the command when the build has completed, type _CTRL-C_ in the terminal window.

To display information about the build configuration for the application you can run:

``oc describe bc/blog``{{execute}}

This will display output similar to:

```
Name:           blog
Namespace:      myproject
Created:        5 minutes ago
Labels:         app=blog
Annotations:    openshift.io/generated-by=OpenShiftNewApp
Latest Version: 2

Strategy:       Source
URL:            https://github.com/openshift-katacoda/blog-django-py
From Image:     ImageStreamTag openshift/python:latest
Output to:      ImageStreamTag blog:latest

Build Run Policy:       Serial
Triggered by:           Config, ImageChange
Webhook GitHub:
        URL:    https://172.17.0.18:8443/oapi/v1/namespaces/myproject/buildconfigs/blog/webhooks/wrmDd4vYVA9J0NWB0Eaw/github
Webhook Generic:
        URL:            https://172.17.0.18:8443/oapi/v1/namespaces/myproject/buildconfigs/blog/webhooks/TjJ9AP7__NbNVaqC7vIk/generic
        AllowEnv:       false

Build   Status          Duration        Creation Time
blog-2  complete        1m9s            2017-06-01 02:07:15 +0000 UTC
blog-1  complete        1m2s            2017-06-01 02:05:11 +0000 UTC

No events.
```

You can see how details of the Git repository being used as the source for any build.

You will also see listed a _Webhook URL_ that can be configured into a Git hosting service to trigger a new build automatically when changes are committed and pushed up to a Git repository. As you are using a Git repository on GitHub that you don't own this can not be done for this exercise, but if you had forked the Git repository into your own account, or this was your own application, it could have been configured.

The typical workflow followed when developing an application, is to work on your application source code on your own local machine. When you are happy with changes and they are ready to be made live, commit the changes and push them up to the hosted Git repository linked to the build configuration. If a webhook has been configured, a new build and deployment would be triggered automatically, otherwise you can trigger a new build manually.

``git clone https://github.com/openshift-katacoda/blog-django-py``{{execute}}

```
Cloning into 'blog-django-py'...
remote: Counting objects: 125, done.
remote: Total 125 (delta 0), reused 0 (delta 0), pack-reused 125
Receiving objects: 100% (125/125), 22.59 KiB | 0 bytes/s, done.
Resolving deltas: 100% (45/45), done.
```

``cd blog-django-py``{{execute}}

``echo 'BLOG_BANNER_COLOR=blue' >> .s2i/environment``{{execute}}

``oc start-build blog --from-dir=.``{{execute}}

```
Uploading directory "." as binary input for the build ...
build "blog-3" started
```

``oc get pods --watch``{{execute}}

![Blog Web Site](../../assets/intro-openshift/deploying-python/07-blog-web-site-blue.png)


``oc start-build blog``{{execute}}



