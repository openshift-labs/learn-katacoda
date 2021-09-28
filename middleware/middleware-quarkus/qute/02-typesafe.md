# Type-safe Templates

There’s an alternate way to declare your templates in your Java code, which relies on the following convention:

* Organise your template files in the `/src/main/resources/templates` directory, by grouping them into one directory per resource class. So, if your `ItemResource` class references two templates `hello` and `goodbye`, place them at `/src/main/resources/templates/ItemResource/hello.txt` and `/src/main/resources/templates/ItemResource/goodbye.txt`. Grouping templates per resource class makes it easier to navigate to them.

* In each of your resource class, declare a `@CheckedTemplate static class Template {}` class within your resource class.

* Declare one `public static native TemplateInstance method();` per template file for your resource.

* Use those static methods to build your template instances.

## Create simple template

Create a directory to hold templates for our HelloResource class:

`cd /root/projects/quarkus/qute && mkdir -p src/main/resources/templates/HelloResource`{{execute T2}}

Next, click to open `qute/src/main/resources/templates/HelloResource/hello.txt`{{open}}. Click **Copy to Editor** to add the code:

<pre class="file" data-filename="./qute/src/main/resources/templates/HelloResource/hello.txt" data-target="replace">
Hello {name} from HelloResource!
</pre>

For Goodbye, click to open `qute/src/main/resources/templates/HelloResource/goodbye.txt`{{open}}. Click **Copy to Editor** to add the code:

<pre class="file" data-filename="./qute/src/main/resources/templates/HelloResource/goodbye.txt" data-target="replace">
Goodbye {name} from GoodbyeResource!
</pre>

Now let’s declare and use those templates in the resource class. Click **Copy to Editor** to update our `HelloResource` class:

<pre class="file" data-filename="./qute/src/main/java/org/acme/HelloResource.java" data-target="replace">
package org.acme;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

import io.quarkus.qute.TemplateInstance;
import io.quarkus.qute.CheckedTemplate;

@Path("hello")
public class HelloResource {

    @CheckedTemplate(requireTypeSafeExpressions = false)
    public static class Templates {
        public static native TemplateInstance hello();
        public static native TemplateInstance goodbye();
    }

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public TemplateInstance get(@QueryParam("name") String name) {
        return Templates.hello().data("name", name);
    }
}
</pre>

* This declares a template with path `templates/HelloResource/hello.txt`, since the `@CheckedTemplate` static class is declared inside the `HelloWorld` class. The name of the method `hello` is used to match files in the directory with common extensions like `.txt`, `.html` etc. You can specify an exact name and path using `@Location`.
* `Templates.hello()` returns a new template instance that can be customized before the actual rendering is triggered. In this case, we put the name value under the key `name`. The data map is accessible during rendering.
* Note that we don’t trigger the rendering - this is done automatically by a special `ContainerResponseFilter` implementation.
* Checked templates require type-safe expressions by default, i.e. expressions that can be validated at build time. It's possible to use `@CheckedTemplate(requireTypeSafeExpressions = false)` to relax this requirement.

> Once you have declared a `@CheckedTemplate` class, we will check that all its methods point to existing templates, so if you try to use a template from your Java code and you forgot to add it, we will let you know at build time :)

Keep in mind this style of declaration allows you to reference templates declared in other resources too.

## Create Goodbye Resource

Let's create another resource and reference our `HelloResource.Templates` static class.

Click to open `qute/src/main/java/org/acme/GoodbyeResource.java`{{open}} then click **Copy to Editor** to create a new resource:

<pre class="file" data-filename="./qute/src/main/java/org/acme/GoodbyeResource.java" data-target="replace">
package org.acme;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

import io.quarkus.qute.TemplateInstance;

@Path("goodbye")
public class GoodbyeResource {

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public TemplateInstance get(@QueryParam("name") String name) {
        return HelloResource.Templates.goodbye().data("name", name);
    }
}
</pre>

## Hello and Goodbye test

Let's test our new endpoints against the running Quarkus application:

`curl http://localhost:8080/hello?name=James`{{execute T2}}

You should see:

```
Hello James from HelloResource!
```

And goodbye:

`curl http://localhost:8080/goodbye?name=James`{{execute T2}}

You should see the same:

```
Goodbye James from GoodbyeResource!
```

As stated earlier, since the `TemplateInstance` is declared as an inner class inside of `HelloResource`, Qute will attempt to locate the template in the `HelloResource/` subdirectory. If instead you want to create a top-level declaration, you can do this inside a separate class (do not copy this code for this exercise):

```java
@CheckedTemplate
public class Templates {
    public static native TemplateInstance hello();
    public static native TemplateInstance goodbye();
}
```
This will cause Qute to look for the associated `hello.txt` or `goodbye.txt` in the `src/main/resources/templates` directory, instead of `src/main/resources/templates/HelloResource`. It is up to you how you wish to organize your templates.

