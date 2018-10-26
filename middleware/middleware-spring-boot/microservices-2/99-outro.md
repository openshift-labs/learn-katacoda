In this scenario you learned about Spring Boot and how it can be used to create Microservices using Service Discovery and Load Balancing techniques. We will add additional scenarios that explain more how to build Spring Boot applications on OpenShift shortly, so check back to [learn.openshift.com](http://learn.openshift.com)

To summarize: Load Balancing and Service Discovery are two core concepts to be aware of when working with Microservices. OpenShift has Load Balancing and Service Discovery already built in out of the box. This is because OpenShift is built on top of Kubernetes and wraps the provided functionality, making it easy to interact with. 

Load Balancing is the practice of splitting traffic for performance and sometimes functionality reasons, while Service Discovery allows us to find our service instances and use a single address to connect to the multiple deployed services. The combination of both allow us to use a microservice architecture that can handle heavy load and scale easily and effectively.

Spring Boot is a powerful and easy to use framework for developing everything from monolithic applications to microservices, but Spring Boot becomes every better when we package it in a container and use an orchestrated platform like OpenShift. When using OpenShift we can, in a very consistent and fast way, deploy our Spring application to multiple environments without worry of environment differences. OpenShift also enables things like Deployment Pipelines and Blue/Green deployments but that was not covered in this scenario.  

## Additional Resources

More background and related information on Red Hat OpenShift Application Runtimes and Eclipse Vert.x can be found here:

* [Red Hat OpenShift Application Runtimes for Developers](https://developers.redhat.com/rhoar) - Here you can get started with a project using different boosters and clone that project to your local computer. This also enables you to deploy your application on your own private OpenShift Container Platform or use OpenShift Online that is provided for free from Red Hat.
* [Project Snowdrop homepage](https://snowdrop.me/) - This site has a lot of details of the work that Red Hat is doing to make Spring work great on Kubernetes and OpenShift.


