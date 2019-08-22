# Create name generator

To start building the app, create a new Java class by clicking: `src/main/java/org/acme/people/stream/NameGenerator.java`{{open}}.

Next, click **Copy to Editor** to add the following code to this file:

<pre class="file" data-filename="./src/main/java/org/acme/people/stream/NameGenerator.java" data-target="replace">
package org.acme.people.stream;

import io.reactivex.Flowable;
import javax.enterprise.context.ApplicationScoped;
import org.acme.people.utils.CuteNameGenerator;
import org.eclipse.microprofile.reactive.messaging.Outgoing;
import java.util.concurrent.TimeUnit;

@ApplicationScoped
public class NameGenerator {

    @Outgoing("generated-name")           
    public Flowable&lt;String&gt; generate() {  
        return Flowable.interval(5, TimeUnit.SECONDS)
                .map(tick -> CuteNameGenerator.generate());
    }

}
</pre>

This simple method:

* Instructs Reactive Messaging to dispatch the items from returned stream to `generated-name`
* Returns an [RX Java 2 stream](https://github.com/ReactiveX/RxJava) (`Flowable`) emitting a random name every 5 seconds

The method returns a Reactive Stream. The generated items are sent to the stream named `generated-name`. This stream is
mapped to Kafka using the application.properties file that we will create soon.
