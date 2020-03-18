In this self-paced tutorial, you will learn the basics of how to use OpenShift Serverless, which provides a development model to remove the overhead of server provisioning and maintenance from the developer.

In this tutorial, you will:
* Deploy an OpenShift Serverless service.
* Deploy multiple revisions of a service.
* Run different revisions of a service via canary deployments.
* Utilize the knative client

# Why Serverless?

Deploying applications as Serverless services is becoming a popular architectural style. It seems like many organizations assume that _Functions as a Service (FaaS)_ implies a serverless architecture. We think it is more accurate to say that FaaS is one of the ways to utilize serverless, although it is not the only way. This raises a super critical question for enterprises that may have applications which could be monolith or a microservice: What is the easiest path to serverless application deployment?

The answer is a platform that can run serverless workloads, while also enabling you to have complete control of the configuration, building, and deployment. Ideally, the platform also supports deploying the applications as linux containers.

# OpenShift Serverless

In this chapter we introduce you to one such platform -- [OpenShift Serverless](https://www.openshift.com/learn/topics/serverless).  OpenShift Serverless helps developers to deploy and run applications that will scale up or scale to zero on-demand. Applications are packaged as OCI compliant Linux containers that can be run anywhere.

![OpenShift Serving](assets/intro/knative-serving-diagram.svg)

Applications can be triggered by a variety of event sources, such as events from your own applications, cloud services from multiple providers, Software as a Service (SaaS) systems and Red Hat Services ([AMQ Streams](https://access.redhat.com/products/red-hat-amq)).

![OpenShift Eventing](assets/intro/knative-serving-diagram.svg)

OpenShift Serverless applications can be integrated with other OpenShift services, such as OpenShift [Pipelines](https://www.openshift.com/learn/topics/pipelines), [Service Mesh](https://www.openshift.com/learn/topics/service-mesh), Monitoring and [Metering](https://github.com/operator-framework/operator-metering), delivering a complete serverless application development and deployment experience.

## The Environment

During this scenario, you will be using a hosted OpenShift environment that is created just for you. This environment is not shared with other users of the system. Because each user completing this scenario has their own environment, we had to make some concessions to ensure the overall platform is stable and used only for this training. For that reason, your environment will only be active for a one hour period. Keep this in mind before you get started on the content. Each time you start this training, a new environment will be created on the fly.

The OpenShift environment created for you is running version 4.2 of the OpenShift Container Platform. This deployment is a self-contained environment that provides everything you need to be successful learning the platform. This includes a preconfigured command line environment, the OpenShift web console, public URLs, and sample applications.

Let's get started!
