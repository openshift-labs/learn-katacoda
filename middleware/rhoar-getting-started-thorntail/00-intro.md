## What you will learn ##

In this scenario you will learn more about [Thorntail](https://thorntail.io), one of the runtimes
included in [Red Hat OpenShift Application Runtimes](https://developers.redhat.com/products/rhoar).

You will take an existing sample Thorntail application and modify it to address microservice concerns,
understand its structure, deploy it to OpenShift and exercise the interfaces between Thorntail apps,
microservices, and OpenShift/Kubernetes.

## What is Thorntail?

![Logo](/openshift/assets/middleware/rhoar-getting-started-thorntail/thorntail-logo.png)

Java EE applications are traditionally created as an **ear** or **war** archive including all
dependencies and deployed in an application server. Multiple Java EE applications can and
were typically deployed in the same application server. This model is well understood in
the development teams and has been used over the past several years.

[Thorntail](http://thorntail.io) offers an innovative approach to packaging and
running Java EE applications by
packaging them with just enough of the Java EE server runtime to be able to run them directly
on the JVM using **java -jar** For more details on various approaches to packaging Java
applications,
read [this blog post](https://developers.redhat.com/blog/2017/08/24/the-skinny-on-fat-thin-hollow-and-uber).

Thorntail implements [Eclipse MicroProfile](https://microprofile.io), which is a community-driven open source specification that optimizes Enterprise Java for a microservices architecture and delivers application portability across multiple MicroProfile runtimes.

Since Thorntail also draws many of its features from Java EE standards, it significantly simplifies refactoring
existing Java EE applications to microservices and allows much of existing codebase to be
reused in the new services.
