Now that you've learned about the basic concepts, let´s add another, more complex test where we ensure that a posted todo
is stored and returned on request. After that, we'll delete the todo.

To test such complex use cases efficiently, some additional Citrus concepts and features are useful to keep the test
code clean and understandable. Therefore, we've prepared an implementation example in
``citrus-sample/src/test/java/org/citrus/samples/TodoAppLifecycleIT.java``{{open}}
Let's review that code in the editor before we execute it, to understand how it works.

The test consists of three variable definitions and five steps that send or receive messages to or from the todo app.
At first, let's have a look at the variables.

It's possible to define variables containing certain values in the Citrus test context. These variables can be used in
payloads, validation, URLs etc. In addition, Citrus provides various operations and value generators, allowing you to
create values following certain rules for your test cases.  
For example the expression `variable("todoId", "citrus:randomUUID()");` defines a Variable named _todoId_, which
contains a random generated UUID.

Now let's go through the test steps in detail.
1. Add a new todo entry.  
The http client performs a **POST** call to the todo app, containing a json document. This document references variables
that we've defined earlier. These references will be substituted by its values before the message is sent over the wire. 
_To clean up the test code, it is also possible to load those payloads from resource files._

2. Receive the verification from the backend.  
In this step, the client receives the response from the backend and validates it. It ensures, that the response code is
a **200 OK**, that the message type is plain text and that the payload is the id of the todo we've added.

3. Request the added todo entry.  
Here the client sends a get request to the `/api/todo/${todoId}` endpoint. Because the API expects the id of the 
requested todo as path variable, we just reuse our _todoId_ variable to construct the endpoint URL.

4. Validating the requested entry.  
To ensure that our todo entry has been added to the todo list correctly, we validate the content of the received json
document. Citrus contains a powerful and feature rich toolset to validate message payloads. In this example, we show
you the **json path validation**. The expression `validate("$.id", "${todoId}")` for example ensures, that the json 
path **$.id** contains the value of the variable **${todoId}**.  
The json path validation is just one way to validate payloads. You could also validate messages against json schemas,
xsd files or use various matchers to ensure that the payload is exactly matching your contract.

5. Deleting the todo entry.  
In this step, we delete the todo entry we used for our tests

6. Ensure that the deletion was successful.  
In this step we just validate the HTTP response code again to ensure that no error occurred in the backend.

So, if you like you can now run the test again:

`mvn clean verify -f citrus-sample/pom.xml`{{execute}}
