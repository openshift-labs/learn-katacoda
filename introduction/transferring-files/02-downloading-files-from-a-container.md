To demonstrate transferring files to and from a running container we first need to deploy an application. To do this run the command:

``oc new-app openshiftkatacoda/blog-django-py --name blog``{{execute}}

So that we can access it from a web browser, we also need to expose it by creating a _Route_.

``oc expose service/blog``{{execute}}

To monitor the deployment of the application run:

``oc rollout status deployment/blog``{{execute}}

The command will exit once the deployment has completed and the web application is ready.

The result of the deployment will be the running container. You can see the name of the pods corresponding to the running containers for this application, by running:

``oc get pods --selector deployment=blog``{{execute}}

You only have one instance of the application so only one pod will be listed, similar to:

```
NAME                    READY   STATUS    RESTARTS   AGE
blog-5dc99d7545-rkvzt   1/1     Running   0          1m12s
```

For subsequent commands which need to interact with that pod, you will need to use the name of the pod, as an argument.

To make it easier to reference the name of the pod in these instructions, we define here a shell function to capture the name so it can be stored in an environment variable. That environment variable will then be used in the commands you run.

The command we will run from the shell function to get out just the name of the pod will be:

``oc get pods --selector deployment=blog -o jsonpath='{.items[?(@.status.phase=="Running")].metadata.name}'``{{execute}}

As above this uses ``oc get pods`` with a label selector, but we also use a ``jsonpath`` query to extract the name of the running pod.

To create the shell function run:

``pod() { local selector=$1; local query='?(@.status.phase=="Running")'; oc get pods --selector $selector -o jsonpath="{.items[$query].metadata.name}"; }``{{execute}}

To capture the name of the pod for this application in the ``POD`` environment variable, run:

``POD=`pod deployment=blog`; echo $POD``{{execute}}

To create an interactive shell within the same container running the application, you can use the ``oc rsh`` command, supplying it the environment variable holding the name of the pod.

``oc rsh $POD``{{execute}}

From within the interactive shell, see what files exist in the application directory.

``ls -las``{{execute}}

This will yield output similar to:

```
total 80
 0 drwxrwxr-x. 1 default    root    52 Oct 24 02:51 .
 0 drwxrwxr-x. 1 default    root    28 Jun 18 02:10 ..
 4 -rwxrwxr-x. 1 default    root  1454 Jun 18 02:07 app.sh
 0 drwxrwxr-x. 1 default    root    43 Jun 18 02:11 blog
 0 drwxrwxr-x. 2 default    root    25 Jun 18 02:07 configs
 4 -rw-rw-r--. 1 default    root   230 Jun 18 02:07 cronjobs.py
44 -rw-r--r--. 1 1000520000 root 44032 Oct 24 02:51 db.sqlite3
 4 -rw-rw-r--. 1 default    root   430 Jun 18 02:07 Dockerfile
 0 drwxrwxr-x. 2 default    root    25 Jun 18 02:07 htdocs
 0 drwxrwxr-x. 1 default    root    25 Jun 18 02:11 katacoda
 4 -rwxrwxr-x. 1 default    root   806 Jun 18 02:07 manage.py
 0 drwxrwxr-x. 3 default    root    20 Jun 18 02:11 media
 0 drwxrwxr-x. 1 default    root    19 Apr  3  2019 .pki
 4 -rw-rw-r--. 1 default    root   832 Jun 18 02:07 posts.json
 8 -rw-rw-r--. 1 default    root  7861 Jun 18 02:07 README.md
 4 -rw-rw-r--. 1 default    root   203 Jun 18 02:07 requirements.txt
 4 -rw-rw----. 1 default    root  1024 Apr  3  2019 .rnd
 0 drwxrwxr-x. 4 default    root    57 Jun 18 02:09 .s2i
 0 drwxrwxr-x. 4 default    root    30 Jun 18 02:11 static
 0 drwxrwxr-x. 2 default    root   148 Jun 18 02:07 templates
```

For the application being used, this has created a database file:

```
44 -rw-r--r--. 1 1000520000 root 44032 Oct 24 02:51 db.sqlite3
```

Lets look at how this database file can be copied back to the local machine.

To confirm what directory the file is located in, inside of the container, run:

``pwd``{{execute}}

This should display:

```
/opt/app-root/src
```

To exit the interactive shell and return to the local machine run:

``exit``{{execute}}

To copy files from the container to the local machine the ``oc rsync`` command can be used.

The form of the command when copying a single file from the container to the local machine is:

```
oc rsync <pod-name>:/remote/dir/filename ./local/dir
```

To copy the single database file run:

``oc rsync $POD:/opt/app-root/src/db.sqlite3 .``{{execute}}

This should display output similar to:

```
receiving incremental file list
db.sqlite3

sent 43 bytes  received 44,129 bytes  88,344.00 bytes/sec
total size is 44,032  speedup is 1.00
```

Check the contents of the current directory by running:

``ls -las``{{execute}}

and you should see that the local machine now has a copy of the file.

```
44 -rw-r--r--  1 root root 44032 Oct 24 04:15 db.sqlite3
```

Note that the local directory into which you want the file copied must exist. If you didn't want to copy it into the current directory, ensure the target directory has been created beforehand.

In addition to copying a single file, a directory can also be copied. The form of the command when copying a directory to the local machine is:

```
oc rsync <pod-name>:/remote/dir ./local/dir
```

To copy the ``media`` directory from the container, run:

``oc rsync $POD:/opt/app-root/src/media .``{{execute}}

If you wanted to rename the directory when it is being copied, you should create the target directory with the name you want to use first.

``mkdir uploads``{{execute}}

and then to copy the files use the command:

``oc rsync $POD:/opt/app-root/src/media/. uploads``{{execute}}

To ensure only the contents of the directory on the container are copied, and not the directory itself, the remote directory is suffixed with ``/.``.

Note that if the target directory contains existing files with the same name as a file in the container, the local file will be overwritten. If there are additional files in the target directory which don't exist in the container, those files will be left as is. If you did want an exact copy, where the target directory was always updated to be exactly the same as what exists in the container, use the ``--delete`` option to ``oc rsync``.

When copying a directory, you can be more selective about what is copied by using the ``--exclude`` and ``--include`` options to specify patterns to be matched against directories and files, with them being excluded or included as appropriate.

If there is more than one container running within a pod, you will need to specify which container you want to work with by using the ``--container`` option.