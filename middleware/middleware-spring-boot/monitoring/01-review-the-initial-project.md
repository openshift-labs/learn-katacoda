# Import the code

Let's refresh the code we'll be using. Run the following command to clone the sample project:

`cd /root/projects && rm -rf rhoar-getting-started && git clone https://github.com/openshift-katacoda/rhoar-getting-started && cd rhoar-getting-started/spring/spring-monitoring`{{execute}}

# Review the base structure of the application

For your convenience, this scenario has been created with a base project using the Java programming language and the Apache Maven build tool.

As you review the content, you will notice that there are a couple **TODO** comments. **Do not remove them!** These comments are used as markers for later exercises in this scenario. Open ``src/main/java/com/example/service/FruitController.java``{{open}}. This is our rest controller. We will be adding our logging commands here later in this module.

**1. Test the application locally**

As we develop the application we want to be able to test and verify our change at different stages. One way we can do that locally is by using the `spring-boot` maven plugin.

Run the application by executing the following command:

``mvn spring-boot:run``{{execute}}

Once that's completed, click on the **Local Web Browser** tab and navigate to the `/fruits` endpoint or use [this](https://[[CLIENT_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/fruits) link.

You should now see an HTML page with a `Success` welcome message that looks like this:

![Success](/openshift/assets/middleware/rhoar-monitoring/landingPage.png)

If you see this then you've successfully set up the application! If not check the logs in the terminal. Spring Boot adds a couple helper layers to catch common errors and print helpful messages to the console so check for those first.

**2. Stop the application**

Before moving on, click in the terminal window and then press <kbd>CTRL</kbd>+<kbd>C</kbd> to stop the running application!

## Congratulations

You have now successfully executed the first step in this scenario. In the next step we will login to OpenShift and create a new project.
