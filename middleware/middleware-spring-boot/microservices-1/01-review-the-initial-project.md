# Import the code
Let's refresh the code we'll be using. Run the following command to clone the sample project:

`cd /root/projects && rm -rf rhoar-getting-started && git clone https://github.com/openshift-katacoda/rhoar-getting-started && cd rhoar-getting-started/spring/microservices-externalized-config`{{execute}}

# Review the base structure of the application
**1. Understanding the Application**

The project is a simple Greeting application, where a user inputs a fruit name and is greeted by our service. Opening up our ``src/main/java/com/example/service/FruitController.java``{{open}} file we can see the logic used to respond to our user. The interesting part of this logic is right here, where we retrieve the message:

```java
String message = String.format(properties.getMessage(), name);
```

If we take a closer look at this `properties` object, we see that it's of type `MessageProperties`. When we look at that file ``src/main/java/com/example/service/MessageProperties.java``{{open}} we see an annotation linking to a configuration prefix, `@ConfigurationProperties("greeting")`, which is pointing to our ``src/main/resources/application-local.properties``{{open}} file.

Our `application-local.properties` file contains only one property, `greeting.message`. This is the message that we return and display to the user. In order to get an understanding of the flow, let's run the application locally. On the terminal build the project:

``mvn spring-boot:run``{{execute}}  

When the application finishes building, click the **local web browser** or click [here](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com). You should see the same message that is in the `application-local.properties` file.

Be sure to stop the application with `ctrl-c`.

## Congratulations

You have now successfully executed the first step in this scenario. in the next step we're going to be deploying the project and testing it our for ourselves, as well as modifying this greeting through External Configuration.