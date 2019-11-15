The source code for an application isn't going to be static, so a way to trigger a new build after making any changes is required.

To do this from the command line using ``oc``, run the command:

``oc start-build blog``{{execute}}

This should display:

```
build "blog-2" started
```

A new build could also have been triggered from the web console by going to the build configuration for the application and clicking on _Start Build_.

As before you can use ``oc logs`` to monitor the log output as the build runs. You can also monitor the progress of any builds in a project by running the command:

``oc get builds --watch``{{execute}}

As the build progresses, this should display output similar to:

```
NAME      TYPE      FROM          STATUS     STARTED         DURATION
blog-1    Source    Git@fcdc38c   Complete   2 minutes ago   1m2s
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

...
```

You can see details of the Git repository being used as the source for any build.

You will also see listed a _Webhook URL_ that can be configured into a Git hosting service to trigger a new build automatically when changes are committed and pushed up to a Git repository. As you are using a Git repository on GitHub that you don't own this can not be done for this exercise, but if you had forked the Git repository into your own account, or this was your own application, it could have been configured.

The typical workflow followed when developing an application, is to work on your application source code on your own local machine. When you are happy with changes and they are ready to be made live, commit the changes and push them up to the hosted Git repository linked to the build configuration. If a webhook has been configured, a new build and deployment would be triggered automatically, otherwise you can trigger a new build manually.

In the case of where you are rapidly iterating on changes to test ideas and don't want to have to commit every change and push it back up to the hosted Git repository, you can use what is called a binary input build.

To demonstrate this, clone the Git repository for the application by running:

``git clone https://github.com/openshift-katacoda/blog-django-py``{{execute}}

This will create a sub directory ``blog-django-py`` containing the source code for the application:

```
Cloning into 'blog-django-py'...
remote: Counting objects: 125, done.
remote: Total 125 (delta 0), reused 0 (delta 0), pack-reused 125
Receiving objects: 100% (125/125), 22.59 KiB | 0 bytes/s, done.
Resolving deltas: 100% (45/45), done.
```

Change into the sub directory.

``cd blog-django-py``{{execute}}

To show how a build can be triggered from the local copy of the application source code, without needing to commit changes back to the Git repository, first run the command:

``echo 'BLOG_BANNER_COLOR=blue' >> .s2i/environment``{{execute}}

This command will update an environment variable setting file used by S2I to determine what environment variables are baked into the application image created.

Start a new build by running the command:

``oc start-build blog --from-dir=. --wait``{{execute}}

This is similar to what you ran before, with the exception that the option ``--from-dir=.`` is also passed to the command, indicating that source code should be uploaded from the directory on the host where you are running the command, rather than it being pulled down from the hosted Git repository.

The output from running the command should start with:

```
Uploading directory "." as binary input for the build ...
```

indicating that the source code is being uploaded.

The ``--wait`` option is also supplied to indicate that the command should only return when the build has completed. This option can be useful if integrating it into a script and you need to ensure the build has completed before running a subsequent command.

While the build command is running and the application is being deployed, switch to the web console to monitor progress.

Once the build and deployment is finished, if you visit the web application once more, you will see that the banner colour has been changed to blue.

![Blog Web Site](../../assets/introduction/deploying-python-36/07-blog-web-site-blue.png)

When you use the ``--from-dir=.`` option with ``oc start-build``, the contents from the current working directory will only be used for that one build. If you wanted to run further builds with source code from your local directory, you would need to supply ``--from-dir=.`` each time.

To return back to using the source code from the hosted Git repository, run:


``oc start-build blog``{{execute}}

This should output:

```
build "blog-4" started
```

If for some reason a build was wrongly started, or you realised it would fail anyway, you can cancel the build by running ``oc cancel-build`` and supplying the name of the build.

``oc cancel-build blog-4``{{execute}}

This should show the build has been cancelled.

```
build "blog-4" cancelled
```

You can confirm this by also looking at the list of all builds run.

``oc get builds``{{execute}}

This should display output similar to:

```
NAME      TYPE      FROM             STATUS      STARTED          DURATION
blog-1    Source    Git@fcdc38c      Complete    12 minutes ago   2m36s
blog-2    Source    Git@fcdc38c      Complete    8 minutes ago    1m9s
blog-3    Source    Binary@fcdc38c   Complete    6 minutes ago    1m10s
blog-4    Source    Git@fcdc38c      Cancelled   18 seconds ago   10s
```

Note that starting a build using source code from a local directory on your own machine can only be done from the command line. There is no way to trigger such a build from the web console.
