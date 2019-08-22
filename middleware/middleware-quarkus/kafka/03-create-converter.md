# Create name converter

The name converter reads the names from Kafka, and transforms them, adding a random (English) honorific to the beginning of the name.

Create a new Java class by clicking: `src/main/java/org/acme/people/stream/NameConverter.java`{{open}}.

Next, click **Copy to Editor** to add the following code to this file:

<pre class="file" data-filename="./src/main/java/org/acme/people/stream/NameConverter.java" data-target="replace">
package org.acme.people.stream;

import javax.enterprise.context.ApplicationScoped;
import org.eclipse.microprofile.reactive.messaging.Incoming;
import org.eclipse.microprofile.reactive.messaging.Outgoing;
import io.smallrye.reactive.messaging.annotations.Broadcast;

@ApplicationScoped
public class NameConverter {

    private static final String[] honorifics = {"Mr.", "Mrs.", "Sir", "Madam", "Lord", "Lady", "Dr.", "Professor", "Vice-Chancellor", "Regent", "Provost", "Prefect"};

    @Incoming("names")               
    @Outgoing("my-data-stream")      
    @Broadcast                       
    public String process(String name) {
        String honorific = honorifics[(int)Math.floor(Math.random() * honorifics.length)];
        return honorific + " " + name;
    }
}
</pre>

This simple method:

* Consumes the items from the `names` topic using `@Incoming`
* Adds an _honorific_ to the start of each name in the stream
* Sends the resulting `@Outgoing` stream to all _subscribers_ (`@Broadcast`) of the in-memory `my-data-stream` stream

The `process()` method is called for every Kafka record from the `names` topic (configured in the application
configuration which we'll do later). Every result is sent to the my-data-stream in-memory stream.
