# Build your first application

For your convenience, this scenario has been created with a base project using the Java programming language and the Apache Maven build tool.

For educational purposes, this scenario uses one single Java class named `HttpApplication.java`. Now open that file, by clicking on the link below:

``src/main/java/com/example/HttpApplication.java``{{open}}

As you review the content, you will notice that there are a lot of **TODO** comments. **Do not remove them!** These comments are used as a marker and without them, you will not be able to finish this scenario.

Notice that `HttpApplication` class extends another class called `AbstractVerticle`. Before we start implementing our logic, let's discuss a bit what a Verticle is.

# What is a verticle?
Verticles — the Building Blocks of Eclipse Vert.x

Vert.x gives you a lot of freedom in how you can shape your application and code. But it also provides bricks to start writing reactive applications. Verticles are chunks of code that get deployed and run by Vert.x. An application, such as a microservice, would typically be comprised of many verticles. A verticle typically creates servers or clients, registers a set of Handlers', and encapsulates a part of the business logic of the system.

In Java, a verticle is a class extending the Abstract Verticle class:

```java
    import io.vertx.core.AbstractVerticle;

    public class MyVerticle extends AbstractVerticle {
        @Override
        public void start() throws Exception {
            // Executed when the verticle is deployed
        }

        @Override
        public void stop() throws Exception {
            // Executed when the verticle is un-deployed
        }
    }
```

## Creating a simple web server that can serve static content

**1. Compile and run the application Eclipse Vert.x application**

Before we add code to create our web server you should build and test that current application starts as it should.

First, switch to the project directory:

`cd /root/projects/rhoar-getting-started/vertx/vertx-intro`{{execute}}

Since this is already a working application, you can run it without any code changes locally directly using `maven` with goal `vertx:run`

``mvn compile vertx:run``{{execute}}

>**NOTE:** The vert.x maven plugin replays the phases executed before it starts the application and it's therefor good practice to also specify the goals.  

At this stage, the application doesn't do anything, but after a while, you should see the following two lines in your console window:

```console
[INFO] Starting vert.x application...
[INFO] THE HTTP APPLICATION HAS STARTED
```
>**NOTE:** The `"Starting vert.x application..."` line indicates that your application is starting and that the Verticles are triggered asynchronously. The message `"THE HTTP APPLICATION HAS STARTED"` that comes from a `System.out.println` in `HttpApplication.java` Verticle.

**2. Add a router that can serve static content**

Your first job will be to add an `HTTP` server that can return HTML pages.

> **NOTE:** For your convenience the `HttpApplication` already has the necessary import statements.

First, you need to create a `Router` object. This router will handle all incoming requests. Add the following line in the `start` method `HttpApplication.java` where the matching `TODO` statement is (or click the handy button that will insert the code in the correct place)

<pre class="file" data-filename="src/main/java/com/example/HttpApplication.java" data-target="insert" data-marker="// TODO: Create a router object">Router router = Router.router(vertx);</pre>

We also need to tell the router to map incoming requests to files in the default location (e.g. `src/main/resources/webroot`). You can do that by adding the following line to the matching `TODO` statement.

<pre class="file" data-filename="src/main/java/com/example/HttpApplication.java" data-target="insert" data-marker="// TODO: Add a StaticHandler for accepting incoming requests">router.get("/*").handler(StaticHandler.create());</pre>

Now we are ready to start the HTTP server,
<pre class="file" data-filename="src/main/java/com/example/HttpApplication.java" data-target="insert" data-marker="// TODO: Create the HTTP server listening on port 8080">vertx.createHttpServer().requestHandler(router).listen(8080);</pre>

NOTE: As you may have noticed Vert.x will automatically detect when you change and files an immediately redeploy the changes. The automatic redeploy is very convenient for development purposes but can be turned off for production usage.

**3. Test the application**

To begin, click on the **Local Web Browser** tab in the console frame of this browser window, which will open another tab or window of your browser pointing to port 8080 on your client.

![Local Web Browser Tab](/openshift/assets/middleware/rhoar-getting-started-vertx/web-browser-tab.png)

You should now see an HTML page that looks like this:

![Local Web Browser Tab](/openshift/assets/middleware/rhoar-getting-started-vertx/web-page.png)

or use [this](https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/) link.

> **NOTE:** The Invoke button doesn't work yet, but we will fix that in the next step.

## Congratulations

You have now successfully executed the first step in this scenario.

Now you've seen how you with basically three lines of code can create an HTTP Server that is capable of serving static content using the Vert.x Toolkit.

In next step of this scenario, we will add server-side business logic to our application.
