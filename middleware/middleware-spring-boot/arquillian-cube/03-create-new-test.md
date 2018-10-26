# Creating a New Test

Now it's time to get your hands dirty! The following steps will walk you through adding a test scenario, deploying the application to OpenShift and running the tests with Arquillian Cube.


**1. Add the test**

Add the following test scenario in the `src/test/java/com/example/FruitControllerIntTest.java`{{open}} class:

```java
	@Test
  	public void shouldGetFruitById_Test() {
      when().get("1").then().statusCode(200).body("name", equalTo("Cherry"));
  }
```

In this test you are testing the the web service to retrieve a fruit by an id is available. The test is calling a web service by invoking an `HTTP GET` using `.get()` and if the invocation is successful, `HTTP Response Code 200`, the body of the response is compared to the expected result.

```json
{"id":1,"name":"Cherry"}
```

**2. Run the integration tests**

Run the following command to deploy the application to OpenShift and run the integration tests:

``mvn clean package -Popenshift``{{execute}}

>**NOTE:** The building, deploying, and testing of the application may take a few minutes


## Congratulations

You have now learned how to run an integration test using Arquillian Cube on OpenShift!