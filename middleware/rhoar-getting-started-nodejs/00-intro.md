## What you will learn ##

In this scenario you will learn more about [Node.js](https://nodejs.org), one of the runtimes
included in [Red Hat OpenShift Application Runtimes](https://developers.redhat.com/products/rhoar).

You will take an existing sample Node.js application and modify it to address microservice concerns,
understand its structure, deploy it to OpenShift and exercise the interfaces between Node.js apps,
microservices, and OpenShift/Kubernetes.

## What is Node.js?

![Logo](/openshift/assets/middleware/rhoar-getting-started-nodejs/logo.png)

Node.js is based on the [V8 JavaScript engine](https://developers.google.com/v8/) from Google and allows you to write server-side JavaScript
applications. It provides an I/O model based on events and non-blocking operations that enables you to
write applications that are both lightweight and efficient. Node.js also provides a large module ecosystem
called [npm](https://www.npmjs.com/). Check out the [Node.js Runtime Guide for](https://access.redhat.com/documentation/en-us/red_hat_openshift_application_runtimes/1/html-single/node.js_runtime_guide/) further reading on Node.js and
RHOAR.

The Node.js runtime enables you to run Node.js applications and services on OpenShift while providing all
the advantages and conveniences of the OpenShift platform such as rolling updates, continuous delivery
pipelines, service discovery, and canary deployments. OpenShift also makes it easier for your applications
to implement common microservice patterns such as externalized configuration, health check, circuit
breaker, and failover.
