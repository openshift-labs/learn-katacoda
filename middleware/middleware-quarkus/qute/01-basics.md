# Inspect Java runtime

An appropriate Java runtime has been installed for you. Ensure you can use it by running this command:

> If the command fails, wait a few moments and try again (it is installed in a background process and make take a few moments depending on system load).

`$JAVA_HOME/bin/java --version`{{execute}}

The command should report the version in use, for example (the versions and dates may be slightly different than the below example):

```console
openjdk 11.0.10 2021-01-19
OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.10+9)
OpenJDK 64-Bit Server VM AdoptOpenJDK (build 11.0.10+9, mixed mode)
```
## Create sample project

Let's create the basic Quarkus _Hello World_ application and include the necessary qute extensions. Click this command to create the project:

`cd /root/projects/quarkus &&
 mvn io.quarkus:quarkus-maven-plugin:2.0.0.Final:create \
    -DprojectGroupId=org.acme \
    -DprojectArtifactId=qute \
    -Dextensions="quarkus-resteasy-qute,quarkus-vertx-web,quarkus-qute,quarkus-scheduler"`{{execute T1}}

> The first time you create an app, new dependencies may be downloaded via maven and take a minute or so. This should only happen once, after that things will go even faster.

This will use the Quarkus Maven Plugin and generate a sample Qute project for you in the `qute` subdirectory and include the `quarkus-resteasy-qute` extension which includes the templating engine and integration with JAX-RS via RestEasy. We've also included a few other extensions we'll use later on.

Once generated, look at the `qute/pom.xml`{{open}}. You will find the import of the Quarkus BOM, allowing to omit the version on the different Quarkus dependencies.

## Start the app

Let's begin Live Coding. Click on the following command to start the example app in _Live Coding_ mode:

`cd /root/projects/quarkus/qute && \
  mvn quarkus:dev -Dquarkus.http.host=0.0.0.0`{{execute T1}}

You should see:

```console
__  ____  __  _____   ___  __ ____  ______
 --/ __ \/ / / / _ | / _ \/ //_/ / / / __/
 -/ /_/ / /_/ / __ |/ , _/ ,< / /_/ /\ \
--\___\_\____/_/ |_/_/|_/_/|_|\____/___/
INFO  [io.quarkus] (Quarkus Main Thread) qute 1.0.0-SNAPSHOT on JVM (powered by Quarkus x.xx.x.Final) started in x.xxxs. Listening on: http://0.0.0.0:8080
INFO  [io.quarkus] (Quarkus Main Thread) Profile dev activated. Live Coding activated.
INFO  [io.quarkus] (Quarkus Main Thread) Installed features: [cdi, mutiny, qute, resteasy, resteasy-qute, scheduler, smallrye-context-propagation, vertx, vertx-web]
```

> The first time you build the app, new dependencies may be downloaded via maven. This should only happen once, after that things will go even faster.

Note the amazingly fast startup time! The app is now running "locally" (within the Linux container in which this exercise runs).

Test that the app is running by accessing the sample page [using this link](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/some-page). You should see

![Qute sample](/openshift/assets/middleware/quarkus/qute-sample.png)

This page is rendered using the `qute/src/main/resources/templates/page.qute.html`{{open}} HTML template. If you look closely you can see a `{name ?: "Qute"}` directive that renders the passed-in `name` query present in the `qute/src/main/java/org/acme/SomePage.java` class and passed into the template renderer in the `data()` method, making the `name` variable available to the renderer and returning the rendered HTML to your browser. If you pass a different name, say, `Jerry` using [this link](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/some-page?name=Jerry) (which adds `?name=Jerry` to the URL) you'll see the new name rendered via the Qute template:

![Qute sample](/openshift/assets/middleware/quarkus/qute-sample-jerry.png)

Let's keep the app running and continue using Quarkus' _Live Coding_ feature. Changes you make are immediately available in the running app when developing Quarkus apps.

## Create basic template

We’ll start by creating a new and very simple text-based template.

Click `qute/src/main/resources/templates/hello.txt`{{open}} to create an empty template file.

Finally, click the **Copy to Editor** to add the template code:

<pre class="file" data-filename="./qute/src/main/resources/templates/hello.txt" data-target="replace">
Hello {name}!
</pre>

* `{name}` is a _value expression_ that is evaluated when the template is rendered.

> By default, all files located in the `src/main/resources/templates` directory and its
> subdirectories are registered as templates. Templates are validated during startup
> and watched for changes in the development mode.

## Create REST endpoint to access template

Now let’s inject the "compiled" template in the resource class.

Click here to open `qute/src/main/java/org/acme/HelloResource.java`{{open}}.

Click the **Copy to Editor** to update our `HelloResource` class:

<pre class="file" data-filename="./qute/src/main/java/org/acme/HelloResource.java" data-target="replace">
package org.acme;

import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

import io.quarkus.qute.TemplateInstance;
import io.quarkus.qute.Template;

@Path("hello")
public class HelloResource {

    @Inject
    Template hello;

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public TemplateInstance get(@QueryParam("name") String name) {
        return hello.data("name", name);
    }
}
</pre>

* If there is no `@ResourcePath` qualifier provided when `@Inject`ing, the field name is used to locate the template. In this particular case, we’re injecting a template with path `templates/hello.txt`.
* `Template.data()` returns a new template instance that can be customized before the actual rendering is triggered. In this case, we put the name value under the key `name`. The data map is accessible during rendering.
* Note that we don’t trigger the rendering - this is done automatically by a special `ContainerResponseFilter` implementation.

## Test endpoint

With our application already running in _Live Coding_ mode, we can render the template by calling the endpoint. Click the command below to test it:

`curl http://localhost:8080/hello?name=James`{{execute T2}}

You should see:

```
Hello James!
```
The template was _rendered_, replacing the `{name}` expression with the value passed in with `hello.data("name", name);`

This is the basic syntax and idea, which originated with other popular and well-known technologies:

* The [syntax](https://quarkus.io/guides/qute-reference#syntax-and-building-blocks) is mainly inspired by [Handlebars](https://handlebarsjs.com/) and [Dust.js](https://www.dustjs.com/).
* [Template inheritance](https://quarkus.io/guides/qute-reference#include_helper) is inspired by [Facelets](https://en.wikipedia.org/wiki/Facelets) and [Django](https://docs.djangoproject.com/en/3.0/ref/templates/language/).
* Qute supports the [elvis operator](https://en.wikipedia.org/wiki/Elvis_operator) you might be familiar with from [Groovy](https://groovy-lang.org/) and [Kotlin](https://kotlinlang.org/).
* [Extension methods](https://quarkus.io/guides/qute-reference#template_extension_methods) that can be used to extend the data classes with new functionality are also inspired by modern languages.
* If you come from the world of JSP/JSF/Facelets you’ll appreciate that `@Named` CDI beans can be referenced directly in any template through the `inject` namespace, e.g. `{inject:foo.price}`. See [Injecting Beans Directly In Templates](https://quarkus.io/guides/qute-reference#injecting-beans-directly-in-templates) for more information.

Let's now explore some new features based on Quarkus principles.