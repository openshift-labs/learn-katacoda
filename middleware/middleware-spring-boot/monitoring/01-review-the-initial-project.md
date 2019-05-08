# Review the base structure of the application

>**NOTE**: This project has been automatically deployed to OpenShift. The commands being run in your terminal are the deploy commands. Please do not stop these commands. It may take a few minutes before the deploy is complete.

For your convenience, this scenario has been created with a base project using the Java programming language and the Apache Maven build tool.

As you review the content, you will notice that there are a couple **TODO** comments. **Do not remove them!** These comments are used as markers for later exercises in this scenario. Open ``src/main/java/com/example/service/FruitController.java``{{open}}. This is our rest controller. We will be adding our logging commands here later in this module.

**1. Test the application locally**

As we develop the application we want to be able to test and verify our change at different stages. One way we can do that locally is by using the `spring-boot` maven plugin.

Run the application by executing the following command:

``mvn spring-boot:run``{{execute}}

Once that's completed, click on the **Local Web Browser** tab in the console frame of this browser window which will open another tab or window of your browser pointing to port 8080 on your client. Or use [this](https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/fruits) link.

You should now see an HTML page with a `Success` welcome message that looks like this:

![Success](/openshift/assets/middleware/rhoar-monitoring/success.png)

If you see this then you've successfully set up the application! If not check the logs in the terminal. Spring Boot adds a couple helper layers to catch common errors and print helpful messages to the console so check for those first.

**2. Stop the application**

Before moving on, click in the terminal window and then press <kbd>CTRL</kbd>+<kbd>C</kbd> to stop the running application!

## Congratulations

You have now successfully executed the first step in this scenario. In the next step we will login to OpenShift and create a new project.
