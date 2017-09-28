``intro-jberet`` app uses PostgreSQL database for storing output data. 
To create PostgreSQL database in OpenShift dashboard, 
navigate to _Add to Project_ and then _Browse Catalog_, select _postgresql-ephemeral_.
For quicker access, you can start typing ``postgre`` in the filter field.

![Select PostgreSQL](../../assets/intro-openshift/java-batch-processing/03-catalog-postgresql.png)

Although a database would normally be paired with a persistent volume, we only want to demonstrate how to access the database in this course. The database instance we create here, will therefore only store the database in the filesystem local to the container. This means that if the database were restarted, any changes would be lost. When you deploy a database to be used with your own applications, you would want to look at using persistent volumes.

Click _Select_ button, and on the next page enter database parameters. We will only specify database
user name and password, and leave other fields with default values.

* _PostgreSQL Connection Username_: ``jberet``{{copy}}
* _PostgreSQL Connection Password_: ``jberet``{{copy}}

![PostgreSQL Parameters](../../assets/intro-openshift/java-batch-processing/03-postgresql-params.png)

Click _Create_ button, and the database is successfully created:

![PostgreSQL Created](../../assets/intro-openshift/java-batch-processing/03-postgresql-created.png)


