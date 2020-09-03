Now that your environment has been setup by configuring a Citrus HTTP client in the **citrus-context.xml** which has
then been injected into the **TodoAppIT.java** via Springs **@Autowired** annotation, we're ready to develop our tests.

Citrus provides a Java fluent API for writing integration tests. This API is automatically available as we extended our
class from **TestNGCitrusTestDesigner**. 

_Note that you could also use JUnit in combination with Citrus._

At first, let´s test whether the TodoApp is responsive, by requesting the list of current todo entries from the apps API. 
<pre class="file" data-filename="citrus-sample/src/test/java/org/citrus/samples/TodoAppIT.java" data-target="insert" data-marker="// TODO: implement testGet">
http(http -> http
           .client(todoClient)
           .send()
           .get("/api/todolist/"));

        http(http -> http
           .client(todoClient)
           .receive()
           .response(HttpStatus.OK));


</pre>

The test sends a **HTTP GET** request via the **todoClient** to the todo application. This **GET** request gets answered
with the current list of todo entries, which is basically a json document.

Afterwards, the test uses a receive operation to receive the response from the API and validate its content. This test
only expects a **HTTP 200 OK** response from the server.

## Run the test

You can run all Citrus tests with Maven by calling
 
`mvn clean verify -f citrus-sample/pom.xml`{{execute}}

You will see some log output in the terminal window showing the incoming request processing.

You can also start a single test by adding its name to the command:

`mvn clean verify -f citrus-sample/pom.xml -Dit.test=TodoAppIT#testGet`{{execute}}

This will only execute the **testGet** test.
