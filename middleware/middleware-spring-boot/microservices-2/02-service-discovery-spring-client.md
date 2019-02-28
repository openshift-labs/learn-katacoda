# Service Discovery Registering

**1. Deploy Eureka Client**

Similar to the Eureka-Server, there are three main changes that have to be made to a base Spring application before it's fully integrated with the Eureka Client.

**1.1 Add Eureka Server Dependency**

Just like with the `Eureka-Server`, we need to modify the pom file to add a dependency of the `Eureka-Client`. If we pull up our pom file here ``eureka-client/pom.xml``{{open}} we can see this snippet below is already included:

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
</dependency>
```

**1.2 Add Eureka Client Annotation**

Similar to our `Eureka-Server` annotation, we need to add an annotation to our client's main application file. ``eureka-client/src/main/java/hello/EurekaClientApplication.java``{{open}}

For the client that we want to be discovered, we add the `@EnableDiscoveryClient` annotation:

```java
@EnableDiscoveryClient
@SpringBootApplication
public class EurekaClientApplication {

    public static void main(String[] args) {
        SpringApplication.run(EurekaClientApplication.class, args);
    }
}
```

**1.3 Add Eureka properties**

Since our client is just a service that's getting discovered, we don't need to configure ports and other settings. ``eureka-client/src/main/resources/bootstrap.properties``{{open}}
The only thing we'll include here is the application name. This is the application name that get's listed in our web view, so we'll see this value again shortly.

`spring.application.name=a-bootiful-client`


**2. Deploy the Application**

Now all that's left is to deploy this application and check that it's been properly registered. Let's create another terminal since our current one is running our server locally. 

Click the `+` sign next to our OpenShift console and select `Open New Terminal`.

![Open New Terminal](/openshift/assets/middleware/rhoar-microservices/open-new-terminal.png)

Run the following commands to navigate to our client project and build it locally

``cd projects/rhoar-getting-started/spring/service-discovery``{{execute}}

``mvn -f eureka-client spring-boot:run``{{execute}}

After the project has successfully built, check our Eureka Server web view again. Under the `Instances Currently Registerd with Eureka` we should now see our client application!

![Open New Terminal](/openshift/assets/middleware/rhoar-microservices/eureka-new-terminal.png)

**3. Test the Application**

Now that we have a client registered to the Eureka-Server instance, we can interrogate the Eureka-Server instance to find out some information about the client. Visit the link [here](https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/service-instances/a-bootiful-client). This link will call the `/service-instance/` endpoint on the Eureka-Client seen below. We will use as `a-bootiful-client`, the name we gave our client, as the ApplicationName parameter.

```
    @RequestMapping("/service-instances/{applicationName}")
    public List<ServiceInstance> serviceInstancesByApplicationName( @PathVariable String applicationName) {
        return this.discoveryClient.getInstances(applicationName);
    }
```

This call will return information from the Eureka-Service about the Eureka-Client instance we have registered. 

Stop both applications with <kbd>CTRL</kbd>+<kbd>C</kbd> before continuing.

## Congratulations

We've now gone over two important core concepts when dealing with a microservice architecture and took a look at how Spring solves Service Discovery using Netflix libraries and how OpenShift handles all of the heavy lifting for us in regards to Load Balancing and Service Discovery automatically!