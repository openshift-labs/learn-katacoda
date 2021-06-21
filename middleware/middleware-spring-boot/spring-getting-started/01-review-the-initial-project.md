# Import the code

Let's refresh the code we'll be using. Run the following command to clone the sample project:

`cd /root/projects && rm -rf rhoar-getting-started && git clone https://github.com/openshift-katacoda/rhoar-getting-started && cd rhoar-getting-started/spring/spring-rhoar-intro`{{execute}}

# Review the base structure of the application

For your convenience, this scenario has been created with a base project using the Java programming language and the Apache Maven build tool.

Initially, the project is almost empty and doesn't do anything. Start by reviewing the content by executing a ``tree``{{execute}} in your terminal.

The output should look something like this

```sh
.
|-- pom.xml
`-- src
    `-- main
        |-- jkube
        |   |-- credentials-secret.yml
        |   |-- deployment.yml
        |   |-- route.yml
        |`-- java
        |   `-- com
        |       `-- example
        |           |-- Application.java 
        |           |`-- service
        `-- resources
            |-- application-local.properties
            |-- application-openshift.properties
            `-- static
                |-- index.html
```


As you can see, there are some files that we have prepared for you in the project. Under src/main/resources/index.html we have, for example, prepared an HTML file for you. Except for the jkube directory and the index.html, this matches very well what you would get if you generate an empty project from the [Spring Initializr](https://start.spring.io) web page. For the moment you can ignore the content of the jkube folder (we will discuss this later).

One that differs slightly is the `pom.xml`. Please open the and examine it a bit closer (but do not change anything at this time)

``pom.xml``{{open}}

As you review the content, you will notice that there are a lot of **TODO** comments. **Do not remove them!** These comments are used as a marker and without them, you will not be able to finish this scenario.

Notice that we are not using the default BOM (Bill of material) that Spring Boot project typically use. Instead, we are using a BOM provided by Red Hat as part of the [Snowdrop](http://snowdrop.me/) project.

```xml
  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>me.snowdrop</groupId>
        <artifactId>spring-boot-bom</artifactId>
        <version>${spring-boot.bom.version}</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
    </dependencies>
  </dependencyManagement>
```

We use this bill of material to make sure that we are using the version of for example Apache Tomcat that Red Hat supports.

**1. Adding web (Apache Tomcat) to the application**

Since our applications (like most) will be a web application, we need to use a servlet container like Apache Tomcat or Undertow. Since Red Hat offers support for Apache Tomcat (e.g., security patches, bug fixes, etc.), we will use it.

>**NOTE:** Undertow is another an open source project that is maintained by Red Hat and therefore Red Hat plans to add support for Undertow shortly.


To add Apache Tomcat to our project all we have to do is to add the following lines in ``pom.xml``{{open}}

<pre class="file" data-filename="pom.xml" data-target="insert" data-marker="<!-- TODO: Add web (tomcat) dependency here -->">
    &lt;dependency&gt;
      &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
      &lt;artifactId&gt;spring-boot-starter-web&lt;/artifactId&gt;
    &lt;/dependency&gt;
</pre>

**2. Test the application locally**

As we develop the application, we might want to test and verify our change at different stages. We can do that locally, by using the `spring-boot` maven plugin.

Run the application by executing the below command:

``mvn spring-boot:run``{{execute}}

>**NOTE:** The Katacoda terminal window is like your local terminal. Everything that you run here you should be able to execute on your local computer as long as you have a `Java JDK 11` and `Maven`. In later steps, we will also use the `oc` command line tool.

**3. Verify the application**

To begin with, click on the **Local Web Browser** tab in the console frame of this browser window, which will open another tab or window of your browser pointing to port 8080 on your client.

![Local Web Browser Tab](/openshift/assets/middleware/rhoar-getting-started-spring/web-browser-tab.png)

or use [this](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/) link.

You should now see an HTML page that looks like this:

![Local Web Browser Tab](/openshift/assets/middleware/rhoar-getting-started-spring/web-page.png)

As you can probably guess by now the application we are building is a Fruit repository where we create, read, update and delete different kinds of fruits.


> **NOTE:** None of the button works at this stage since we haven't implemented services for them yet, but we will shortly do that.

**4. Stop the application**

Before moving on, click in the terminal window and then press <kbd>CTRL</kbd>+<kbd>C</kbd> to stop the running application!

## Congratulations

You have now successfully executed the first step in this scenario.

Now you've seen how to get started with Spring Boot development on Red Hat OpenShift Application Runtimes

In next step of this scenario, we will add the logic to be able to read a list of fruits from the database.
