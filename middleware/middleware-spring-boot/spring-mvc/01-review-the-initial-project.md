# Review the base structure of the application

For your convenience, this scenario has been created with a base project using the Java programming language and the Apache Maven build tool. 

**1. Adding Spring MVC to the application**

Since our application will be a web application we need to use a servlet container like Apache Tomcat or Undertow to handle incoming connections from clients. Since Red Hat offers support for Apache Tomcat (e.g., security patches, bug fixes, etc.) we will use it here. 

>**NOTE:** Undertow is another an open source project that is maintained by Red Hat and therefore Red Hat plans to add support for Undertow shortly.

Spring Boot has a pre-packaged POM (called a Starter POM) for the Spring MVC dependencies. This POM bundles everything you need to work with Spring MVC in a Boot application including an embedded Tomcat container. To add Spring MVC to our project, add the following lines in the ``pom.xml``{{open}} (If you left the TODO comments in you can click the `Copy to Editor` button to do this automatically)

<pre class="file" data-filename="pom.xml" data-target="insert" data-marker="<!-- TODO: Add web dependencies here -->">
    &lt;dependency&gt;
      &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
      &lt;artifactId&gt;spring-boot-starter-web&lt;/artifactId&gt;
    &lt;/dependency&gt;
    &lt;dependency&gt;
      &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
      &lt;artifactId&gt;spring-boot-starter-thymeleaf&lt;/artifactId&gt;
      &lt;version&gt;2.1.3.RELEASE&lt;/version&gt;
    &lt;/dependency&gt;
</pre>

>**NOTE**: We include a specific version number for Thymeleaf as currently Snowdrop does not manage a version for this POM

There are other dependencies brought in by this Spring Starter POM. We will revisit these later in the scenario.

Note that the Thymeleaf dependency is our View technology which will be explained in the next section. For now just note that the `spring-boot-starter-thymeleaf` Starter POM is similar to the `spring-boot-starter-web` POM in that it brings in all the necessary dependencies for working with Thymeleaf in Spring Boot.

You may notice that there is no `<version>` tag here. That's because the version numbers are managed and automatically derived by the BOM mentioned in other modules. 

**2. Test and Verify the application locally**


Run the application by executing the following command:

``mvn spring-boot:run``{{execute}}

To begin with, click on the **Local Web Browser** tab in the console frame of this browser window, which will open another tab or window of your browser pointing to port 8080 on your client or use [this](https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/) link.

**At the moment this link should return a HTTP 404**. But more importantly it returns what's called a *Spring White-label* page. In the absence of custom error pages Spring will return a White-label page with some error information. In some cases this can be a stack trace or an explicit error message. Because of this it's typically recommended to provide your own error pages. We will do this in the next step.

Before moving on, click in the terminal window and then press <kbd>CTRL</kbd>+<kbd>C</kbd> to stop the running application!

## Congratulations

Now you've seen how to get started with Spring Boot development on Red Hat OpenShift Application Runtimes. In the next step you will create the Model and Controller portions of the web application.
