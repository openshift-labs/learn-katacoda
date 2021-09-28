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
remote: Enumerating objects: 3, done.
remote: Counting objects: 100% (3/3), done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 412 (delta 0), reused 0 (delta 0), pack-reused 409
Receiving objects: 100% (412/412), 68.49 KiB | 701.00 KiB/s, done.
Resolving deltas: 100% (200/200), done.
```

Now run the following command to have ``oc rsync`` perform live synchronisation of the code, copying any changes from the ``blog-django-py`` directory up to the container.

``oc rsync blog-django-py/. $POD:/opt/app-root/src --no-perms --watch &``{{execute}}

In this case we are running this as a background process as we only have the one terminal window available, you could run it as a foreground process in a separate terminal if doing this yourself.

You can see the details for the background process by running:

``jobs``{{execute}}

When you initially ran this ``oc rsync`` command, you will see that it copied up the files so the local and remote directory are synchronized. Any changes made to the local files will now be automatically copied up to the remote directory.

Before we make a change, bring up the web application we have deployed in a separate browser window by using the URL:

http://blog-myproject.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/

You should see that the color of the title banner for the web site is red.

![Blog Web Site Red](../../assets/introduction/transferring-files-42/04-blog-web-site-red.png)

Lets change that banner color by running the command:

``echo "BLOG_BANNER_COLOR = 'blue'" >> blog-django-py/blog/context_processors.py``{{execute}}

Wait to see that the changed file is uploaded, and then refresh the page for the web site.

Unfortunately you will see that the title banner is still red. This is because for Python any code changes are cached by the running process and it is necessary to restart the web server application processes.

For this deployment the WSGI server ``mod_wsgi-express`` is being used. To trigger a restart of the web server application processes, run:

``oc rsh $POD kill -HUP 1``{{execute}}

This command will have the affect of sending a HUP signal to process ID 1 running within the container, which is the instance of ``mod_wsgi-express`` which is running. This will trigger the required restart and reloading of the application, but without the web server actually exiting.

Refresh the page for the web site once more and the title banner should now be blue.

![Blog Web Site Blue](../../assets/introduction/transferring-files-42/04-blog-web-site-blue.png)

Note that the name of the pod as displayed in the title banner is unchanged, indicating that the pod was not restarted and only the web server application processes were restarted.

Manually forcing a restart of the web server application processes will get the job done, but a better way is if the web server can automatically detect code changes and trigger a restart.

In the case of ``mod_wsgi-express`` and how this web application has been configured, this can be enabled by setting an environment variable for the deployment. To set this environment variable run:

``oc set env deployment/blog MOD_WSGI_RELOAD_ON_CHANGES=1``{{execute}}

This command will update the deployment configuration, shutdown the existing pod and replace it with a new instance of our application with the environment variable now being passed through to the application.

Monitor the re-deployment of the application by running:

``oc rollout status deployment/blog``{{execute}}

Because the existing pod has been shutdown, we will need to capture again the new name for the pod.

``POD=`pod deployment=blog`; echo $POD``{{execute}}

You may also notice that the synchronization process we had running in the background may have stopped. This is because the pod it was connected to had been shutdown.

You can check this is the case by running:

``jobs``{{execute}}

If it is still showing as running, due to shutdown of the pod not yet having been detected, run the following command to kill it:

``kill -9 %1``{{execute}}

Ensure the background task has exited:

``jobs``{{execute}}

Now run the ``oc rsync`` command again, against the new pod.

``oc rsync blog-django-py/. $POD:/opt/app-root/src --no-perms --watch &``{{execute}}

Refresh the page for the web site again and the title banner should still be blue, but you will notice that the pod name displayed has changed.

Modify the code file once more, setting the color to green.

``echo "BLOG_BANNER_COLOR = 'green'" >> blog-django-py/blog/context_processors.py``{{execute}}

Refresh the web site page again, multiple times if need be, until the title banner shows as green. The change may not be immediate as the file synchronization may take a few moments, as may the detection of the code changes and restart of the web server application process.

![Blog Web Site Green](../../assets/introduction/transferring-files-42/04-blog-web-site-green.png)

Kill the synchronization task by running:

``kill -9 %1``{{execute}}

Although one can synchronize files from the local computer into a container in this way, whether you can use it as a mechanism for enabling live coding will depend on the programming language being used, and the web application stack being used. This was possible for Python when using ``mod_wsgi-express``, but may not be possible with other WSGI servers for Python, or other programming languages.

Do note that even for the case of Python, this can only be used where modifying code files. If you need to install additional Python packages, you would need to re-build the application from the original source code. This is because changes to packages required, which for Python is given in the ``requirements.txt`` file, isn't going to trigger the installation of that package when using this mechanism.
