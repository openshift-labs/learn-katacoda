# Review the base structure of the application

For your convenience, this scenario has been created using the OpenShift Launcher found [here](https://launch.openshift.io/launch/filtered-wizard/all). This launcher will automatically generate a zip file of a project that's in a ready-to-deploy state. We've selected the `Externalized Configuration` project and will be using the Spring Boot runtime option.


**1. Understanding the Application**

The project is a simple Greeting application, where a user inputs a fruit and is greeted by our service. Opening up our ``greeting-service/src/main/java/io/openshift/booster/service/FruitController.java``{{open}} file we can see the logic used to respond to our user. The interesting part of this logic is right here, where we retrieve the message:

```java
String message = String.format(properties.getMessage(), name);
```

If we take a closer look at this `properties` object, we see that it's of type `MessageProperties`. When we look at that file ``greeting-service/src/main/java/io/openshift/booster/service/MessageProperties.java``{{open}} we see an annotation linking to a configuration file, `@ConfigurationProperties("greeting")`, which is pointing to our ``greeting-service/src/main/resources/application-local.properties``{{open}} file.

Our `application-local.properties` file contains only one property, `greeting.message`. This is the message that we return and display to the user. In order to get an understanding of the flow, let's run the application locally. First cd into the project directory and build the project:  
``mvn -f greeting-service spring-boot:run``{{execute}}  
  
``mvn spring-boot:run``{{execute}}

When the application finishes building click the **local web browser** or click [here](https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/). You should see the same message that is in the `application-local.properties` file.

Be sure to stop the application with `ctrl-c`.

## Congratulations

You have now successfully executed the first step in this scenario. in the next step we're going to be deploying the project and testing it our for ourselves, as well as modifying this greeting through External Configuration.