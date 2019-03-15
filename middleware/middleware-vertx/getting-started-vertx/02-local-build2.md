# Expand your application with server side logic

In Step 1 you learned how to start an HTTP Server and use a static handler to server static files like HTML, CSS, etc. In this step, we will create a new handler that uses server-side code.

Looking closer at ``src/main/resources/webroot/index.html``{{open}} we can see that there is a JavaScript function at the end that should react if someone clicks the `Invoke` button. From this line `$.getJSON("/api/greeting?name="` we can see that the webpage expects an API call that will act as a greetings function. The idea is that the API function should take the value of the input field and turn it into a greeting string. 

**1. Add a method for handle greetings call**

First, we are going to implement a route handler called greeting. You will implement it as a private method in the `HttpApplication` class that takes a `RoutingContext` as a parameter. 

First open ``src/main/java/com/example/HttpApplication.java``{{open}} again.

First copy and paste the code below on the line stating `// TODO: Add method for greeting here`.

<pre class="file" data-filename="src/main/java/com/example/HttpApplication.java" data-target="insert" data-marker="// TODO: Add method for greeting here">private void greeting(RoutingContext rc) {
    String name = rc.request().getParam("name");
    if (name == null) {
        name = "World";
    }

    JsonObject response = new JsonObject()
        .put("content", String.format(template, name));

    rc.response()
        .putHeader(CONTENT_TYPE, "application/json; charset=utf-8")
        .end(response.encodePrettily());
    }
</pre>

The method uses a member variable called `template` that currently is defined as ``static final String template = "Hello, %s!";``.

NOTE: Since we want our handler to return the response to the browser immediately we will use the `rc.response().end()`. It is however possible to chain several handlers by using `rc.response().write()` and `rc.next()`.  

 **2.Add a route**

After implementing the handler we now need to add a route matching `/api/greeting` like this:

<pre class="file" data-filename="src/main/java/com/example/HttpApplication.java" data-target="insert" data-marker="// TODO: Add router for /api/greeting here">router.get("/api/greeting").handler(this::greeting);</pre>

NOTE: It's best practice to add more specific routes before wildcard routes since Vert.x will go through the routers in the same order they were added and if a matching route is found and it calls `rc.end()` any subsequent routes will not be executed.

**3. Test the application**

Now you should be able to use the **Invoke** Button [here](https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/). Test by adding different values in the input and also test by changing the `template` String in `HttpApplication.java`, to use another language. 

**4. Stop the application**

Before moving on, click in the terminal window and then press **CTRL-C** to stop the running application!

## Congratulations

You have now learned how to use multiple **Routes** and how to implement an HTTP Service call that returns JSON. 

In next step of this scenario we will deploy our application to the OpenShift Container Platform.