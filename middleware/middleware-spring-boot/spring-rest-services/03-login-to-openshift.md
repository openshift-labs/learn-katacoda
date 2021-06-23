# Login and Deploy to OpenShift Container Platform

**Red Hat OpenShift Container Platform** is the preferred runtime for **Red Hat Runtimes** like **Spring Boot**, **Vert.x**, etc. The OpenShift Container Platform is based on **Kubernetes** which is a Container Orchestrator that has grown in popularity and adoption over the last years. **OpenShift** is currently the only container platform based on Kubernetes that offers multitenancy. This means that developers can have their own personal, isolated projects to test and verify applications before committing to a shared code repository.

OpenShift also ships with a feature rich web console as well as command line tools to provide users with a friendly interface to work with applications deployed to the platform. 

**1. Login to the OpenShift Container Platform**

This sandbox has already authenticated you to OpenShift. To validate, you will use the `oc whoami` command:

``oc whoami``{{execute}}

Then you'll create the project:

``oc new-project dev --display-name="Dev - Spring Boot App"``{{execute}}

Now create a database:

``oc new-app -e POSTGRESQL_USER=dev \
             -e POSTGRESQL_PASSWORD=secret \
             -e POSTGRESQL_DATABASE=my_data \
             openshift/postgresql:12-el8 \
             --name=my-database``{{execute}}

Our application knows how to interact with the database because you defined the properties in the ``src/main/resources/application-openshift.properties``{{open}} file. You can see below that the URL, username, password, and driver for the database have been supplied.
```
spring.datasource.url=jdbc:postgresql://${MY_DATABASE_SERVICE_HOST}:${MY_DATABASE_SERVICE_PORT}/my_data
spring.datasource.username=${DB_USERNAME}
spring.datasource.password=${DB_PASSWORD}
spring.datasource.driver-class-name=org.postgresql.Driver
spring.jpa.hibernate.ddl-auto=create
```
Run the following command to deploy the application to OpenShift:

``mvn package oc:deploy -Popenshift -DskipTests``{{execute}}

This step may take some time to do the Maven build and the OpenShift deployment. After the build completes you can verify that everything is started by running the following command:

``oc rollout status dc/spring-rest-services``{{execute}}


After the rollout is complete you can go to the OpenShift web console, login with **admin**/**admin** credentials, select **dev** project and find the route to your application under **Routes**. 

![Route from Web Console](/openshift/assets/middleware/rhoar-spring-rest-services/route.png)

You can also click [here](http://spring-rest-services-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/api/fruits) to directly access the running application. 

You should see the same JSON output as the previous step:

```json
[{"name":"Cherry"},{"name":"Apple"},{"name":"Banana"}]
```
And if you open the [web application](http://spring-rest-services-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/) the same functionality from the previous steps should still work.

## Congratulations

You have now learned how to deploy a RESTful Spring Boot application to OpenShift Container Platform. 

You'll find additional resources and other suggested scenarios in the next page.