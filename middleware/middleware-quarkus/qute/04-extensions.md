# Template Extension Methods

**Template extension methods** are used to extend the set of accessible properties of data objects.

Sometimes, you’re not in control of the classes that you want to use in your template, and you cannot add methods to them. Template extension methods allows you to declare new method for those classes that will be available from your templates just as if they belonged to the target class.

Let’s keep extending on our simple HTML page that contains the item name, price and add a discounted price. The discounted price is sometimes called a "computed property". We will implement a template extension method to render this property easily. Let’s update our template. Click **Copy to Editor** to update the template with computed properties:

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
    {#if item.price &gt; 100}
    &lt;div&gt;Discounted Price: {item.discountedPrice}&lt;/div&gt;
    {/if}
&lt;/body&gt;
&lt;/html&gt;
</pre>

Notice the use of Handlebar-esque `{#if ...}`. It's part of Qute's basic control flow features.

Also notice the use of `{item.discountedPrice}`. This field does not exist in our `Item` class (which only has `name` and `price`). We'll add an _extension_ to our java code to make this property be available to the template, and write the code that computes its value in Java.

Click `qute/src/main/java/org/acme/TemplateExtensions.java`{{open}} to open the new file.

Click **Copy to Editor** to create the extensions class where we'll declare our `discountedPrice`:

<pre class="file" data-filename="./qute/src/main/java/org/acme/TemplateExtensions.java" data-target="replace">
package org.acme;

import java.math.BigDecimal;
import io.quarkus.qute.TemplateExtension;

@TemplateExtension
public class TemplateExtensions {

    public static BigDecimal discountedPrice(Item item) {
        return item.price.multiply(new BigDecimal("0.9"));
    }
}
</pre>

Here we declare a static template extension method that can be used to add "computed properties" to a data class. The class of the first parameter (in this case `Item`) is used to match the base object and the method name is used to match the property name (in this case `discountedPrice`). When we declare `{item.discountedPrice}`, the contextual value of `item` is passed to this `discountedPrice` method to compute its value (where we use the `item.price.multiply()` method to apply a 10% discount by multiplying by `0.9`).

> You can place template extension methods in every class if you annotate them with `@TemplateExtension` but we advise to keep them either grouped by target type, or in a single `TemplateExtensions` class by convention.

[Click here](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/item/1) to reload the page and see the result for Apples:

![Apple](/openshift/assets/middleware/quarkus/qute-apple.png)

Since Apples cost less than $100, no discount for you (you won't see the discounted price)! But [try with Mangos](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/item/4).

![Mango](/openshift/assets/middleware/quarkus/qute-mango.png)

What a deal!

