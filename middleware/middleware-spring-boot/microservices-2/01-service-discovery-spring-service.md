# Service Discovery and Load Balancing with Spring

Now that we've seen what OpenShift comes with out of the box, let's take a look at other options available to us within the Spring ecosystem.

**1. Spring Libraries - Eureka and Ribbon**

We're going to be looking at how Spring handles Service Discovery with a popular Netflix library known as `Eureka`. Eureka is a REST-based service that's used for Service Discovery within the Spring environment. We're going to be using it as our Service Reigster and taking a look at the Eureka Discovery Client, which provides a helpful view of all registered services. You can view the library and check out the `README.md` [here](https://github.com/Netflix/eureka).
We'll be using the simple tutorial project found [here](https://github.com/spring-guides/gs-service-registration-and-discovery) to go over these concepts.

**2. Deploy Eureka Service**

When integrating the Eureka library with an existing spring application there are three main changes that have to be made.

**2.1 Add Eureka Server Dependency**

First we must include the dependency in the existing service pom file. ``eureka-service/pom.xml``{{open}}
This can be done by adding this snippet to the pom, although we've already added it to ours:

```xml
<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
		</dependency>
```

**2.2 Add Eureka Annotation**

The second important step is that we must add the `@EnableEurekaServer` annotation to our main application file, right where we start our Spring application. We can see that in the following file: ``eureka-service/src/main/java/hello/EurekaServiceApplication.java``{{open}}

```java
@EnableEurekaServer
@SpringBootApplication
public class EurekaServiceApplication {
    
    public static void main(String[] args) {
        SpringApplication.run(EurekaServiceApplication.class, args);
    }
}
```

**2.3 Add Eureka properties and Deploy**

The last step is to add some default properties into our `application.properties` file. Again we've already added ours, as seen here: ``eureka-service/src/main/resources/application.properties``{{open}}

```yaml
server.port=8761

eureka.client.register-with-eureka=false
eureka.client.fetch-registry=false

logging.level.com.netflix.eureka=OFF
logging.level.com.netflix.discovery=OFF
```
Since our application already has Eureka integrated, navigate to our service project location and build the project so that we're able to access it locally:

``mvn -f eureka-service spring-boot:run``{{execute}}

After that's finished building successfully, click the link [here](https://[[HOST_SUBDOMAIN]]-8761-[[KATACODA_HOST]].environments.katacoda.com/) to look at our web view for our Eureka Discovery Client. Note that it's exposed on the port that we set in our `application.properties` file.

![Eureka client](/openshift/assets/middleware/rhoar-microservices/eureka-client.png)

If we take a look under the `Instances Currently Registerd with Eureka` section it should be empty, but we'll be changing that shortly.

![No Instances](/openshift/assets/middleware/rhoar-microservices/eureka-no-instances.png)

## Congratulations

We've now set up our Eureka Service Register. In our next section we're going to be registering a service and viewing it's status on our web view.
