In this tutorial you'll learn how to test HTTP REST APIs with [Citrus integration Testing Framework](https://citrusframework.org/).

Citrus is a Java based integration testing framework, that allows integration tests against various message protocols and data formats (HTTP, JMS, TCP/IP, SOAP, FTP, SSH, XML, JSON, Mail, just to name a few). Therefore it is suitable to test microservice based environments or other distributed systems. This makes it especially useful to test applications that runs on [Kubernetes](https://kubernetes.io/) oder [Openshift](https://www.openshift.com)

Before we start testing, we need a demo web application which we would like to test. In this tutorial we are using the 
[todo-app](https://github.com/christophd/citrus-samples/tree/master/todo-app) sample web application available on GitHub. This Application is currently deployed on a [Openshift](https://www.openshift.com) cluster from [ConSol](https://www.consol.com)

## System under test
The system under test, we want to perform our integration tests on, is a simple todo app with a few endpoints allowing 
us to communicate with other software components (e.g. a frontend). The sample application has already been prepared 
and is ready to run. 

You can open the application [here](http://todo-app.paas.consol.de/todolist). 

You can create new todo entries, check them as done and remove the entries from the list.
