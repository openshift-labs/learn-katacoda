In this tutorial you'll learn how to test HTTP REST APIs with [Citrus Integration Testing Framework](https://citrusframework.org/).

Citrus is a Java based integration testing framework, that allows integration tests against various message protocols and data formats (HTTP, JMS, TCP/IP, SOAP, FTP, SSH, XML, JSON, Mail, just to name a few). Therefore, it is suitable to test microservice based environments or other distributed systems. This makes it especially useful to test applications that runs on [Kubernetes](https://kubernetes.io/) or [Openshift](https://www.openshift.com).

## System under test
The system under test, we want to perform our integration tests on, is a simple todo app with a few endpoints allowing 
us to communicate with other software components (e.g. a frontend).

You can list all todos, create new todo entries and remove the entries from the list.

You'll deploy this application to OpenShift in the first step.
