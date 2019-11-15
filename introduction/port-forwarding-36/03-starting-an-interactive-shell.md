In order to know where the database is running to connect to, run the command:

``oc get pods --selector app=database``{{execute}}

This will output the details of the pod which is running the database.

```
NAME               READY     STATUS    RESTARTS   AGE
database-1-9xv8n   1/1       Running   0          1m
```

To make it easier to reference the name of the pod, capture the name of the pod in an environment variable by running:

``POD=`oc get pods --selector app=database -o custom-columns=name:.metadata.name --no-headers`; echo $POD``{{execute}}

To create an interactive shell within the same container running the database, you can use the ``oc rsh`` command, supplying it the name of the pod.

``oc rsh $POD``{{execute}}

You could also access an interactive terminal session via a web browser by visiting the pod details from the web console.

You can see that you are in the container running the database by running:

``ps x``{{execute}}

This will display output similar to:

```
  PID TTY      STAT   TIME COMMAND
    1 ?        Ss     0:00 postgres
   71 ?        Ss     0:00 postgres: logger process
   73 ?        Ss     0:00 postgres: checkpointer process
   74 ?        Ss     0:00 postgres: writer process
   75 ?        Ss     0:00 postgres: wal writer process
   76 ?        Ss     0:00 postgres: autovacuum launcher process
   77 ?        Ss     0:00 postgres: stats collector process
  940 ?        Ss     0:00 /bin/sh
  957 ?        R+     0:00 ps x
```

Because you are in the same container, you could at this point run the database client for the database if provided in the container. For PostgreSQL, you would use the ``psql`` command.

``psql sampledb username``{{execute}}

This will present you with the prompt for running database operations via ``psql``.

```
psql (9.5.4)
Type "help" for help.

sampledb=>
```

You could now dynamically create database tables, add data, or modify existing data.

To exit ``psql`` enter:

``\q``{{execute}}

To exit the interactive shell run:

``exit``{{execute}}

Anything you want to do to the database could be be done through any database admin tool included in the container. This will though be limited to console based tools and you would not be able to use a GUI based tool which runs from your local machine as the database is still not exposed outside of the OpenShift cluster at this point.

If you need to run database script files to perform operations on the database, you would also need to first copy those files into the database container using the ``oc rsync`` command.