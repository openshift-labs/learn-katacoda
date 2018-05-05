# Create the Split Function

For the first step in our sequence, we'll use a Java function to take in a comma delimited list of words and split it around those commas.


**1. Create the Java function**

Next, it's time to create the Java Action to do the first step in our sequence.  This function can be created using the [Java Action 
Maven Archetype](https://github.com/apache/incubator-openwhisk-devtools/tree/master/java-action-archetype).  

``cd /root/projects``{{execute}}

Create a Java function project called `splitter`

```
mvn archetype:generate \
    -DarchetypeGroupId=org.apache.openwhisk.java \
    -DarchetypeArtifactId=java-action-archetype \
    -DarchetypeVersion=1.0-SNAPSHOT \
    -DgroupId=com.example \
    -DartifactId=splitter
```{{execute}}

Move to the project directory

``cd splitter``{{execute}}

Let's open the Java source file `src/main/java/com/example/FunctionApp.java` to review its contents.  Click the link below to open the source file in the editor:

``splitter/src/main/java/com/example/FunctionApp.java``{{open}}

All OpenWhisk Java function classes should have a `main` method with a signature that takes a `com.google.gson.JsonObject` as parameter and returns a `com.google.gson.JsonObject`.
We need to update the generated function with our desired behavior.  Update the FunctionApp class with this code:

<pre class="file" data-filename="splitter/src/main/java/com/example/FunctionApp.java" data-target="replace">
package com.example;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

/**
 * Splitter FunctionApp
 */
public class FunctionApp {
  public static JsonObject main(JsonObject args) {
    JsonObject response = new JsonObject();
    String text = null;
    if (args.has("text")) {
      text = args.getAsJsonPrimitive("text").getAsString();
    }
    String[] results = new String[] { text };
    if (text != null && text.indexOf(",") != -1) {
      results = text.split(",");
    }
    JsonArray splitStrings = new JsonArray();
    for (String var : results) {
      splitStrings.add(var);
    }
    response.add("result", splitStrings);
    return response;
  }
}
</pre>

With the main function updated, now we need to update the tests.

``splitter/src/test/java/com/example/FunctionAppTest.java``{{open}}

Update the FunctionAppTest class with this code:

<pre class="file" data-filename="splitter/src/test/java/com/example/FunctionAppTest.java" data-target="replace">
package com.example;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.util.ArrayList;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import org.junit.Test;

/**
 * Splitter FunctionAppTest
 */
public class FunctionAppTest {
  @Test
  public void testFunction() {
    JsonObject args = new JsonObject();
    args.addProperty("text", "apple,orange,banana");
    
    JsonObject response = FunctionApp.main(args);
    assertNotNull(response);
    
    JsonArray results = response.getAsJsonArray("result");
    assertNotNull(results);
    assertEquals(3, results.size());
    
    ArrayList<String> actuals = new ArrayList<>();
    results.forEach(j -> actuals.add(j.getAsString()));
    assertTrue(actuals.contains("apple"));
    assertTrue(actuals.contains("orange"));
    assertTrue(actuals.contains("banana"));
  }
}
</pre>

Build the project

``mvn clean package``{{execute}}

`NOTE`: The Java Action maven archetype is not in maven central yet.  If you plan to use it in your local OpenWhisk environment you then need to build and install from [sources](https://github.com/apache/incubator-openwhisk-devtools/tree/master/java-action-archetype).

**2. Deploy the function**

Let's now create a function called `splitter` in OpenWhisk:

``wsk -i action create sequence/splitter target/splitter.jar --main com.example.FunctionApp``{{execute}}

When we create Java function the parameter `--main` is mandatory.  It defines which Java class will be called during OpenWhisk Action invocation.

**4. Verify the function**

Let's check if the function is created correctly:

``wsk -i action list | grep 'splitter'``{{execute}}

The output of the command should show something like:

```sh
/whisk.system/sequence/splitter                             private java
```

Now we can invoke the action and see that it's working:

``wsk -i action invoke sequence/splitter --result --param text "zebra,cat,antelope"``{{execute}}

Executing the above command should return us this JSON payload:

```json
{
    "result": [
        "zebra",
        "cat",
        "antelope"
    ]
}
```

# Next

We now have the first step in our sequence defined and running.  The next step is the sort stage.
