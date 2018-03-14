## What you will learn ##

In this scenario you will learn more about [WildFly Swarm](https://wildfly-swarm.io), one of the runtimes
included in [Red Hat OpenShift Application Runtimes](https://developers.redhat.com/products/rhoar).

You will take an existing sample WildFly Swarm application and modify it to address microservice concerns,
understand its structure, deploy it to OpenShift and exercise the interfaces between WildFly Swarm apps,
microservices, and OpenShift/Kubernetes.

## What is WildFly Swarm? 

![Logo](../../assets/middleware/rhoar-getting-started-wfswarm/swarm-logo.png)

Java EE applications are traditionally created as an **ear** or **war** archive including all 
dependencies and deployed in an application server. Multiple Java EE applications can and 
were typically deployed in the same application server. This model is well understood in 
the development teams and has been used over the past several years.

[WildFly Swarm](http://wildfly-swarm.io) offers an innovative approach to packaging and 
running Java EE applications by 
packaging them with just enough of the Java EE server runtime to be able to run them directly 
on the JVM using **java -jar** For more details on various approaches to packaging Java 
applications,
read [this blog post](https://developers.redhat.com/blog/2017/08/24/the-skinny-on-fat-thin-hollow-and-uber).

WildFly Swarm is based on WildFly and it also implements [Eclipse MicroProfile](https://microprofile.io), which is a community-driven open source specification that optimizes Enterprise Java for a microservices architecture and delivers application portability across multiple MicroProfile runtimes.


Since WildFly Swarm is based on Java EE standards, it significantly simplifies refactoring 
existing Java EE application to microservices and allows much of existing code-base to be 
reused in the new services.




