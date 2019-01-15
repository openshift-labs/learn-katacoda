As we have a basic setup, we can now start developing some integration tests. These tests will call the HTTP REST API of the todo app as a client and validate the server response messages.

A basic Citrus test has already been prepared, so that we can start right away.

## Add a HTTP client component

To communicate with the REST API of the todo app in our tests, a HTTP client is required. For those use cases, Citrus
provides ready-to-use endpoints for exchanging messages over various transports. The only thing we have to do, is to 
configure them in the test project.

Please open the ``citrus-sample/src/test/resources/citrus-context.xml``{{open}} in the editor.

The file shows a Spring XML bean configuration. You can add and manage Citrus components by adding or modifying these beans.

_To find out more about the Spring framework, please visit the [official website](https://spring.io/)._

Now, add the new HTTP client component and safe the file.
<pre class="file" data-filename="citrus-sample/src/test/resources/citrus-context.xml" data-target="insert" data-marker="<!-- Common settings -->">
&lt;citrus-http:client id="todoClient" request-url="http://todo-app.paas.consol.de" /&gt;
</pre>

The HTTP client component is now ready to exchange HTTP messages with the todo application. 

_Please note that you could also use Spring @Configuration classes to create Citrus beans, using Citrus endpoint builder._

## Add the HTTP client to the test class

Now, let us add the previously created Citrus HTTP client to our test class.
For this tutorial we removed the default sample test classes shipped with the archetype and provided skeleton baseclass for your test in TodAppIT.java.
Therefore, please open the file ``citrus-sample/src/test/java/org/citrus/samples/TodoAppIT.java``{{open}}.

As you can see, we prepared a test class for you that contains two _@CitrusTest_ test cases. One will be a simple **GET**
request while the other will test a complete workflow of the todo app.
 
Now, please add the prepared HTTP client.
<pre class="file" data-filename="citrus-sample/src/test/java/org/citrus/samples/TodoAppIT.java" data-target="insert" data-marker="// TODO: add todoClient">
@Autowired
    private HttpClient todoClient;
</pre>

The HTTP client endpoint component is automatically injected to the test using Spring's _@Autowired_ dependency
injection mechanism.
