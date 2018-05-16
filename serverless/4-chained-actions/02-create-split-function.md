# Create the Split Action

For the first step in our sequence, we'll use a Java Action to take in a comma delimited list of words and split it around those commas.


**1. Create the Java Action**

Next, it's time to create the Java Action to do the first step in our sequence.  This Action can be created using the [Java Action 
Maven Archetype](https://github.com/apache/incubator-openwhisk-devtools/tree/master/java-action-archetype).  

``cd /root/projects``{{execute}}

Create a Java Action project called `splitter`

```
mvn -q archetype:generate \
    -DarchetypeGroupId=org.apache.openwhisk.java \
    -DarchetypeArtifactId=java-action-archetype \
    -DarchetypeVersion=1.0-SNAPSHOT \
    -DgroupId=com.example \
    -DartifactId=splitter
```{{execute}}

Move to the project directory

``cd splitter``{{execute}}

Let's open the Java source file `src/main/java/com/example/FunctionApp.java` to review its contents.  **Click 
the link below** to open the source file in the editor:

``splitter/src/main/java/com/example/FunctionApp.java``{{open}}

All OpenWhisk Java Action classes should have a `main` method with a signature that takes a `com.google.gson.JsonObject` as a
parameter and returns a `com.google.gson.JsonObject`.  We need to update the generated Action with our desired behavior.  Update
the FunctionApp class with this code by clicking on the **Copy to Editor** button below:

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

With the main Action updated, now we need to update the tests. **Click on the link below** to open the file in the editor:

``splitter/src/test/java/com/example/FunctionAppTest.java``{{open}}

Update the FunctionAppTest class by clicking on the **Copy to Editor** button below:

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

``mvn -q package``{{execute}}

`NOTE`: The Java Action maven archetype is not in maven central yet.  If you plan to use it in your local OpenWhisk environment
you will need to build and install from [sources](https://github.com/apache/incubator-openwhisk-devtools/tree/master/java-action-archetype).

**2. Deploy the Action**

Let's now create a Action called `splitter` in OpenWhisk:

``wsk -i action create sequence/splitter target/splitter.jar --main com.example.FunctionApp``{{execute}}

When we create Java Action the parameter `--main` is mandatory.  It defines which Java class will be called during OpenWhisk
Action invocation.

**4. Verify the Action**

Let's check if the Action is created correctly:

``wsk -i action list | grep sequence``{{execute}}

The output of the command should show something like:

```sh
/whisk.system/sequence/splitter                             private java
```

Now we can invoke the action and see that it's working:

``wsk -i action invoke sequence/splitter --result --param text "zebra,cat,antelope" | tee ~/split.json``{{execute}}

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

Note that we have piped the results through the `tee` command so we can store the results to help us verify the next step in our chain.

# Next

We now have the first step in our sequence defined and running.  The next step is the sort stage.
