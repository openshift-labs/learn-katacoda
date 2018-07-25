As we transition our applications towards a distributed architecture with microservices deployed across a distributed
network, many new challenges await us.

Technologies like containers and container orchestration platforms like OpenShift solve the deployment of our distributed
applications quite well, but are still catching up to addressing the service communication necessary to fully take advantage
of distributed applications, such as dealing with:

* Unpredictable failure modes
* Verifying end-to-end application correctness
* Unexpected system degradation
* Continuous topology changes
* The use of elastic/ephemeral/transient resources

Today, developers are responsible for taking into account these challenges, and do things like:

* Circuit breaking and Bulkheading (e.g. with Netflix Hystrix)
* Timeouts/retries
* Service discovery (e.g. with Eureka)
* Client-side load balancing (e.g. with Netflix Ribbon)

Another challenge is each runtime and language addresses these with different libraries and frameworks, and in
some cases there may be no implementation of a particular library for your chosen language or runtime.

In this scenario we'll explore how to use a new project called _Istio_ to solve many of these challenges and result in
a much more robust, reliable, and resilient application in the face of the new world of dynamic distributed applications.

## What is Istio?

![Logo](/openshift/assets/middleware/resilient-apps/istio-logo.png)

Istio is an open, platform-independent service mesh designed to manage communications between microservices and
applications in a transparent way.It provides behavioral insights and operational control over the service mesh
as a whole. It provides a number of key capabilities uniformly across a network of services:

* **Traffic Management** - Control the flow of traffic and API calls between services, make calls more reliable, and make the network more robust in the face of adverse conditions.

* **Observability** - Gain understanding of the dependencies between services and the nature and flow of traffic between them, providing the ability to quickly identify issues.

* **Policy Enforcement** - Apply organizational policy to the interaction between services, ensure access policies are enforced and resources are fairly distributed among consumers. Policy changes are made by configuring the mesh, not by changing application code.

* **Service Identity and Security** - Provide services in the mesh with a verifiable identity and provide the ability to protect service traffic as it flows over networks of varying degrees of trustability.

These capabilities greatly decrease the coupling between application code, the underlying platform, and policy. This decreased coupling not only makes services easier to implement, but also makes it simpler for operators to move application deployments between environments or to new policy schemes. Applications become inherently more portable as a result.

Sounds fun, right? Let's get started!
