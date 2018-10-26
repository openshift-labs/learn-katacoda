# Custom Error Pages

By default, if an unrecoverable error occurs, Spring Boot will return a White-label page provided by the framework. While this is fine for initial development it is generally considered good practice to provide your own error page. Whether to hide technical information or to style according to your business, a custom error page is typically recommended.

**1. Adding a Custom Error Page**

Because we have Thymeleaf in the project there is a pretty simple approach to custom error pages. Spring Boot will automatically use a Thymeleaf View named `error.html` if it resides in the `src/main/resources/templates` folder. This is a convention of Spring Boot and Thymeleaf that enabled auto-configuration on Spring Boot's side. Open the ``src/main/resources/templates/error.html``{{open}} empty file and copy the following content into the file (or use the `Copy to Editor` button):

<pre class="file" data-filename="src/main/resources/templates/error.html" data-target="replace">
&lt;!doctype html&gt;
&lt;html xmlns:th="http://www.thymeleaf.org"&gt;
&lt;head&gt;
    &lt;meta charset="utf-8"/&gt;
    &lt;title&gt;MVC Mission - Spring Boot&lt;/title&gt;
    &lt;link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/wingcss/0.1.8/wing.min.css"/&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;div class="container"&gt;
    &lt;h1&gt;An Error Occurred&lt;/h1&gt;
    &lt;table&gt;
        &lt;tr&gt;
            &lt;td&gt;Date&lt;/td&gt;
            &lt;td th:text="${timestamp}"/&gt;
        &lt;/tr&gt;
        &lt;tr&gt;
            &lt;td&gt;Path&lt;/td&gt;
            &lt;td th:text="${path}"/&gt;
        &lt;/tr&gt;
        &lt;tr&gt;
            &lt;td&gt;Error&lt;/td&gt;
            &lt;td th:text="${error}"/&gt;
        &lt;/tr&gt;
        &lt;tr&gt;
            &lt;td&gt;Status&lt;/td&gt;
            &lt;td th:text="${status}"/&gt;
        &lt;/tr&gt;
        &lt;tr&gt;
            &lt;td&gt;Message&lt;/td&gt;
            &lt;td th:text="${message}"/&gt;
        &lt;/tr&gt;
        &lt;tr&gt;
            &lt;td&gt;Exception&lt;/td&gt;
            &lt;td th:text="${exception}"/&gt;
        &lt;/tr&gt;
        &lt;tr&gt;
            &lt;td&gt;Trace&lt;/td&gt;
            &lt;td&gt;
                &lt;pre th:text="${trace}"/&gt;
            &lt;/td&gt;
        &lt;/tr&gt;
    &lt;/table&gt;
&lt;/div&gt;
&lt;/body&gt;
&lt;/html&gt;
</pre>

While this doesn't solve the issue of hiding sensitive information it does preview Views with Thymeleaf and that Spring Boot passes some useful information to these views. We simply use Thymeleaf and model variables to access them. Thymeleaf will be covered more in the next couple steps.

**2. Test the Error Page**

Run the application again by executing the following command:

``mvn spring-boot:run``{{execute}}

>**NOTE:** The Katacoda terminal window is like your local terminal. Everything that you run here you should be able to execute on your local computer as long as you have `Java SDK 1.8` and `Maven` installed. In later steps, we will also use the `oc` command line tool for OpenShift commands.

**3. Verify the application**

If you click on the **Local Web Browser** tab again in the console frame of this browser window or use [this](https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/) link, you should now see a custom page with a table containing all available error information. These variables can be used selectively to only display relevant information to the user.

**4. Stop the application**

Before moving on, click in the terminal window and then press **CTRL-C** to stop the running application!

## Congratulations

Now you've seen how to get started with Spring Boot development on Red Hat OpenShift Application Runtimes. In the next step you will create the Model and Controller portions of the web application.
