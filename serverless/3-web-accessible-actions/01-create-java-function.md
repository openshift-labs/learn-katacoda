# Create the Java Function

**1. Create the Java function**

First we need to create our Java Action using the [Java Action 
Maven Archetype](https://github.com/apache/incubator-openwhisk-devtools/tree/master/java-action-archetype).  In this scenario, we will 
create a simple echo Action that simply returns whatever we send it.  

``cd /root/projects``{{execute}}

Create a Java function project called `my-echo`

```
mvn -q archetype:generate \
    -DarchetypeGroupId=org.apache.openwhisk.java \
    -DarchetypeArtifactId=java-action-archetype \
    -DarchetypeVersion=1.0-SNAPSHOT \
    -DgroupId=com.example \
    -DartifactId=my-echo
```{{execute}}

Move to the project directory

``cd my-echo``{{execute}}

Let's open the Java source file `src/main/java/com/example/FunctionApp.java` to review its contents.  Click the link below
to open the source file in the editor:

``my-echo/src/main/java/com/example/FunctionApp.java``{{open}}

All Java Action classes should have a `main` method with a signature that takes a `com.google.gson.JsonObject` as parameter
and returns a `com.google.gson.JsonObject`.  We need to update the generated function with our desired behavior.  Update the
FunctionApp class with this code:

<pre class="file" data-filename="my-echo/src/main/java/com/example/FunctionApp.java" data-target="replace">
package com.example;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

/**
 * echo FunctionApp
 */
public class FunctionApp {
  public static JsonObject main(JsonObject args) {
    JsonObject response = new JsonObject();
    response.add("response", args);
    return response;
  }
}
</pre>

With the main function updated, now we need to update the tests.

``my-echo/src/test/java/com/example/FunctionAppTest.java``{{open}}

Update the FunctionAppTest class with this code:

<pre class="file" data-filename="my-echo/src/test/java/com/example/FunctionAppTest.java" data-target="replace">
package com.example;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.util.ArrayList;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import org.junit.Test;

/**
 * echo FunctionAppTest
 */
public class FunctionAppTest {
  @Test
  public void testFunction() {
    JsonObject args = new JsonObject();
    args.addProperty("name", "test");
    JsonObject response = FunctionApp.main(args);
    assertNotNull(response);
    String actual = response.get("response").getAsJsonObject().get("name").getAsString();
    assertEquals("test", actual);
  }
}
</pre>

Build the project

``mvn -q package``{{execute}}

`NOTE`: The Java Action maven archetype is not in maven central yet.  If you plan to use it in your local OpenWhisk
environment you then need to build and install from 
[sources](https://github.com/apache/incubator-openwhisk-devtools/tree/master/java-action-archetype).

**2. Deploy the function**

Let's now create a function called `my-echo` in OpenWhisk:

``wsk -i action create --web=true my-echo target/my-echo.jar --main com.example.FunctionApp``{{execute}}

When we create Java function the parameter `--main` is mandatory.  It defines which Java class will be called during OpenWhisk
Action invocation.  The `--web=true` parameter indicates that this action will

**4. Verify the function**

Let's check if the function is created correctly:

``wsk -i action list | grep 'my-echo'``{{execute}}

The output of the command should show something like:

```sh
/whisk.system/my-echo                             private java
```

Once that is done we can invoke our action and verify we get back the correct response:

```
WEB_URL=`wsk -i action get my-echo --url | awk 'FNR==2{print $1}'`
AUTH=`oc get secret whisk.auth -o yaml | grep "system:" | awk '{print $2}'`
```{{execute}}

Running the above commands will help simplify subsequent invocations of our action.  Doing ``echo $WEB_URL``{{execute}} should 
yield a URL that looks like this:

`https://openwhisk-faas.2886795325-80-kitek02.environments.katacoda.com/api/v1/web/whisk.system/default/my-echo`

Using this environment variable will remove the clutter of the full URL with each `curl` and let us do things like:

``curl -k $WEB_URL.json``{{execute}}

Executing the above command will return a JSON payload something like this:

```json
{
  "response": {
    "__ow_method": "get",
    "__ow_headers": {
      "x-forwarded-port": "80",
      "accept": "*/*",
      "forwarded": "for=172.17.0.3;host=openwhisk-faas.2886795325-80-kitek02.environments.katacoda.com;proto=http",
      "user-agent": "curl/7.29.0",
      "x-forwarded-proto": "http",
      "host": "controller.faas.svc.cluster.local:8080",
      "x-scheme": "https://",
      "x-katacoda-host": "kitek02",
      "via": "1.1 google",
      "x-real-ip": "172.17.0.1",
      "x-cloud-trace-context": "c2dea7974f8aa974ca035ee128e79a6c/4529087608544220621",
      "accept-encoding": "gzip",
      "x-forwarded-host": "openwhisk-faas.2886795325-80-kitek02.environments.katacoda.com",
      "x-forwarded-for": "172.17.0.3"
    },
    "__ow_path": ""
  }
}
```

As you can see, we get returned to us the headers we send as part of the `GET` request.  It's hard to tell from the above that's really doing what we want so let's add a little information to our request:

``curl -k $WEB_URL.json?key=value``{{execute}}

In this request, we're simply passing the `key`/`value` pair as part of our URL.  This will give us a response like this:

```json
{
  "response": {
    "__ow_method": "get",
    "__ow_headers": {
      "x-forwarded-port": "80",
      "accept": "*/*",
      "forwarded": "for=172.17.0.3;host=openwhisk-faas.2886795325-80-kitek02.environments.katacoda.com;proto=http",
      "user-agent": "curl/7.29.0",
      "x-forwarded-proto": "http",
      "host": "controller.faas.svc.cluster.local:8080",
      "x-scheme": "https://",
      "x-katacoda-host": "kitek02",
      "via": "1.1 google",
      "x-real-ip": "172.17.0.1",
      "x-cloud-trace-context": "a51436d85f3035d8b3a87e2e6f842922/11418910889981019075",
      "accept-encoding": "gzip",
      "x-forwarded-host": "openwhisk-faas.2886795325-80-kitek02.environments.katacoda.com",
      "x-forwarded-for": "172.17.0.3"
    },
    "__ow_path": "",
    "key": "value"
  }
}
```
Of course, we can also do a `POST` to this URL as well:

``curl --insecure -d '{"key1":"value1", "key2":"value2"}' -H "Content-Type: application/json" -X POST $WEB_URL.json``{{execute}}

This command will return to us the entire JSON document we `POST` here:

```json
{
  "response": {
    "__ow_method": "post",
    "key1": "value1",
    "__ow_headers": {
      "x-forwarded-port": "80",
      "accept": "*/*",
      "forwarded": "for=172.17.0.3;host=openwhisk-faas.2886795325-80-kitek02.environments.katacoda.com;proto=http",
      "user-agent": "curl/7.29.0",
      "x-forwarded-proto": "http",
      "host": "controller.faas.svc.cluster.local:8080",
      "x-scheme": "https://",
      "x-katacoda-host": "kitek02",
      "content-type": "application/json",
      "via": "1.1 google",
      "x-real-ip": "172.17.0.1",
      "x-cloud-trace-context": "9e96faaeb03273c107e167e3bcbe989a/5519046671984655474",
      "accept-encoding": "gzip",
      "x-forwarded-host": "openwhisk-faas.2886795325-80-kitek02.environments.katacoda.com",
      "x-forwarded-for": "172.17.0.3"
    },
    "key2": "value2",
    "__ow_path": ""
  }
}
```
