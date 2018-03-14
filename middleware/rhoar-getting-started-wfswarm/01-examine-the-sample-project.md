The sample project shows the components of 
a WildFly Swarm project laid out in different subdirectories according to Maven best 
practices. 

**1. Run the following command to examine the Maven project structure.**

> Click on the `tree` command below to automatically copy it into the terminal and execute it

``tree``{{execute}}

This is a minimal Java EE project which implements a simple RESTful microservice which implements a greeting service (that simply returns a Hello greeting).
Click the links below to open each file and inspect its contents:

* `pom.xml`{{open}} - Maven project file describing how to build the project
* `src/main/java/com/example/ApplicationConfig.java`{{open}} - Declares the RESTful resource base path and a simple switch to toggle the application's ability to serve requests
* `src/main/java/com/example/Greeting.java`{{open}} - POJO containing a message to send as a greeting
* `src/main/java/com/example/GreetingResource.java`{{open}} -  Definition of the `/greeting` and `/stop` RESTful endpoints. 

Review the content a bit and notice that there are some comments in the code. Do not remove them! The comments are used as marker and without them you will not be able finish the scenario.

The `/greeting` API returns a simple message. The `/stop` API will simulate the application failing. In a real application
this could happen if the application was overloaded, or a bug in the code causes the application to hang or otherwise not be
able to service requests. For our sample app, we use a simple boolean flag to simulate failure and will toggle this on and off
later to simulate failure.

**2. Compile and run the application**

Before we add code to the project you should build and test that current application starts as it should. 

Since this is already a working application you can already without any code changes run the application locally directly from `maven` using `wildfly-swarm:run` as the goal

``mvn wildfly-swarm:run``{{execute HOST1}}  

Since this is the first time we run maven may have to pull down some dependencies (we have tried to prepopulate most for you), but subsequent runs should go really fast.

At this stage the application doesn't really do anything but after a while you will see:

```console
INFO  [org.wildfly.swarm] (main) WFSWARM99999: WildFly Swarm is Ready
```

**3. Test the application**

To begin, click on the **Local Web Browser** tab in the console frame of this browser window. This will open another tab or window of your browser pointing to port 8080 on your client.

![Local Web Browser Tab](../../assets/middleware/rhoar-getting-started-wfswarm/web-browser-tab.png)

> or use [this](https://[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com/) link.

You should now see a html page that looks like this

![App](../../assets/middleware/rhoar-getting-started-wfswarm/app.png)

**4. Stop the application**

Before moving on, click in the terminal window and then press CTRL-C to stop the running application!

You should see this:

```console
INFO  [org.jboss.as] (MSC service thread 1-3) WFLYSRV0050: WildFly Swarm 2017.10.0 (WildFly Core 2.2.1.Final) stopped in 51ms
```

This indicates the application is stopped.

## Congratulations

You have now successfully executed the first step in this scenario. 

Now you've seen how you with a few lines of code one can create a simple RESTful HTTP Server capable of serving static content using WildFly Swarm.

In next step of this scenario we will deploy our application to OpenShift Container Platform.

