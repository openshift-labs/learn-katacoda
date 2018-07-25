In this scenario, you learned about Spring Boot, and how it can be used to create CRUD applications. We will add additional scenarios that explain more how to build Spring Boot applications on OpenShift shortly, so check back to [learn.openshift.com](http://learn.openshift.com)

To summarize, you started by adding spring-boot-starter-web which brought in an supported version of embedded Apache Tomcat from the Red Hat maven repository (since we used the BOM from Snowdrop). This enabled us to have a running application returning index.html, but without any server-side logic. After that, we added spring-boot-data-jpa to bring in Hibernate and developed a Fruit Entity and a Repository for database access. Then you executed a set of test cases via spring-boot-starter-test to verify that our Fruit Repository worked as it should. After that, we created the REST services, and now we could test the full web application. Finally, we deployed everything to OpenShift after creating a database instance and adding the database driver. 


Spring Boot is a powerful and easy to use framework for developing everything from microservices to monolith application, but Spring Boot becomes every better when we package it in a container and use an orchestrated platform like OpenShift. When using OpenShift, we can in a very consistent and fast way deploy our Spring application, in an exact copy of our production environment. OpenShift also enables things like Deployment pipeline and Blue/Green deployment, but that was not covered in this scenario.  

## Additional Resources

More background and related information on Red Hat OpenShift Application Runtimes and Eclipse Vert.x can be found here:

* [Red Hat OpenShift Application Runtimes for Developers](https://developers.redhat.com/rhoar) - Here you can get started with a project using different boosters and clone that project to your local computer. This also enables you to deploy your application on your own private OpenShift Container Platform or use OpenShift Online that is provided for free from Red Hat.
* [Project Snowdrop homepage](http://snowdrop.me/) - This site has a lot of details of the work that Red Hat is doing to make Spring work great on Kubernetes and OpenShift.


