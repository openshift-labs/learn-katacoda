# Making modifications to the Configuration Map

**1. The ConfigMap**

Configs maps are a useful tool for decoupling configuration settings from the code. ConfigMaps can be used to inject configuration data into a container in much the same way that secrets do, though ConfigMaps should not store confidential information. ConfigMap objects hold key-pair values representing all of your configuration data. 

Notice the following dependency that was added to our `greeting-service/pom.xml`{{open}}. This allows us to integrate with OpenShift's ConfigMaps.

```    <dependency>
       <groupId>org.springframework.cloud</groupId>
       <artifactId>spring-cloud-starter-kubernetes-config</artifactId>
     </dependency>
```

**2. Modify the ConfigMap**

Let's modify the greeting that our service is returning to the user. Since we set up the greeting in a properties file, we will not need to make any code change to change the functionality. This means that we won't need to have any downtime for this change, we're able to modify the response through our newly created ConfigMap from the previous step. We can edit our config map in the OpenShift Console. Click the **OpenShift Console** tab, select `Resources > Config Maps`. Then Select our ConfigMap `app-config`

![Greeting Service](/openshift/assets/middleware/rhoar-microservices/configmap.png)

Now Select `Edit YAML` from the actions menu in the upper right corner of the page. 

![Greeting Service](/openshift/assets/middleware/rhoar-microservices/edityaml.png)

Change the `greeting.message` property to: `greeting.message=Bonjour, you picked %s as your favorite fruit!`

![Greeting Service](/openshift/assets/middleware/rhoar-microservices/editconfigmap.png)

Hit `Save` and that's all there is to it!

**3. Test changes**

Now that we've modified the ConfigMap and deployed our changes, let's test the greeting service and see if it's returning our new value.
Click [here](http://spring-boot-configmap-greeting-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/) and put in a test value and click the button. Now instead of seeing `Greetings ...`, we should be seeing:

`Bonjour, you picked %s as your favorite fruit!`

<!-- `Bonjour <name>...`! 

![Bonjour Message](/openshift/assets/middleware/rhoar-microservices/bonjour-message-minier.png) -->

This means that we were able to modify our application behavior through External Configuration of the `application.properties` file using a ConfigMap without having to even take down the application. That's pretty powerful!

## Congratulations

You have now learned how to handle Externalized Configuration with ConfigMaps through OpenShift. By creating a configmap, we're able to modify application properties on the fly and simply rollout the new changes to our application.