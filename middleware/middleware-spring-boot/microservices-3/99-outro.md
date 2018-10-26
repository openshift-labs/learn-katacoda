In this scenario you learned about Spring Boot and how it can be used to create Microservices with the Circuit Breaker pattern. We will add additional scenarios that explain more how to build Spring Boot applications on OpenShift shortly, so check back to [learn.openshift.com](http://learn.openshift.com)

To summarize: We first started our application with the Circuit Breaker pattern implemented and our circuit in the `Closed` state. We confirmed this by hitting our secondary external service and getting back our expected response. However we then manually took the service down, forcing the calls to the Name service to fail. We confirmed this by attempting to make the call ourselves, and our circuit responded with our backup response. This meant that our circuit was in the `Open` state. In order to get our application back into a working state, we restarted the Name service. When we attempted our call again, our circuit checked and saw that the Name service was online and went back into the `Closed` state, returning our initial value again.

Spring Boot is a powerful and easy to use framework for developing everything from monolithic applications to microservices, but Spring Boot becomes every better when we package it in a container and use an orchestrated platform like OpenShift. When using OpenShift we can, in a very consistent and fast way, deploy our Spring application to multiple environments without worry of environment differences. OpenShift also enables things like Deployment Pipelines and Blue/Green deployments but that was not covered in this scenario.  

## Additional Resources

More background and related information on Red Hat OpenShift Application Runtimes and Eclipse Vert.x can be found here:

* [Red Hat OpenShift Application Runtimes for Developers](https://developers.redhat.com/rhoar) - Here you can get started with a project using different boosters and clone that project to your local computer. This also enables you to deploy your application on your own private OpenShift Container Platform or use OpenShift Online that is provided for free from Red Hat.
* [Project Snowdrop homepage](https://snowdrop.me/) - This site has a lot of details of the work that Red Hat is doing to make Spring work great on Kubernetes and OpenShift.
