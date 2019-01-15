In this tutorial you'll learn how to test HTTP REST APIs with Citrus.

First of all, we need a demo web application that we would like to test. In this tutorial we are using the 
[todo-app](https://github.com/christophd/citrus-samples/tree/master/todo-app) sample web application available on GitHub.

## System under test
The system under test, we want to perform our integration tests on, is a simple todo app with a few endpoints allowing 
us to communicate with other software components (e.g. a frontend). The sample application has already been prepared 
and is ready to run. 

Let's open the todo-app in the web view component. [weblink](http://todo-app.paas.consol.de/todolist) 

You can create new todo entries, check them as done and remove the entries from the list.
