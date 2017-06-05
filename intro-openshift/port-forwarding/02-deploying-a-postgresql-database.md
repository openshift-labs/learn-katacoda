To create a database which you can then connect to, run the command:

``oc new-app postgresql-ephemeral --name database --param DATABASE_SERVICE_NAME=database --param POSTGRESQL_DATABASE=sampledb --param POSTGRESQL_USER=username --param POSTGRESQL_PASSWORD=password``{{execute}}

This will start up an instance of a PostgreSQL database.

Although a database would normally be paired with a persistent volume, we only want to demonstrate the use of port forwarding in this course. The database instance we create here, will therefore only store the database in the filesystem local to the container. This means that if the database were restarted, any changes would be lost. When you deploy a database to be used with your own applications, ensure you persistent volumes.

To monitor progress as the database is deployed and made ready, run the command:

``oc rollout status dc/dbname``{{execute}}

This command will exit once the database is ready to be used.
