When using a database with your front end web application, you will need to configure the web application to know about the database. We are going to skip that in this course and look at just how you would connect to the database using an admin tool from your own local machine.

In order to know where the database is running that we wish to connect to, run the command:

``oc get pods --selector app=database``{{execute}}

This will output the details of the pod which is running the database.

```
NAME               READY     STATUS    RESTARTS   AGE
database-1-9xv8n   1/1       Running   0          1m
```

To make it easier to interact with the pod, capture the name of the pod in an environment variable by running.

``POD=`oc get pods --selector app=database -o custom-columns=name:.metadata.name --no-headers`; echo $POD``{{execute}}

You can create an interactive shell within the same container running the database using the ``oc rsh`` command, supplying it the name of the pod.

``oc rsh $POD``{{execute}}

``psql sampledb username``{{execute}}

``\q``{{execute}}

``exit``{{execute}}

``oc port-forward $POD 5432:5432 &``{{execute}}

``jobs``{{execute}}

``psql sampledb username --host=127.0.0.1 --port=5432``{{execute}}

``\q``{{execute}}

``kill %1``{{execute}}



-----

Option 1.

``POD=`oc get pods --selector app=dbname -o name | sed -e 's%pod/%%'```{{execute HOST1}}

``oc port-forward $POD 5432:5432``{{execute HOST1}}

``psql dbname dbuser --host=127.0.0.1 --port=5432``{{execute HOST2}}

Option 2.

``oc port-forward `oc get pods --selector app=dbname -o name | sed -e 's%pod/%%'` 5432:5432 &``{{execute HOST1}}

``psql dbname dbuser --host=127.0.0.1 --port=5432``{{execute HOST1}}

Option 3.

