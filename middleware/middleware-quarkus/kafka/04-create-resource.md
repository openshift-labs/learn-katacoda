# Create HTTP resource

Finally, let’s bind our stream to a JAX-RS resource.

Create a final Java class by clicking: `src/main/java/org/acme/people/stream/NameResource.java`{{open}}.

Next, click **Copy to Editor** to add the following code to this file:

<pre class="file" data-filename="./src/main/java/org/acme/people/stream/NameResource.java" data-target="replace">
package org.acme.people.stream;

import org.eclipse.microprofile.reactive.messaging.Channel;

import org.reactivestreams.Publisher;
import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

/**
 * A simple resource retrieving the in-memory "my-data-stream" and sending the items as server-sent events.
 */
@Path("/names")
public class NameResource {

    @Inject
    @Channel("my-data-stream") Publisher&lt;String&gt; names;

    @GET
    @Path("/stream")
    @Produces(MediaType.SERVER_SENT_EVENTS)
    public Publisher&lt;String&gt; stream() {
        return names;
    }
}
</pre>

This method:

  - `@Inject`s the `my-data-stream` stream using the `@Channel` qualifier
  - Indicates that the content is sent (`@Produces`) using *Server Sent Events*
  - Returns the stream (Reactive Stream)

The `process()` method is called for every Kafka record from the `names` topic (configured in the application
configuration which we'll do later). Every result is sent to the my-data-stream in-memory stream.

> In the `src/main/resources/META-INF/resources/index.html`{{open}} page you'll find code
> which will make a request to this `/names/stream` endpoint using standard JavaScript running in the browser and draw
> the resulting names using the [D3.js library](https://d3js.org/). The JavaScript that makes this call looks like this
> (do not copy this into anything\!):
>
> ```javascript
> var source = new EventSource("/names/stream");
>
> source.onmessage = function (event) {
>
>     console.log("received new name: " + event.data);
>     // process new name in event.data
>     // ...
>
>     // update the display with the new name
>     update();
> };
> ```
>  This code:
>
>   - Uses your browser’s support for the `EventSource` API (part of the W3C SSE standard) to call the endpoint
>
>   - Each time a message is received via SSE, *react* to it by running this function
>
>   - Refresh the display using the D3.js library
