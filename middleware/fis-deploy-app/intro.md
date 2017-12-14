In this self paced tutorial you will learn how to build, deploy, and expose container based APIs using JBoss Fuse Integration Services (FIS) 2.0 for OpenShift. This introductory service will expose the People Service API which includes methods for adding, searching, and listing individuals. In addition, the People Service API will publish the associated API Swagger documentation via FIS Camel SWAGGER.

## Before you get started

If you are not familiar with the OpenShift Container Platform, it's worth taking a few minutes to understand the basics of the platform as well as the environment that you will be using for this self paced tutorial.  Head on over to [Learning OpenShift - Getting Started](https://learn.openshift.com/middleware/getting-started/).

## What is JBoss FIS

Red Hat JBoss FIS 2.0 is an agile, lightweight, and modern development framework for building and deploying highly scalable and modular APIs. A true hybrid solution, JBoss FIS 2.0 offers best of container based development practices coupled with well known microservices and enterprise integration patterns including: Proxy/Sidecars, Circuit Breakers, Tracing, Routing, Transformations, Auditing and more.

Having this hybrid capability is important as demand grows for scalable cloud native microservice APIs. To simplify the development JBoss FIS components offer a choice of two runtimes:

* As a standalone Java application (SpringBoot)
* As a service in Apache Karaf (OSGi)

Also when using the OpenShift Container Platform there are various ways to deploy a JBoss FIS API:

* Deploy Fuse application from an existing Docker-formatted image.
* Build Fuse locally and push the build result into OpenShift, a Binary Source-to-Image (s2i) builder.
* Build and deploy from source code contained in a Git repository using a Source-to-Image builder.

For our introductory lesson we are going to use OpenShifts s2i repository builder to pull in, build and deploy a JBoss FIS API service using the SpringBoot container runtime. So lets get started!
