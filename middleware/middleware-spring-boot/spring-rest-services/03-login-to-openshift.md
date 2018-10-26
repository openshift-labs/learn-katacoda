# Login and Deploy to OpenShift Container Platform

**Red Hat OpenShift Container Platform** is the preferred runtime for **Red Hat OpenShift Application Runtimes** like **Spring Boot**, **Vert.x**, etc. The OpenShift Container Platform is based on **Kubernetes** which is a Container Orchestrator that has grown in popularity and adoption over the last couple years. **OpenShift** is currently the only container platform based on Kubernetes that offers multitenancy. This means that developers can have their own personal, isolated projects to test and verify applications before committing to a shared code repository.

OpenShift also ships with a feature rich web console as well as command line tools to provide users with a friendly interface to work with applications deployed to the platform. 

**1. Login to the OpenShift Container Platform**

To login, we will use the `oc` command with the developer credentials:

``oc login [[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com --insecure-skip-tls-verify=true -u developer -p developer``{{execute}}

>**IMPORTANT:** If the above `oc login` command doesn't seem to do anything, you may have forgotten to stop the application from the previous step. Click on the terminal and press **CTRL-C** to stop the application and try the above `oc login` command again!

Then we'll create the project:

``oc new-project fruits --display-name="Dev - Spring Boot App"``{{execute}}

Now create a database:

``oc new-app -e POSTGRESQL_USER=dev -e POSTGRESQL_PASSWORD=secret -e POSTGRESQL_DATABASE=my_data openshift/postgresql-92-centos7 --name=my-database``{{execute}}

Our application knows how to interact with the database because we defined the properties in the ``src/main/resources/application-openshift.properties``{{open}} file. You can see below that we have supplied the URL, username, password, and driver for the database.
```
spring.datasource.url=jdbc:postgresql://${MY_DATABASE_SERVICE_HOST}:${MY_DATABASE_SERVICE_PORT}/my_data
spring.datasource.username=${DB_USERNAME}
spring.datasource.password=${DB_PASSWORD}
spring.datasource.driver-class-name=org.postgresql.Driver
spring.jpa.hibernate.ddl-auto=create
```
All that's left is to run the following command to deploy the application to OpenShift:

``mvn package fabric8:deploy -Popenshift``{{execute}}

After it's complete we can either go to the OpenShift web console and click on the route or click [here](http://rhoar-training-fruits.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/api/fruits). You should see the same JSON output as the previous step:

```json
[{"name":"Cherry"},{"name":"Apple"},{"name":"Banana"}]
```
And if you open the [web application](http://rhoar-training-fruits.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/) the same functionality from the previous steps should still work.

## Congratulations

You have now learned how to deploy a Spring Boot MVC application to OpenShift Container Platform. 

Click Summary for more details and suggested next steps.