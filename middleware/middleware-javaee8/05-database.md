
So far we have been using an in-memory database that is part of JBoss EAP. However, JBoss EAP only provides this to make it easy to develop and test application. The in-memory database H2 is not recommended for production use.

In this part, you will learn how to setup a simple PostgreSQL database in OpenShift, how to configure a datasource within the JBoss EAP image that connects to the database, and finally how to make use of that database in your application.


**1. Remove the internal in-memory database**

If you recall in step 03 we create a datasource definition as part of the deployment. To remove it we have to do delete that file

`rm -f src/main/webapp/WEB-INF/weather-ds.xml`{{execute}}

**2. Start a PostgreSQL database**

To start a PostgreSQL database in OpenShift we can simply use the image provided as part of the OpenShift distribution. 

`oc new-app -e POSTGRESQL_USER=weather-app-user -e POSTGRESQL_PASSWORD=secret -e POSTGRESQL_DATABASE=weather-db --name=weather-postgresql postgresql`{{execute}}

By using the `-e` flag, we can also pass a set of environment variables that will configure and setup the PostgreSQL database. These environment variables are pretty self explaining.

**3. Add the datasource configuration**

Normally, to set up a database we would either use the web console in JBoss EAP or CLI scripts. However, in a cloud native environment, we want all this configuration to be automatic so that if want to scale-up or restart a container this configuration would still be there. For that reason, the JBoss EAP image can automatically create datasource for us based on environment variables. In a minute we will investigate the environment variables closer, but for now, all you need to do is run the following command.

```
oc env dc/weather-app -e DB_SERVICE_PREFIX_MAPPING=weather-postgresql=DB \
  -e DB_JNDI=java:jboss/datasources/WeatherDS \
  -e DB_DATABASE=weather-db \
  -e DB_USERNAME=weather-app-user \
  -e DB_PASSWORD=secret
```{{execute}}

The different environment variables that you can use for JBoss EAP 7.2 are documented [here](https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.2/html/getting_started_with_jboss_eap_for_openshift_container_platform/introduction). In our case the first and most important environment variable is `DB_SERVICE_PREFIX_MAPPING` since that both tell us the name of the service that is hosting the database as well as a prefix to use for reading the other environment variables. The reason it's done like this is to be able to support using multiple datasources in one single application. We could for example add `DB_SERVICE_PREFIX_MAPPING=other-postgresql=OTHERDB` and then the subsequent variables would be `OTHERDB_JNDI`, `OTHERDB_DATABASE`, etc.

However, in our weather app we are only using one datasource, so we are ready to re-deploy it.

**6. Deploying the application**

We are now ready to test our application in OpenShift using an external database.

First, build the application and verify that we do not have any compilation issues.

`mvn clean package`{{execute}}

Next, build a container by starting an OpenShift S2I build and provide the WAR file as input.

`oc start-build weather-app --from-file=target/ROOT.war --wait`{{execute}}

When the build has finished, you can test the REST endpoint directly using for example curl.

You can also test the web application by clicking [here](http://weather-app-my-project.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/index.html)

Note: that it might take a couple of seconds for the application to start so if you see an error page wait 30 secs and then try again.

**7. Verify the database**

Open [this](http://weather-app-my-project.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/index.html) link and click on the US flag. Note the weather icon in New York. It should be sunny.

Let's update the database and set it to rainy instead.

`oc rsh dc/weather-postgresql`{{execute}}

`psql -U $POSTGRESQL_USER $POSTGRESQL_DATABASE -c "update city set weathertype='rainy-5' where id='nyc'";`{{execute}}

Now, reload the weather page for US and check the weather icon in New York. It should now be rainy.
