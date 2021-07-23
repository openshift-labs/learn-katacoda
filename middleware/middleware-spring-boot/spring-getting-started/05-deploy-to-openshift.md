# Deploy to OpenShift Application Platform

For running locally the H2 Database has been a good choice, but when we now move into a container platform we want to use a more production-like database, and for that, we are going to use PostgreSQL. 

Before we deploy the application to OpenShift and verify that it runs correctly, there are a couple of things we have do. We need to add a driver for the PostgreSQL database that we are going to use, and we also need to add health checks so that OpenShift correctly can detect if our application is working. 


**1. Create the database**

Since this is your own personal project you need to create a database instance that your application can connect to. In a shared environment this would typically be provided for you, that's why we are not deploying this as part of your application. It's however very simple to do that in openshift. All you need to do is to execute the below command in the console.

``oc new-app -e POSTGRESQL_USER=luke \
             -e POSTGRESQL_PASSWORD=secret \
             -e POSTGRESQL_DATABASE=my_data \
             openshift/postgresql:12-el8 \
             --name=my-database``{{execute}}

**2. Review Database configuration**

Take some time and review the ``src/main/jkube/deployment.yml``{{open}}.

As you can see that file specifies a couple of elements that are needed for our deployment. It also uses the username and password from a Kubernetes Secret. For this environment we are providing the secret in this file ``src/main/jkube/credentials-secret.yml``{{open}}, however in a production environment this would likely be provided to you by the Ops team.

Now, review the ``src/main/resources/application-openshift.properties``{{open}}

In this file, we are using the configuration from the `deployment.yml` to read username, password, and other connection details. 

**3. Add the PostgreSQL database driver**

So far our application has only used the H2 Database, we now need to add a dependency for PostgreSQL driver. We do that by adding a runtime dependency under the `openshift` profile in ``pom.xml``{{open}}.

<pre class="file" data-filename="pom.xml" data-target="insert" data-marker="<!-- TODO: ADD PostgreSQL database dependency here -->">
        &lt;dependency&gt;
          &lt;groupId&gt;org.postgresql&lt;/groupId&gt;
          &lt;artifactId&gt;postgresql&lt;/artifactId&gt;
          &lt;scope&gt;runtime&lt;/scope&gt;
        &lt;/dependency&gt;
</pre>


**4. Add a health check**

We also need a health check so that OpenShift can detect when our application is responding correctly. Spring Boot provides a nice feature for this called Actuator, which exposes health data under the path `/health`. All we need to do is to add the following dependency to ``pom.xml``{{open}} at the **TODO** comment..

<pre class="file" data-filename="pom.xml" data-target="insert" data-marker="<!-- TODO: ADD Actuator dependency here -->">
    &lt;dependency&gt;
      &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
      &lt;artifactId&gt;spring-boot-starter-actuator&lt;/artifactId&gt;
    &lt;/dependency&gt;
</pre>

**5. Deploy the application to OpenShift**

Run the following command to deploy the application to OpenShift:

``mvn package oc:deploy -Popenshift -DskipTests``{{execute}}

This step may take some time to do the Maven build and the OpenShift deployment. After the build completes you can verify that everything is started by running the following command:

``oc rollout status dc/spring-getting-started``{{execute}}

Then either go to the OpenShift web console and click on the route or click [here](http://spring-getting-started-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com).

Make sure that you can add, edit, and remove fruits, using the web application.

# Open the solution in an IDE in the Cloud!
Want to continue exploring this solution on your own in the cloud? You can use the free [Red Hat CodeReady Workspaces](https://developers.redhat.com/products/codeready-workspaces/overview) IDE running on the free [Red Hat Developer Sandbox](http://red.ht/dev-sandbox). [Click here](https://workspaces.openshift.com) to login or to register if you are a new user. This free service expires after 30 days, but you can always enable a new free 30-day subscription.

Once logged in, [click here](https://workspaces.openshift.com/f?url=https://raw.githubusercontent.com/openshift-katacoda/rhoar-getting-started/solution/spring/spring-rhoar-intro/devfile.yaml) to open the solution for this project in the cloud IDE. While loading, if it asks you to update or install any plugins, you can say no.

# Fork the source code to your own GitHub!
Want to experiment more with the solution code you just worked with? If so, you can fork the repository containing the solution to your own GitHub repository by clicking on the following command to execute it:

`/root/projects/forkrepo.sh`{{execute T1}}
- Make sure to follow the prompts. An error saying `Failed opening a web browser at https://github.com/login/device exit status 127` is expected.
- [Click here](https://github.com/login/device) to open a new browser tab to GitHub and paste in the code you were presented with and you copied.
- Once done with the GitHub authorization in the browser, close the browser tab and return to the console and press `Enter` to complete the authentication process.
- If asked to clone the fork, press `n` and then `Enter`.
- If asked to confirm logout, press `y` and the `Enter`.

   > **NOTE:** This process uses the [GitHub CLI](https://cli.github.com) to authenticate with GitHub. The learn.openshift.com site is not requesting nor will have access to your GitHub credentials.

After completing these steps the `rhoar-getting-started` repo will be forked in your own GitHub account. On the `solution` branch in the repo, the `spring-rhoar-intro` project inside the `spring` folder contains the completed solution for this scenario.

## Congratulations

You have now learned how to deploy a Spring Boot application using a database to OpenShift Container Platform. This concludes the first learning scenario for Spring Boot. 

Click Summary for more details and suggested next steps.
