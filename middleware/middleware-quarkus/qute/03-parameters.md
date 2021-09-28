# Template Parameter Declarations

If you declare a parameter declaration in a template, Qute will attempt to validate all expressions that reference this parameter. If an incorrect expression is found the build wil fail. This can greatly reduce developer errors up front. Let's exercise this.

Create a simple class with two fields by clicking `qute/src/main/java/org/acme/Item.java`{{open}} to open the file then click **Copy to Editor**:

<pre class="file" data-filename="./qute/src/main/java/org/acme/Item.java" data-target="replace">
package org.acme;

import java.math.BigDecimal;

public class Item {
    public String name;
    public BigDecimal price;

    public Item(BigDecimal price, String name) {
        this.price = price;
        this.name = name;
    }
}
</pre>

This is a simple `Item` object with two fields (`name` and `price`).

## Create Template

Now, suppose we want to render a simple HTML page that contains the item name and price. First, create a directory by clicking:

`mkdir -p src/main/resources/templates/ItemResource`{{execute T2}}

Create a Qute template at by clicking `qute/src/main/resources/templates/ItemResource/item.html`{{open}} then click the **Copy to Editor** button:

<pre class="file" data-filename="./qute/src/main/resources/templates/ItemResource/item.html" data-target="replace">
&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset=&quot;UTF-8&quot;&gt;
&lt;title&gt;{item.name}&lt;/title&gt;
&lt;/head&gt;
&lt;body&gt;
    &lt;h1&gt;{item.name}&lt;/h1&gt;
    &lt;div&gt;Price: {item.price}&lt;/div&gt;
&lt;/body&gt;
&lt;/html&gt;
</pre>

## Create Service

And create a simple `ItemService` to mock up a database of items. Click `qute/src/main/java/org/acme/ItemService.java`{{open}} to open the file, then click **Copy To Editor**:

<pre class="file" data-filename="./qute/src/main/java/org/acme/ItemService.java" data-target="replace">
package org.acme;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;
import javax.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class ItemService {

    private Map&lt;Integer, Item&gt; items = Map.of(
        1, new Item(new BigDecimal(1.99), &quot;Apple&quot;),
        2, new Item(new BigDecimal(2.99), &quot;Pear&quot;),
        3, new Item(new BigDecimal(3.99), &quot;Grape&quot;),
        4, new Item(new BigDecimal(129.99), &quot;Mango&quot;)
    );

    public Item findItem(int id) {
        return items.get(id);
    }
}
</pre>

## Create REST endpoint

Now create a resource class that uses this type-safe template. Click `qute/src/main/java/org/acme/ItemResource.java`{{open}} to open the file, then click **Copy To Editor**:

<pre class="file" data-filename="./qute/src/main/java/org/acme/ItemResource.java" data-target="replace">
package org.acme;

import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import io.quarkus.qute.TemplateInstance;
import io.quarkus.qute.CheckedTemplate;

@Path("item")
public class ItemResource {

    @Inject
    ItemService service;

    @CheckedTemplate
    public static class Templates {
        public static native TemplateInstance item(Item item);
    }

    @GET
    @Path("{id}")
    @Produces(MediaType.TEXT_HTML)
    public TemplateInstance get(@PathParam("id") Integer id) {
        return Templates.item(service.findItem(id));
    }
}
</pre>

Here we Declare a static `Templates` inner class with a method called `item()` that gives us a `TemplateInstance` for `templates/ItemResource/item.html` and declare its `Item item` parameter so we can validate the template.

We then pass the value of `id` to be used to render the template when the REST endpoint is called. Let's try it:

`curl http://localhost:8080/item/1`{{execute T2}}

You should see an HTML result that shows Apple (`id=1`) and its price:

```html
<body>
    <h1>Apple</h1>
    <div>Price: 1.9899999999999999911182158029987476766109466552734375</div>
</body>
```

You can also [click here](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/item/1) to see an actual HTML rendering in your browser:

![Apple](/openshift/assets/middleware/quarkus/qute-apple.png)

## Template parameter declaration inside the template

Alternatively, to declare that a template is expecting an `Item` type, you can declare it in the template file itself to add additional type and parameter checking and simplify the code while still maintaining type checking. Let's update our HTML template a bit. Click **Copy to Editor** to update the template:

<pre class="file" data-filename="./qute/src/main/resources/templates/ItemResource/item.html" data-target="replace">
{@org.acme.Item item}
&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset=&quot;UTF-8&quot;&gt;
&lt;title&gt;{item.name}&lt;/title&gt;
&lt;/head&gt;
&lt;body&gt;
    &lt;h1&gt;{item.name}&lt;/h1&gt;
    &lt;div&gt;Price: {item.price}&lt;/div&gt;
&lt;/body&gt;
&lt;/html&gt;
</pre>

Notice the first line - this ia an _optional_ parameter declaration. If declared, Qute attempts to validate all expressions that reference the parameter `item`.

Now update the resource class to use the simpler way to inject templates:

<pre class="file" data-filename="./qute/src/main/java/org/acme/ItemResource.java" data-target="replace">
package org.acme;

import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import io.quarkus.qute.TemplateInstance;
import io.quarkus.qute.Location;
import io.quarkus.qute.Template;

@Path("item")
public class ItemResource {

    @Inject
    ItemService service;

    @Inject
    @Location("ItemResource/item")
    Template item;

    @GET
    @Path("{id}")
    @Produces(MediaType.TEXT_HTML)
    public TemplateInstance get(@PathParam("id") Integer id) {
        return item.data("item", service.findItem(id));
    }
}
</pre>

Test it out again using the same process: [click here](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/item/1) to see an actual HTML rendering in your browser:

![Apple](/openshift/assets/middleware/quarkus/qute-apple.png)

It's the same value, but with additional checking in the template itself. If you made any errors, you'll see it immediately in the rendered output (the live coding rebuild will fail).

If you did not see errors, congratulations! But let's see what happens if we do. Click here: `qute/src/main/resources/templates/ItemResource/item.html`{{open}} to open the template. Change `{item.name}` to `{item.nonSense}`. Now click here to [reload](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/item/1). You should get an error:

![Err](/openshift/assets/middleware/quarkus/qute-err.png)

Qute checks the syntax and will fail the build (and result in a prettified HTML error screen) when syntax errors are detected in the template. This makes it very easy to quickly iterate, update code and template, and see the results.

# Before moving on

Be sure to change the value back to `{item.name}`!

