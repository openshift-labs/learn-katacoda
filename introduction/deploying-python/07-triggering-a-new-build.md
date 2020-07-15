The source code for an application isn't going to be static, so a way to trigger a new build after making any changes is required.

To do this from the command line using ``oc``, run the command:

``oc start-build blog-django-py``{{execute}}

This should display:

```
build.build.openshift.io/blog-django-py-2 started
```

A new build could also have been triggered from the web console by finding the build configuration for the application under the _Builds_ menu, selecting the kebab menu on the right side of the entry, and clicking on _Start Build_.

As before you can use ``oc logs`` to monitor the log output as the build runs. You can also monitor the progress of any builds in a project by running the command:

``oc get builds --watch``{{execute}}

As the build progresses, this should display output similar to:

```
NAME                TYPE      FROM          STATUS     STARTED         DURATION
blog-django-py-1    Source    Git@fcdc38c   Complete   2 minutes ago   1m2s
blog-django-py-2    Source    Git@fcdc38c   Running    3 seconds ago   3s
blog-django-py-2    Source    Git@fcdc38c   Complete   About a minute ago   1m9s
```

To exit the command type _CTRL-C_ in the terminal window.

To display information about the build configuration for the application you can run:

``oc describe bc/blog-django-py``{{execute}}

This will display output similar to:

```
Name:           blog-django-py
Namespace:      myproject
Created:        8 minutes ago
Labels:         app=blog-django-py
Annotations:    openshift.io/generated-by=OpenShiftNewApp
Latest Version: 2

Strategy:       Source
URL:            https://github.com/openshift-katacoda/blog-django-py
From Image:     ImageStreamTag openshift/python:latest
Output to:      ImageStreamTag blog-django-py:latest

Build Run Policy:       Serial
Triggered by:           Config, ImageChange
Webhook GitHub:
        URL:    https://openshift:6443/apis/build.openshift.io/v1/namespaces/myproject/buildconfigs/blog-django-py/webhooks/<secret>/github
Webhook Generic:
        URL:            https://openshift:6443/apis/build.openshift.io/v1/namespaces/myproject/buildconfigs/blog-django-py/webhooks/<secret>/generic
        AllowEnv:       false
Builds History Limit:
        Successful:     5
        Failed:         5

Build                   Status          Duration        Creation Time
blog-django-py-2        complete        1m28s           2019-11-05 05:19:32 +0000 UTC
blog-django-py-1        complete        1m31s           2019-11-05 05:13:21 +0000 UTC

Events: <none>
```

You can see details of the Git repository being used as the source for any build.

You will also see listed webhook URLs that can be configured into a Git hosting service to trigger a new build automatically when changes are committed and pushed up to a Git repository. As you are using a Git repository on GitHub that you don't own this can not be done for this exercise, but if you had forked the Git repository into your own account, or this was your own application, it could have been configured.

The typical workflow followed when developing an application, is to work on your application source code on your own local machine. When you are happy with changes and they are ready to be made live, commit the changes and push them up to the hosted Git repository linked to the build configuration. If a webhook has been configured, a new build and deployment would be triggered automatically, otherwise you can trigger a new build manually.

In the case of where you are rapidly iterating on changes to test ideas and don't want to have to commit every change and push it back up to the hosted Git repository, you can use what is called a binary input build.

To demonstrate this, clone the Git repository for the application by running:

``git clone https://github.com/openshift-katacoda/blog-django-py``{{execute}}

This will create a sub directory ``blog-django-py`` containing the source code for the application:

```
Cloning into 'blog-django-py'...
remote: Enumerating objects: 3, done.
remote: Counting objects: 100% (3/3), done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 412 (delta 0), reused 0 (delta 0), pack-reused 409
Receiving objects: 100% (412/412), 68.49 KiB | 556.00 KiB/s, done.
Resolving deltas: 100% (200/200), done.
```

Change into the sub directory.

``cd blog-django-py``{{execute}}

To show how a build can be triggered from the local copy of the application source code, without needing to commit changes back to the Git repository, first run the command:

``echo 'BLOG_BANNER_COLOR=blue' >> .s2i/environment``{{execute}}

This command will update an environment variable setting file used by S2I to determine what environment variables are baked into the application image created.

Start a new build by running the command:

``oc start-build blog-django-py --from-dir=. --wait``{{execute}}

This is similar to what you ran before, with the exception that the option ``--from-dir=.`` is also passed to the command, indicating that source code should be uploaded from the directory on the host where you are running the command, rather than it being pulled down from the hosted Git repository.

The output from running the command should start with:

```
Uploading directory "." as binary input for the build ...
```

indicating that the source code is being uploaded.

The ``--wait`` option is also supplied to indicate that the command should only return when the build has completed. This option can be useful if integrating it into a script and you need to ensure the build has completed before running a subsequent command.

While the build command is running and the application is being deployed, switch to the web console to monitor progress. You can find the details for the current build by selecting _Builds_ from the left hand side menu, selecting on the build configuration for ``blog-django-py``, selecting the _Builds_ tab and then clicking on ``blog-django-py-3``.

Once the build and deployment is finished, if you visit the web application once more, you will see that the banner colour has been changed to blue.

![Blog Web Site](../../assets/introduction/deploying-python-44/07-blog-web-site-blue.png)

When you use the ``--from-dir=.`` option with ``oc start-build``, the contents from the current working directory will only be used for that one build. If you wanted to run further builds with source code from your local directory, you would need to supply ``--from-dir=.`` each time.

To return back to using the source code from the hosted Git repository, run:


``oc start-build blog-django-py``{{execute}}

This should output:

```
build.build.openshift.io/blog-django-py-4 started
```

If for some reason a build was wrongly started, or you realised it would fail anyway, you can cancel the build by running ``oc cancel-build`` and supplying the name of the build.

``oc cancel-build blog-django-py-4``{{execute}}

This should show the build has been cancelled.

```
build.build.openshift.io/blog-django-py-4 marked for cancellation, waiting to be cancelled
build.build.openshift.io/blog-django-py-4 cancelled
```

You can confirm this by also looking at the list of all builds run.

``oc get builds``{{execute}}

This should display output similar to:

```
NAME               TYPE     FROM             STATUS                       STARTED          DURATION
blog-django-py-1   Source   Git@35b89e2      Complete                     15 minutes ago   1m31s
blog-django-py-2   Source   Git@35b89e2      Complete                     8 minutes ago    1m28s
blog-django-py-3   Source   Binary@35b89e2   Complete                     3 minutes ago    1m28s
blog-django-py-4   Source   Git@35b89e2      Cancelled (CancelledBuild)   31 seconds ago   23s
```

Note that starting a build using source code from a local directory on your own machine can only be done from the command line. There is no way to trigger such a build from the web console.
