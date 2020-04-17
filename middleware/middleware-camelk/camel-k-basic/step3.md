## Applying configuration and routing

This step shows how to configure the integration using external properties with simple content-based router.
Go to the text editor on the right, under the folder /root/camel-basic. Right click on the directory and choose New -> File and name it `Routing.java`

Paste the following code into the application.

<pre class="file" data-filename="Routing.java" data-target="replace">
// camel-k: language=java

import java.util.Random;

import org.apache.camel.PropertyInject;
import org.apache.camel.builder.RouteBuilder;

public class Routing extends RouteBuilder {

  private Random random = new Random();

  @PropertyInject("priority-marker")
  private String priorityMarker;

  @Override
  public void configure() throws Exception {



      from("timer:java?period=3000")
        .id("generator")
        .bean(this, "generateRandomItem({{items}})")
        .choice()
          .when().simple("${body.startsWith('{{priority-marker}}')}")
            .transform().body(String.class, item -> item.substring(priorityMarker.length()))
            .to("direct:priorityQueue")
          .otherwise()
            .to("direct:standardQueue");

      from("direct:standardQueue")
        .id("standard")
        .log("Standard item: ${body}");

      from("direct:priorityQueue")
        .id("priority")
        .log("!!Priority item: ${body}");

  }

  public String generateRandomItem(String items) {
    if (items == null || items.equals("")) {
      return "[no items configured]";
    }
    String[] list = items.split("\\s");
    return list[random.nextInt(list.length)];
  }

}

</pre>

The `Routing.java` file shows how to inject properties into the routes via property placeholders and also the usage of the `@PropertyInject` annotation.
The routes use two configuration properties named `items` and `priority-marker` that should be provided using an external file such as the `routing.properties`

Go to the text editor on the right, under the folder /root/camel-basic. Right click on the directory and choose New -> File and name it `routing.properties`

<pre class="file" data-filename="routing.properties" data-target="replace">
# List of items for random generation
items=*radiator *engine door window *chair

# Marker to identify priority items
priority-marker=*
</pre>

To run the integration, we should link the integration to the property file providing configuration for it:

``kamel run camel-basic/Routing.java --property-file  camel-basic/routing.properties --dev``{{execute}}
Once it started. You can find the pod running this Routing application in the terminal.

```
[1] 2020-04-17 03:35:40.528 INFO  [Camel (camel-k) thread #1 - timer://java] standard - Standard item: door
[1] 2020-04-17 03:35:43.532 INFO  [Camel (camel-k) thread #1 - timer://java] standard - Standard item: door
[1] 2020-04-17 03:35:46.538 INFO  [Camel (camel-k) thread #1 - timer://java] priority - !!Priority item: engine
[1] 2020-04-17 03:35:49.526 INFO  [Camel (camel-k) thread #1 - timer://java] standard - Standard item: door
[1] 2020-04-17 03:35:52.532 INFO  [Camel (camel-k) thread #1 - timer://java] priority - !!Priority item: chair
[1] 2020-04-17 03:35:55.532 INFO  [Camel (camel-k) thread #1 - timer://java] priority - !!Priority item: radiator
[1] 2020-04-17 03:35:58.529 INFO  [Camel (camel-k) thread #1 - timer://java] priority - !!Priority item: chair
[1] 2020-04-17 03:36:01.527 INFO  [Camel (camel-k) thread #1 - timer://java] standard - Standard item: door
[1] 2020-04-17 03:36:04.536 INFO  [Camel (camel-k) thread #1 - timer://java] standard - Standard item: window
[1] 2020-04-17 03:36:07.541 INFO  [Camel (camel-k) thread #1 - timer://java] priority - !!Priority item: radiator
```

Now make some changes to the property file and see the integration redeployed.
For example, change the word `door` with `*door` to see it sent to the priority queue.


Hit `ctrl+c` on the terminal window.This will also terminate the execution of the integration.
