# Import the code

Let's refresh the code we'll be using. Run the following command to clone the sample project:

`cd /root/projects && rm -rf rhoar-getting-started && git clone https://github.com/openshift-katacoda/rhoar-getting-started && cd rhoar-getting-started/spring/spring-rest-services`{{execute}}

# Get project set up

**1. Adding Spring MVC and Tomcat to the application**

Since our application will be a web application, we need to use a servlet container like Apache Tomcat or Undertow to handle incoming connections from clients. Since Red Hat offers support for Apache Tomcat (e.g., security patches, bug fixes, etc.), we will use it here. 

In addition we are going to utilize the Spring MVC project which contains many of the abstractions we will use to build our APIs. Observe the following code block in the ``pom.xml``{{open}}

`    <dependency>  
      <groupId>org.springframework.boot</groupId>  
      <artifactId>spring-boot-starter-web</artifactId>  
    </dependency>
`

You may notice that there is no `<version>` tag here. That's because the version numbers are managed and automatically derived by the BOM mentioned in the previous trainings. 

**2. Test the application locally**

Run the application by executing the following command:

``mvn spring-boot:run``{{execute}}

You should eventually see a log line like `Started Application in 4.497 seconds (JVM running for 9.785)`. Open the application by clicking on the **Local Web Browser** tab or clicking [here](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/). Then stop the application by pressing **<kbd>CTRL</kbd>+<kbd>C</kbd>**.

## Congratulations

You have now successfully executed the first step in this scenario. 
