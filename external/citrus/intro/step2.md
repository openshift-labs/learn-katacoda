As we have a basic setup, we can now start developing some integration tests. These tests will call the HTTP REST API of the todo app as a client and validate the server response messages.

A basic Citrus test has already been prepared, so that we can start right away.

## Add a HTTP client component

To communicate with the REST API of the todo app in our tests, a HTTP client is required. For those use cases, Citrus
provides ready-to-use endpoints for exchanging messages over various transports. The only thing we have to do, is to 
configure them in the test project.

Open the ``citrus-sample/src/test/java/org/citrus/samples/EndpointConfig.java``{{open}} in the editor.

The file shows a Spring XML bean configuration. You can add and manage Citrus components by adding or modifying these beans.

_To find out more about the Spring framework, visit the [official website](https://spring.io/)._

Now, add the new HTTP client bean to the the EndpointConfig class:
<pre class="file" data-filename="citrus-sample/src/test/java/org/citrus/samples/EndpointConfig.java" data-target="insert" data-marker="// TODO: Add endpoint bean">
@Bean
    public HttpClient todoClient() {
        return CitrusEndpoints.http()
            .client()
            .requestUrl("http://todo-api-todo-api-project.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com")
            .build();
    }
</pre>

The HTTP client component is now ready to exchange HTTP messages with the todo application. 

_Note that you could also use Spring @Configuration classes to create Citrus beans, using Citrus endpoint builder._

## Add the HTTP client to the test class

Now, let us add the previously created Citrus HTTP client to our test class.
For this tutorial we removed the default sample test classes shipped with the archetype and provided skeleton baseclass for your test in TodAppIT.java.
Therefore, open the file ``citrus-sample/src/test/java/org/citrus/samples/TodoAppIT.java``{{open}}.

As you can see, we prepared a test class for you that contains two _@CitrusTest_ test cases. One will be a simple **GET**
request while the other will test a complete workflow of the todo app.
 
Now, add the prepared HTTP client.
<pre class="file" data-filename="citrus-sample/src/test/java/org/citrus/samples/TodoAppIT.java" data-target="insert" data-marker="// TODO: add todoClient">
@Autowired
    private HttpClient todoClient;
</pre>

The HTTP client endpoint component is automatically injected to the test using Spring's _@Autowired_ dependency
injection mechanism.
