# Deploy to OpenShift Application Platform

For running locally the H2 Database has been a good choice, but when we now move into a container platform we want to use a more production-like database, and for that, we are going to use PostgreSQL. 

Before we deploy the application to OpenShift and verify that it runs correctly, there are a couple of things we have do. We need to add a driver for the PostgreSQL database that we are going to use, and we also need to add health checks so that OpenShift correctly can detect if our application is working. 


**1. Create the database**

Since this is your own personal project you need to create a database instance that your application can connect to. In a shared environment this would typically be provided for you, that's why we are not deploying this as part of your application. It's however very simple to do that in openshift. All you need to do is to execute the below command in the console.

``oc new-app -e POSTGRESQL_USER=luke \
             -e POSTGRESQL_PASSWORD=secret \
             -e POSTGRESQL_DATABASE=my_data \
             openshift/postgresql-92-centos7 \
             --name=my-database``{{execute}}

**2. Review Database configuration**

Take some time and review the ``src/main/fabric8/deployment.yml``{{open}}.

As you can see that file specifies a couple of elements that are needed for our deployment. It also uses the username and password from a Kubernetes Secret. For this environment we are providing the secret in this file ``src/main/fabric8/credentials-secret.yml``{{open}}, however in a production environment this would likely be provided to you by the Ops team.

Now, review the ``src/main/resources/application-openshift.properties``{{open}}

In this file, we are using the configuration from the `deployment.yml` to read username, password, and other connection details. 

**3. Add the PostgreSQL database driver**

So far our application has only used the H2 Database, we now need to add a dependency for PostgreSQL driver. We do that by adding a runtime dependency under the `openshift` profile in ``pom.xml``{{open}}.

<pre class="file" data-filename="pom.xml" data-target="insert" data-marker="<!-- TODO: ADD PostgreSQL database dependency here -->">
        &lt;dependency&gt;
          &lt;groupId&gt;org.postgresql&lt;/groupId&gt;
          &lt;artifactId&gt;postgresql&lt;/artifactId&gt;
          &lt;version&gt;${postgresql.version}&lt;/version&gt;
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

Run the following command to deploy the application to OpenShift

``mvn package fabric8:deploy -Popenshift -DskipTests``{{execute}}

After the maven build as finished, it will typically take less than 20 sec for the application to be available. To verify that everything is started run the following command and wait for it to report replication controller "fruits-s2i-1" successfully rolled out:

``oc rollout status dc/fruits``{{execute}}

Then either go to the openshift web console and click on the route or click [here](http://fruits-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com)

Make sure that you can add, edit, and remove fruits, using the web application 

## Congratulations

You have now learned how to deploy a Spring Boot application using a database to OpenShift Container Platform. This concludes the first learning scenario for Spring Boot. 

Click Summary for more details and suggested next steps.
