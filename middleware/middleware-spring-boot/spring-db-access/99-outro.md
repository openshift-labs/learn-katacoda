In this scenario you learned about Spring Boot and how it can be used to access relational data from a Database. We will add additional scenarios that explain more how to build Spring Boot applications on OpenShift shortly, so check back to [learn.openshift.com](http://learn.openshift.com)

To summarize: you started by adding spring-boot-data-jpa to the `pom.xml` which brought in the Spring dependencies necessary to talk to a database through the JPA protocol from the Red Hat Maven Repository (since we used the BOM from Snowdrop). Then you added a JPA-annotated Model to represent the table, a Repository interface through which you queried the data, and an `import.sql` file to seed the database with test data. Finally, we deployed everything to OpenShift. 

Spring Boot is a powerful and easy to use framework for developing everything from monolithic applications to microservices, but Spring Boot becomes every better when we package it in a container and use an orchestrated platform like OpenShift. When using OpenShift we can, in a very consistent and fast way, deploy our Spring application to multiple environments without worry of environment differences. OpenShift also enables things like Deployment Pipelines and Blue/Green deployments but that was not covered in this scenario.  

## Additional Resources

More background and related information on Red Hat OpenShift Application Runtimes and Eclipse Vert.x can be found here:

* [Red Hat OpenShift Application Runtimes for Developers](https://developers.redhat.com/rhoar) - Here you can get started with a project using different boosters and clone that project to your local computer. This also enables you to deploy your application on your own private OpenShift Container Platform or use OpenShift Online that is provided for free from Red Hat.
* [Project Snowdrop homepage](https://snowdrop.me/) - This site has a lot of details of the work that Red Hat is doing to make Spring work great on Kubernetes and OpenShift.


