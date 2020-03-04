# Introduction

Deploying applications as Serverless services is becoming a popular architectural style. It seems like many organizations assume that _Functions as a Service (FaaS)_ implies a serverless architecture. We think it is more accurate to say that FaaS is one of the ways to utilize serverless, although it is not the only way. This raises a super critical question for enterprises that may have applications which could be monolith or a microservice: What is the easiest path to serverless application deployment?

The answer is a platform that can run serverless workloads, while also enabling you to have complete control of the configuration, building, and deployment. Ideally, the platform also supports deploying the applications as linux containers.

In this chapter we introduce you to one such platform -- [OpenShift Serverless](https://www.openshift.com/learn/topics/serverless).  OpenShift Serverless utilizes Knative that  extends the cluster in a Kubernetes-native way to provide a set of components for deploying, running and managing modern applications running serverless.

At the end of this module you will understand:

* Deploy a Knative service.
* Deploy multiple revisions of a service.
* Run different revisions of a service via traffic definition.
* Install Knative Client
* Create, update, list and delete Knative service
* Create, update, list and delete Knative service revisions
* List Knative service routes
