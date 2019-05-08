In this scenario you will learn more about developing Spring Boot Microservices using the [Red Hat OpenShift Application Runtimes](https://developers.redhat.com/products/rhoar) platform. You will learn about what Service Discovery and Load Balancing are and why they're important, as well as a little about how it's handled within the Spring ecosystem using Netflix libraries like Eureka and how Kubernetes (and OpenShift) handles it behind the scenes.

# Load Balancing

As its name suggests, Load Balancing is the process of balancing the amount of traffic that a system receives by spreading it across multiple resources. It's a useful process that has multiple applications and benefits that we'll take a look at.

**1. Why use Load Balancing?**

As we mentioned, the act of load balancing is done with a Load Balancer and evenly spreads traffic to multiple resources. However the only use of a Load Balancer doesn't have to be for pure efficiency reasons. Because all we're really doing is directing traffic, nothing stops us from directing traffic to specific resources over others for reasons other than balancing traffic.

**1.1 A/B Testing**

`A/B testing` is a prime example of functionality that we can achieve through load balancing that isn't directly related to performance. A/B testing is the process of having two slightly different versions of the same application and deploying both. Maybe the first version has a button that we want our users to click on in the top left corner while the second version put the same button in the top right. With Load Balancing we can direct some amount of our traffic to both scenarios and see which ones illicit the desired response from our users. 

In that simple example there may be no reason to filter which users see which outcome so we might pick the participants randomly. However if we wish to make a change be visible to only a smaller subset of our users, let's say all users that are visiting our application from outside of the United States, this is also possible. This is a powerful concept that can be used to continually improve an application through monitoring and measuring small changes made in a production environment with actual users.

**1.2 Blue/Green Deployment**

On top of testing, we can also use Load Balancing to help implement different deployment strategies that give us some advantages. One of those is the `Blue/Green Deployment` strategy. The idea behind Blue/Green deployment is to have two deployment environments that we swap between. When we start the process, both regions have the exact same code but only one is the `live` region. The region that isn't live is the `backup` region for now. Once a new version comes out we push those changes to our backup region. This now becomes the `staging` region for our new version. Once we determine that our new version is stable, we reallocate all of the traffic that was going to our previous live region to go to our new staging region. Our `staging` region becomes our `live` region, and our `live` region becomes our `backup` region.

One of the major benefits to this deployment strategy is that it's very quick and easy to revert to a previous version. All it takes is diverting the traffic to the region that's deployed but not in use. Blue/Green deployment also minimizes downtime since our application is never wholly offline, the traffic is only being directed to our new regions. You can read more about `Blue/Green Deployment` [here](https://martinfowler.com/bliki/BlueGreenDeployment.html).

**1.3 Canary Deployment**

Another example of a deployment strategy that Load Balancing let's us take advantage of is the `Canary Deploment` strategy. Also known as `Phased Rollout` or `Incremental Rollout`, this concept is a simple one. The idea is that we have some new version of our application that we want to release to production. Because we can't guarantee the stability of our new application version we don't want to expose it to all of our users at once. In an attempt to see how stable our new version is, we instead incrementally rollout our new version to a small group of users at a time. 

Since we're choosing which users are being exposed to the new version of the application we can closely monitor any unintended side-effects that might arise from the new version. This greatly reduces the impact of a serious outage affecting all users since we're able to get a small group of users to test the new version directly without impacting all users with the hope that any issues will become evident from the sample size selected. You can read more about `Canary Deployment` [here](https://martinfowler.com/bliki/CanaryRelease.html).

**2. How Load Balancing is handled in OpenShift**

Load Balancing functionality is built into OpenShift by default. OpenShift provides its load balancing through its concept of service abstraction. All incoming traffic first comes through a Router, which is responsible for exposing the service externally for users.

![Route Exposure](/openshift/assets/middleware/rhoar-microservices/route-expose.png)

 The Router will then split the traffic on to the different services that have been requested. It's the service that defines how it's distributed, so although the router is the one splitting the traffic, you get to decide how to split which traffic goes to which of the multiple service instances from within the service.

![Route Splitting](/openshift/assets/middleware/rhoar-microservices/route-split.png)

You can read more about Load Balancing [here](https://access.redhat.com/documentation/en-us/reference_architectures/2017/html-single/spring_boot_microservices_on_red_hat_openshift_container_platform_3/index#load_balancer).

# Service Discovery

When we're handling a microservice architecture, it's very possible that we have multiple services across multiple servers or even multiple data servers. While the end user might not care much about the location of any of these services, our application is highly concerned with the connection details for each service. This problem is addressed with `Service Discovery`.

**1. What is Service Discovery?**

As we mentioned, when services become spread out they become difficult to manage. It's tough to keep track of where each service is and what information details are needed to connect to each service. Service Discovery is exactly what it sounds like, the process of discovering all of our exposed services and how to connect with them.

This process of keeping track of multiple services is solved with the use of a `Service Registry`. Each service registers with the Service Registry upon creation, and the Service Registry is responsible for handling and maintaining the information required to connect to each service. 

You can read more about Service Discovery [here](https://appdev.openshift.io/docs/spring-boot-runtime.html#creating-a-basic-spring-boot-application_spring-boot).

**2. How Service Discovery is handled in OpenShift**

Service Discovery is functionality built into OpenShift by default through the use of Kubernetes services. When we are deploying our microservices, we are creating multiple pods that are all assigned to one service that acts like a parent. This assignment happens by creating a `Label` that's given to the pod, which the Service is told to look for through its `Service Selector`. The service will then grab any pod that's created and has the specified label. This means there's no work necessary on our side when we want to have an existing service handle newly created pods.

![Service Discovery](/openshift/assets/middleware/rhoar-microservices/service-discovery.png)

The service acts as an internal load balancer, proxying any requested connections to any of the pods using their internal IP addresses. While pods can be added or removed arbitrarily, the service remains consistently available. This allows anything that depends on the service to use a consistent internal address.

Since it's possible for microservices to go down from time to time, it's important to think of how that situation gets handled within the Service Registry. Generally a Service Registry is paired with a load balancer layer (mentioned in the previous section) that will seamlessly fail over upon discovering that the instance no longer exists. So if a service instance was to go down, the Service Registry would not be able to return the required information and the load balancer would kick in to handle it while also caching the service registry lookups.


## Congratulations

We've now gone over two important core concepts when dealing with a microservice architecture and took a look at how OpenShift handles all of the heavy lifting for us in regards to Load Balancing and Service Discovery!
