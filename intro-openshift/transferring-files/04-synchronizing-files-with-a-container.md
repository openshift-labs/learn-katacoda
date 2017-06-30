In addition to being able to manually upload or download files when you choose to, the ``oc rsync`` command can also be set up to perform live synchronization of files between your local computer and the container.

That is, the file system of your local computer will be monitored for any changes made to files. When there is a change to a file, the changed file will be automatically copied up to the container.

This same process can also be run in the opposite direction if required, with changes made in the container being automatically copied back to your local computer.

An example of where it can be useful to have changes automatically copied from your local computer into the container is during the development of an application.

For scripted programming languages such as PHP, Python or Ruby, where no separate compilation phase is required, provided that the web server can be manually restarted without causing the container to exit, or if the web server always reloads code files which have been modified, you can perform live code development with your application running inside of OpenShift.

To demonstrate this ability, clone the Git repository for the web application which you have already deployed.

``git clone https://github.com/openshift-katacoda/blog-django-py``{{execute}}

This will create a sub directory ``blog-django-py`` containing the source code for the application:

```
Cloning into 'blog-django-py'...
remote: Counting objects: 125, done.
remote: Total 125 (delta 0), reused 0 (delta 0), pack-reused 125
Receiving objects: 100% (125/125), 22.59 KiB | 0 bytes/s, done.
Resolving deltas: 100% (45/45), done.
```

Now run the following command to have ``oc rsync`` to perform live synchronisation of the code, copy any changes from the ``blog-django-py`` directory up to the container.

``oc rsync blog-django-py $POD:/opt/app-root/src --no-perms --watch &``

In this case we are running this as a background process as we only have the one terminal window available, you could run it as a foreground process in a separate terminal if doing this yourself.

You can see the details for the background process by running:

``jobs``{{execute}}
