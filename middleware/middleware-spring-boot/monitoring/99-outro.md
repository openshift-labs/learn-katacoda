In this scenario you learned about Spring Boot and how to monitor Spring Boot applications using OpenShift. We will add additional scenarios that explain more how to build Spring Boot applications on OpenShift shortly, so check back to [learn.openshift.com](http://learn.openshift.com)

To summarize: We started by deploying our basic Spring Boot application to OpenShift via jkube. Then we checked on our application by accessing it through the route, which allows for external connection through a hostname. After we knew the application was up and available for all, we decided to add a health check with Spring Actuator to provide OpenShift with more information about our container and allow them to handle the restarting of failed instances. We then took a deeper dive into Actuator and looked at some of the other endpoints it provides, which allowed us to get all types of additional information about our application. 

Spring Boot is a powerful and easy to use framework for developing everything from monolithic applications to microservices, but Spring Boot becomes every better when we package it in a container and use an orchestrated platform like OpenShift. When using OpenShift we can, in a very consistent and fast way, deploy our Spring application to multiple environments without worry of environment differences. OpenShift also enables things like Deployment Pipelines and Blue/Green deployments but that was not covered in this scenario.  

## Additional Resources

More background and related information on Red Hat OpenShift Application Runtimes can be found here:

* [Red Hat Runtimes for Developers](https://developers.redhat.com/rhoar) - Here you can get started with a project using different boosters and clone that project to your local computer. This also enables you to deploy your application on your own private OpenShift Container Platform or use OpenShift Online that is provided for free from Red Hat.
* [Project Snowdrop homepage](https://snowdrop.dev/) - This site has a lot of details of the work that Red Hat is doing to make Spring work great on Kubernetes and OpenShift.


