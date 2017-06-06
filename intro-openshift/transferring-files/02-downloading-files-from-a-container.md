To demonstrate transferring files to and from a running container we first need to deploy an application. To do this run the command:

``oc new-app openshiftkatacoda/blog-django-py --name blog``{{execute}}

So that we can access it from a web browser, we also need to expose it by creating a _Route_.

``oc expose svc/blog``{{execute}}

To monitor the deployment of the application run:

``oc rollout status dc/blog``{{execute}}

The command will exit once the deployment has completed and the web application is ready.

The result of the deployment will be the running container. You can see the list of _Pods_ for any running containers by running:

``oc get pods --selector app=blog``{{execute}}

You only have one instance of the application so only one pod will be listed, similar to:

```
NAME           READY     STATUS    RESTARTS   AGE
blog-1-9j3p3   1/1       Running   0          1m
```

To make it easier to reference the name of the pod, capture the name of the pod in an environment variable by running:

``POD=`oc get pods --selector app=blog -o custom-columns=name:.metadata.name --no-headers`; echo $POD``{{execute}}

To create an interactive shell within the same container running the database, you can use the ``oc rsh`` command, supplying it the name of the pod.

``oc rsh $POD``{{execute}}

From within the interactive shell, see what files exist in the application directory.

``ls -las``{{execute}}

This will yield output similar to:

```
total 80
 4 drwxrwxrwx 9 default    root  4096 Jun  6 05:53 .
 0 drwxrwxrwx 7 default    root    97 May 31 06:59 ..
 4 -rwxrwxr-x 1 default    root   107 May 31 06:54 app.sh
 4 drwxrwxr-x 6 default    root  4096 May 31 06:59 blog
40 -rw-r--r-- 1 1000040000 root 39936 Jun  6 05:53 db.sqlite3
 4 -rw-rw-r-- 1 default    root   430 May 31 06:54 Dockerfile
 0 drwxrwxr-x 3 default    root    88 May 31 06:59 katacoda
 4 -rwxrwxr-x 1 default    root   806 May 31 06:54 manage.py
 0 drwxrwxr-x 3 default    root    19 May 31 06:59 media
 0 drwxrwxrwx 3 default    root    18 May 26 12:32 .pki
 4 -rw-rw-r-- 1 default    root   832 May 31 06:54 posts.json
 8 -rw-rw-r-- 1 default    root  7126 May 31 06:54 README.md
 4 -rw-rw-r-- 1 default    root    65 May 31 06:54 requirements.txt
 4 -rw-rwxrwx 1 default    root  1024 May 29 14:28 .rnd
 0 drwxrwxr-x 3 default    root    43 May 31 06:56 .s2i
 0 drwxrwxr-x 2 default    root    88 May 31 06:54 scripts
 0 drwxrwxr-x 4 default    root    28 May 31 06:59 static
```

For the application being used, this has created a database file:

```
40 -rw-r--r-- 1 1000040000 root 39936 Jun  6 05:53 db.sqlite3
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

The form of the command when copying files from the container to the local machine is:

```
oc rsync <pod-name>:/remote/dir/ ./local/dir
```

To copy the single database file run:

``oc rsync $POD:/opt/app-root/src/db.sqlite3 ./``{{execute}}

This should display output similar to:

```
receiving incremental file list
db.sqlite3

sent 30 bytes  received 40027 bytes  26704.67 bytes/sec
total size is 39936  speedup is 1.00
```

Check the contents of the current directory by running:

``ls -las``{{execute}}

and you should see that the local machine now has a copy of the file.

```
40 -rw-rw-r--   1 1000040000 root 39936 Jun  6 05:53 db.sqlite3
```


