# Review the base structure of the application

For your convenience, this scenario has been created with a base project using the Java programming language and the Apache Maven build tool.

The base project contains code for a simple Spring Boot application that exposes web services to retrieve data. Also, the project contains a simple integration test. Start by reviewing the  project's content by executing a ``tree``{{execute}} in your terminal.

The output should look something like this:

```sh
.
├── pom.xml
└── src
    ├── main
    │   ├── fabric8
    │   │   ├── deployment.yml
    │   │   └── route.yml
    │   ├── java
    │   │   └── com
    │   │       └── example
    │   │           └── Application.java
    │   │           └── service
    │   │           	└── Fruit.java
    │   │           	└── FruitController.java
    │   │           	└── FruitRepository.java
    │   └── resources
    │       └── static
    │           └── index.html
    └── test
        └── java
            └── com
                └── example
                    └── FruitControllerIntTests.java
```

Except for the `fabric8` directory and the `index.html`, this matches what you would get if you generated an empty project using the [Spring Initializr](https://start.spring.io). For the moment you can ignore the content of the fabric8 folder (we will discuss this later).

One thing that differs slightly is the ``pom.xml``{{open}} file.

 
To leverage Arquillian Cube the project uses the Arquillian Cube BOM provided by the Arquillian Project. Using this BOM ensure access to all of the  dependencies needed to use Arquillian Cube.

```xml
  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>org.arquillian.cube</groupId>
        <artifactId>arquillian-cube-bom</artifactId>
        <version>${version.arquillian-cube.bom}</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
    </dependencies>
  </dependencyManagement>
```

**1. Review the configuration**

The `src/test/resources/arquillian.xml`{{open}} file is used to configure Arquillian. 

```xml
	<extension qualifier="openshift">
		<property name="app.name">fruit</property>
		<property name="namespace.use.existing">fruit</property>
		<property name="env.init.enabled">true</property>
		<property name="cube.fmp.build">true</property>
		<property name="enableImageStreamDetection">false</property>
	</extension>
```

As you can see, the OpenShift extension has been configured to interact with OpenShift. The set of properties configure the extension:

* ``app.name``
* ``namespace.use.existing`` allows you to select an existing namespace. Without this property Arquillian will create a namespace for the tests (e.g., itest-12345)
* ``env.init.enabled`` allows Arquillian to modify the environment, which is being done here by deploying the application and creating routes, etc.
* ``cube.fmp.build`` corresponds to using fabric8 with Arquillian
* ``enableImageStreamDetection`` allows Arquillian to detect an image stream to use.


**2. Review the tests**

As an application is developed and the individual units are tested (e.g. unit testing) the application will eventually require integration tests. To start, this application has a an integration test implemented in the `src/test/java/com/example/FruitControllerIntTest.java`{{open}} class:

```java
@Test
	public void shouldGetAllFruits_Test() {
		when().get().then().statusCode(200).body("name", hasItems("Cherry", "Apple", "Banana"));
	}
```

As you can see the test is calling a web service by invoking an `HTTP GET` using `.get()` and if the invocation is successful, `HTTP Response Code 200`, the body of the response is compared to the expected result. While the JSON below is being returned by the web service and compared, the test perform a direct String comparison because doing so is a fragile testing practice. Instead, the test leverages the [REST Assured](http://rest-assured.io) library (it also makes tests more readable and easier to write!).

```json
[{"id":1,"name":"Cherry"},{"id":2,"name":"Apple"},{"id":3, "name":"Banana"}]
```

>**NOTE:** The \ is an escape character


In addition to the test method above, the test class also contains the following:

```java
@Category(RequiresOpenshift.class)
@RequiresOpenshift
@RunWith(ArquillianConditionalRunner.class)
```

* `@Category(RequiresOpenshift.class)` marks the category of this test class as requiring OpenShift (junit)
* `@RequiresOpenshift` tells Arquillian that this test can only be run on OpenShift
* `@RunWith(ArquillianConditionalRunner.class)` tells Arquillian which test runner should be used


```java
	@AwaitRoute
	@RouteURL("fruit")
	private URL baseURL;

	@Before
	public void setup() throws Exception {
		RestAssured.baseURI = baseURL.toString();
	}
```
* `@AwaitRoute` tells Arquillian to wait until the application has been deployed prior to running the tests
* `@RouteURL("fruit")` tells Arquillian which route to use when constructing the URL used for the web service calls

The `@Before` denotes that the method will be called prior to running each test

>**NOTE:** The Katacoda terminal window is like your local terminal. Everything that you run here you should be able to execute on your local computer as long as you have `Java SDK 1.8` and `Maven` installed. In later steps, we will also use the `oc` command line tool for OpenShift commands.

## Up Next

Now that you have reviewed the project structure, how to configure Arquillian, and how to write a test, it's time to run the tests. In the next step you will deploy the application to OpenShift and run the tests with Arquillian Cube!
