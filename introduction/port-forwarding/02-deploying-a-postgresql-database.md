To create a database which you can then connect to, run the command:

``oc new-app postgresql-ephemeral --name database --param DATABASE_SERVICE_NAME=database --param POSTGRESQL_DATABASE=sampledb --param POSTGRESQL_USER=username --param POSTGRESQL_PASSWORD=password``{{execute}}

This will start up an instance of a PostgreSQL database.

Although a database would normally be paired with a persistent volume, we only want to demonstrate how to access the database in this course. The database instance we create here, will therefore only store the database in the filesystem local to the container. This means that if the database were restarted, any changes would be lost. When you deploy a database to be used with your own applications, you would want to look at using persistent volumes.

To monitor progress as the database is deployed and made ready, run the command:

``oc rollout status dc/database``{{execute}}

This command will exit once the database is ready to be used.

When using a database with your front end web application, you will need to configure the web application to know about the database. We are going to skip that in this course.