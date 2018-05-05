# Introduction to Serverless Concepts and Apache OpenWhisk Commands

During this step of the course, we will be discussing some basic concepts of Serverless and a few of the Apache OpenWhisk commands.

## Serverless Concepts

The term Serverless is often used interchangeably with the term FaaS (Function-as-a-Service).  Serverless platforms provide APIs
that allow users to run code functions (also called actions) and return the results of each function.  Serverless platforms provide
HTTPS endpoints to allow the developer to retrieve function results.  These endpoints can be used as inputs for other functions, 
thereby providing a sequence (or chaining) of related functions.

On most Serverless platforms, the user deploys (or creates) the functions first before executing them.  The Serverless platform 
then has all the necessary code to execute the functions when it is told to.  The execution of a Serverless function can be invoked
manually by the user via a command or it may be triggered by an event source that is configured to activate the function in
response to events such as cron job alarms, file upload, or any of the many events that can be chosen.

## Apache OpenWhisk Concepts and Commands

Apache OpenWhisk offers the developer a straight forward programming model based on 4 concepts: actions, packages, triggers, 
and rules.

Actions are stateless code snippets that run on the Apache OpenWhisk platform. For example, an action can be used to detect
the faces in an image, respond to a database change, aggregate a set of API calls, or post a Tweet. An action can be written
as a JavaScript, Swift, Python or PHP function, a Java method, any binary-compatible executable including Go programs and custom 
executables packaged as Docker containers.

Actions can be explicitly invoked, or run in response to an event. In either case, each run of an action results in an activation
record that is identified by a unique activation ID. The input to an action and the result of an action are a dictionary of
key-value pairs, where the key is a string and the value a valid JSON value. Actions can also be composed of calls to other
actions or a defined sequence of actions.

Packages provide event feeds and anyone can create a new package for others to use. Triggers associated with those feeds
fire when an event occurs, and developers can map actions (or functions) to triggers using rules.  

Some of the more commonly used commands in Apache OpenWhisk are:

``wsk -i action create`` is used to create an action (or function) so it is deployed to the Serverless platform.

``wsk -i action update`` is used to update a deployed action.

``wsk -i action delete`` is used to delete a deployed action.

``wsk -i action list`` is used to list all the actions that are currently deployed and ready to execute.

``wsk -i action invoke`` is used to execute an action.

``wsk -i activation list`` is used to dump out the activation log which shows all the activations of actions.
