In this step, we will demonstrate how to view details of the newly-created PostgreSQL
database, and get database connection parameters. First go to dashboard _Overview_,
click PostgreSQL POD with blue circle:

![PostgreSQL POD](../../assets/intro-openshift/java-batch-processing/04-postgresql-overview-pod.png)

It then takes you to the POD detail page, similar to the following:

![PostgreSQL POD Detail](../../assets/intro-openshift/java-batch-processing/04-postgresql-pod.png)

Here you can view PostgreSQL POD details, environment variables, logs, events and access its terminal,
all available through the the menu tab near the top.

We will access the POD web terminal to get the database connection info. Click the _Terminal_ tab, and
run ``env | grep POSTGRES``{{copy}} command in web terminal:

![PostgreSQL POD](../../assets/intro-openshift/java-batch-processing/04-postgresql-terminal.png)

Among all these PostgreSQL database parameters, we will need ``POSTGRESQL_SERVICE_HOST`` value, 
and rely on default values for other parameters. So copy its value, similar to ``172.30.245.228``,
by selecting it, right-clicking, and choosing _Copy_ in the context menu.

Now in switch from the web console to the terminal pane at the top of the environment.
In the terminal where you logged into OpenShift do the following command, but replace the IP here
with the IP for your db.  For example (your value may be different):

``export DB=172.30.245.228``

[HEY, you can actually get the IP of the pod on the overview screen without making them go into the local terminal
you can see it right under **deployment** which is easier to copy]

Later when we run the batch application, we will reference ``$DB`` for the application
to connect to PostgreSQL database.
