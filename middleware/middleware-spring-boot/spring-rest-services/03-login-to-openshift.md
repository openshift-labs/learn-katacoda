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

# Open the solution in an IDE in the Cloud!
Want to continue exploring this solution on your own in the cloud? You can use the free [Red Hat CodeReady Workspaces](https://developers.redhat.com/products/codeready-workspaces/overview) IDE running on the free [Red Hat Developer Sandbox](http://red.ht/dev-sandbox). [Click here](https://workspaces.openshift.com) to login or to register if you are a new user. This free service expires after 30 days, but you can always enable a new free 30-day subscription.

Once logged in, [click here](https://workspaces.openshift.com/f?url=https://raw.githubusercontent.com/openshift-katacoda/rhoar-getting-started/solution/spring/spring-rest-services/devfile.yaml) to open the solution for this project in the cloud IDE. While loading, if it asks you to update or install any plugins, you can say no.

# Fork the source code to your own GitHub!
Want to experiment more with the solution code you just worked with? If so, you can fork the repository containing the solution to your own GitHub repository by clicking on the following command to execute it:

`/root/projects/forkrepo.sh`{{execute T1}}
- Make sure to follow the prompts. An error saying `Failed opening a web browser at https://github.com/login/device exit status 127` is expected.
- [Click here](https://github.com/login/device) to open a new browser tab to GitHub and paste in the code you were presented with and you copied.
- Once done with the GitHub authorization in the browser, close the browser tab and return to the console and press `Enter` to complete the authentication process.
- If asked to clone the fork, press `n` and then `Enter`.
- If asked to confirm logout, press `y` and the `Enter`.

   > **NOTE:** This process uses the [GitHub CLI](https://cli.github.com) to authenticate with GitHub. The learn.openshift.com site is not requesting nor will have access to your GitHub credentials.

After completing these steps the `rhoar-getting-started` repo will be forked in your own GitHub account. On the `solution` branch in the repo, the `spring-rest-services` project inside the `spring` folder contains the completed solution for this scenario.

## Congratulations

You have now learned how to deploy a RESTful Spring Boot application to OpenShift Container Platform. 

You'll find additional resources and other suggested scenarios in the next page.