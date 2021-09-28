# Making modifications to the Configuration Map

**1. The ConfigMap**

`ConfigMap`s are a useful tool for decoupling configuration settings from the code. `ConfigMap`s can be used to inject configuration data into a container in much the same way that secrets do, though `ConfigMap`s should not store confidential information. `ConfigMap` objects hold key-pair values representing all of your configuration data. 

Notice the following dependency that was added to our `pom.xml`{{open}}. This allows us to integrate with OpenShift's ConfigMaps.

```    
     <dependency>
       <groupId>org.springframework.cloud</groupId>
       <artifactId>spring-cloud-starter-kubernetes-config</artifactId>
     </dependency>
```

**2. Modify the ConfigMap**

Let's modify the greeting that our service is returning to the user. Since we set up the greeting in a properties file, we will not need to make any code change to change the functionality. This means that we won't need to have any downtime for this change, we're able to modify the response through our newly created `ConfigMap` from the previous step. We can edit our config map in the OpenShift Console. [Click here](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com/k8s/ns/dev/configmaps/spring-boot-configmap-greeting/yaml) to open our `ConfigMap` in a YAML editor.

   > **NOTE:** The username/password for the OpenShift console is `admin`.

Change the `greeting.message` property to: `greeting.message=Bonjour, you picked %s as your favorite fruit!`

![Greeting Service](/openshift/assets/middleware/rhoar-microservices/editconfigmap.png)

Hit `Save` (at the bottom of the editor) and that's all there is to it!

**3. Test changes**

Now that we've modified the `ConfigMap` and deployed our changes, let's test the greeting service and see if it's returning our new value.
Click [here](http://spring-boot-configmap-greeting-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/) and put in a test value and click the button. Now instead of seeing `Greetings ...`, we should be seeing:

`Bonjour, you picked %s as your favorite fruit!`

This means that we were able to modify our application behavior through External Configuration of the `application.properties` file using a ConfigMap without having to even take down the application. That's pretty powerful!

# Open the solution in an IDE in the Cloud!
Want to continue exploring this solution on your own in the cloud? You can use the free [Red Hat CodeReady Workspaces](https://developers.redhat.com/products/codeready-workspaces/overview) IDE running on the free [Red Hat Developer Sandbox](http://red.ht/dev-sandbox). [Click here](https://workspaces.openshift.com) to login or to register if you are a new user. This free service expires after 30 days, but you can always enable a new free 30-day subscription.

Once logged in, [click here](https://workspaces.openshift.com/f?url=https://raw.githubusercontent.com/openshift-katacoda/rhoar-getting-started/solution/spring/microservices-externalized-config/devfile.yaml) to open the solution for this project in the cloud IDE. While loading, if it asks you to update or install any plugins, you can say no.

# Fork the source code to your own GitHub!
Want to experiment more with the solution code you just worked with? If so, you can fork the repository containing the solution to your own GitHub repository by clicking on the following command to execute it:

`/root/projects/forkrepo.sh`{{execute T1}}
- Make sure to follow the prompts. An error saying `Failed opening a web browser at https://github.com/login/device exit status 127` is expected.
- [Click here](https://github.com/login/device) to open a new browser tab to GitHub and paste in the code you were presented with and you copied.
- Once done with the GitHub authorization in the browser, close the browser tab and return to the console and press `Enter` to complete the authentication process.
- If asked to clone the fork, press `n` and then `Enter`.
- If asked to confirm logout, press `y` and the `Enter`.

   > **NOTE:** This process uses the [GitHub CLI](https://cli.github.com) to authenticate with GitHub. The learn.openshift.com site is not requesting nor will have access to your GitHub credentials.

After completing these steps the `rhoar-getting-started` repo will be forked in your own GitHub account. On the `solution` branch in the repo, the `microservices-externalized-config` project inside the `spring` folder contains the completed solution for this scenario.

## Congratulations

You have now learned how to handle Externalized Configuration with ConfigMaps through OpenShift. By creating a `ConfigMap`, we're able to modify application properties on the fly and simply rollout the new changes to our application.