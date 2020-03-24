In the previous step you've created a skeleton Kogito application with Quarkus and opened a simple BPMN file with the [Kogito Online Tooling](https://kiegroup.github.io/kogito-online/#/). In this step we'll create the CDI bean that implements the functionality of our BPMN2 _Service Task_.

## Create a CDI bean.

To create a new CDI bean, we simply create a new Java file in our `src/main/java/org/acme` folder.

Open a new Java file by clicking: `service-task-cdi/src/main/java/org/acme/TextProcessor.java`{{open}}

We can now add the class definition to our Java file. Click on the _Copy to Editor_ link to copy the content below to the file you've just created.

<pre class="file" data-filename="./service-task-cdi/src/main/java/org/acme/TextProcessor.java" data-target="replace">
package org.acme;

import javax.enterprise.context.ApplicationScoped;

/**
 * TextProcessor
 */
//Add CDI annotation here
public class TextProcessor {

//Add toUpper method here

}
</pre>


First, we want to implement our logic. Our process needs to convert all text that is passed to it to uppercase.
Therefore, we create a method that accepts a `String` as input, and returns the converted `String` as its output.
We will call the method `toUpper`.

<pre class="file" data-filename="./service-task/src/main/java/org/acme/TextProcessor.java" data-target="insert" data-marker="//Add toUpper method here">
  public String toUpper(String text) {
    return text.toUpperCase();
  }
</pre>

Finally, we need to add the `@ApplicationScoped` CDI annotation to turn our Java bean into a CDI bean.

<pre class="file" data-filename="./service-task/src/main/java/org/acme/TextProcessor.java" data-target="insert" data-marker="//Add CDI annotation here">
@ApplicationScoped</pre>

Since we still have our app running using `mvn quarkus:dev`, when you make these changes and reload the endpoint, Quarkus will notice all of these changes and live-reload them.


## Congratulations!

You've implemented a CDI bean in your Kogito application that can be used as the implementation of a BPMN2 _Service Task_.
