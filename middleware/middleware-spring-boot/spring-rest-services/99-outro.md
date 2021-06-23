In this scenario you learned about Spring Boot and how it can be used to create RESTful APIs. We will add additional scenarios that explain more how to build Spring Boot applications on OpenShift shortly, so check back to [learn.openshift.com](http://learn.openshift.com)

To summarize, you started by adding spring-boot-starter-web which brought in an supported version of an embedded Apache Tomcat Container from the Red Hat Maven Repository (since we used the BOM from Snowdrop). This enabled us to have a running web application returning an `index.html` file but without any server-side logic. After that we created the REST services and now we could test the full web application. Finally, we deployed everything to OpenShift. 

Spring Boot is a powerful and easy to use framework for developing everything from monolithic applications to microservices, but Spring Boot becomes every better when we package it in a container and use an orchestrated platform like OpenShift. When using OpenShift we can, in a very consistent and fast way, deploy our Spring application to multiple environments without worry of environment differences. OpenShift also enables things like Deployment Pipelines and Blue/Green deployments but that was not covered in this scenario.  

## Additional Resources

More background and related information on Red Hat OpenShift Application Runtimes and Eclipse Vert.x can be found here:

* [Red Hat Runtimes for Developers](https://developers.redhat.com/rhoar) - Here you can get started with a project using different boosters and clone that project to your local computer. This also enables you to deploy your application on your own private OpenShift Container Platform or use OpenShift Online that is provided for free from Red Hat.
* [Project Snowdrop homepage](https://snowdrop.me/) - This site has a lot of details of the work that Red Hat is doing to make Spring work great on Kubernetes and OpenShift.


