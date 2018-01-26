``intro-jberet`` app uses PostgreSQL database for storing output data. 
To create a database which you can then connect to, run the command:

``oc new-app postgresql-ephemeral --name postgresql --param POSTGRESQL_USER=jberet --param POSTGRESQL_PASSWORD=jberet``{{execute}}

This will start up an instance of a PostgreSQL database, with the following info:

```text
--> Deploying template "openshift/postgresql-ephemeral" to project jberet-lab

     PostgreSQL (Ephemeral)
     ---------
     PostgreSQL database service, without persistent storage. For more information about using this template, including OpenShift considerations, see https://github.com/sclorg/postgresql-container/blob/master/9.5.

     WARNING: Any data stored will be lost upon pod destruction. Only use this template for testing

     The following service(s) have been created in your project: postgresql.

            Username: jberet
            Password: jberet
       Database Name: sampledb
      Connection URL: postgresql://postgresql:5432/

     For more information about using this template, including OpenShift considerations, see https://github.com/sclorg/postgresql-container/blob/master/9.5.

     * With parameters:
        * Memory Limit=512Mi
        * Namespace=openshift
        * Database Service Name=postgresql
        * PostgreSQL Connection Username=jberet
        * PostgreSQL Connection Password=jberet
        * PostgreSQL Database Name=sampledb
        * Version of PostgreSQL Image=9.5

--> Creating resources ...
    secret "postgresql" created
    service "postgresql" created
    deploymentconfig "postgresql" created
--> Success
    Run 'oc status' to view your app.
```

Although a database would normally be paired with a persistent volume, we only want to demonstrate how to access the database in this course. The database instance we create here, will therefore only store the database in the filesystem local to the container. This means that if the database was restarted, any changes would be lost. When you deploy a database to be used with your own applications, you would want to look at using persistent volumes.

To monitor progress as the database is deployed and made ready, run the command:

``oc rollout status dc/postgresql``{{execute}}

This command will exit once the database is ready to be used:

```text
    Waiting for rollout to finish: 0 of 1 updated replicas are available...
    Waiting for latest deployment config spec to be observed by the controller loop...
	replication controller "postgresql-1" successfully rolled out
```


