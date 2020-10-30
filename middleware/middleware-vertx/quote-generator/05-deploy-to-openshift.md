## Deploy to OpenShift

Now that you've logged into OpenShift, let's deploy our new micro-trader Vert.x microservice:

**1. Create a ConfigMap**

A config map is a Kubernetes entity storing the configuration of an application. The application configuration is in src/kubernetes/config.json. We are going to create a config map from this file. In a terminal, execute:

`oc create configmap app-config --from-file=src/kubernetes/config.json`{{execute}}

To check that the config map has been created correctly, execute:

`oc get configmap -o yaml`{{execute}}

It should display the Kubernetes entity and in the data entry our json content.

Now that the config map is created, let’s read it from our application. There are several ways to consume a config map:

* ENV variables
* Config mounted as a file
* Vert.x Config

We are going to use the second approach and mount the configuration as a file in the application container. Indeed, our application has been configured to read its configuration from a src/kubernetes/config.json file:

```java
private ConfigRetrieverOptions getConfigurationOptions() {
    JsonObject path = new JsonObject().put("path", "src/kubernetes/config.json");
    return new ConfigRetrieverOptions().addStore(new ConfigStoreOptions().setType("file").setConfig(path));
}
```

For that, we have defined additional config in ``quote-generator/src/main/fabric8/deployment.yml``{{open}} that contains the right configuration to:
1. define a volume with the config map content
2. mount this volume in the right directory

You can also see that this file contains the JAVA options we pass to the process.

**2. Start the quote generator**

Red Hat OpenShift Application Runtimes includes a powerful maven plugin that can take an
existing Eclipse Vert.x application and generate the necessary Kubernetes configuration.

Build and deploy the project using the following command, which will use the maven plugin to deploy:

`mvn fabric8:deploy`{{execute}}

The build and deploy may take a minute or two. Wait for it to complete. You should see a **BUILD SUCCESS** at the
end of the build output.

After the maven build finishes it will take less than a minute for the application to become available.
To verify that everything is started, run the following command and wait for it complete successfully:

`oc rollout status -w dc/quote-generator`{{execute}}

**3. Access the application running on OpenShift**

Click on the
[route URL](http://quote-generator-vertx-kubernetes-workshop.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com)
to access the sample UI.

> You can also access the application through the link for the quote-generator route on the OpenShift Web Console Overview page.

You should now see an HTML page that looks like this:

```json

{
  "MacroHard" : {
    "volume" : 100000,
    "shares" : 51351,
    "symbol" : "MCH",
    "name" : "MacroHard",
    "ask" : 655.0,
    "bid" : 666.0,
    "open" : 600.0
  },
  "Black Coat" : {
    "volume" : 90000,
    "shares" : 45889,
    "symbol" : "BCT",
    "name" : "Black Coat",
    "ask" : 654.0,
    "bid" : 641.0,
    "open" : 300.0
  },
  "Divinator" : {
    "volume" : 500000,
    "shares" : 251415,
    "symbol" : "DVN",
    "name" : "Divinator",
    "ask" : 877.0,
    "bid" : 868.0,
    "open" : 800.0
  }
}
```

**4. Build and Deploy the micro-trader-dashboard**

`cd /root/code/micro-trader-dashboard`{{execute}}

`mvn fabric8:deploy`{{execute}}

In the OpenShift web console, wait until the pod is ready and click on the associated route. Append "/admin" at the end of the URL and you should see the dashboard. If you go into the trader tab, the graph should display the evolution of the market.

Alternatively, you can click on the
[route URL](http://micro-trader-dashboard-vertx-kubernetes-workshop.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/admin)
to access the sample UI.

**5. You are not a financial expert ?**
So maybe you are not used to the financial world and words…​ Neither am I, and this is a overly simplified version. Let’s define the important fields:

* `name` : the company name

* `symbol` : short name

* `shares` : the number of stock that can be bought

* `open` : the stock price when the session opened

* `ask` : the price of the stock when you buy them (seller price)

* `bid` : the price of the stock when you sell them (buyer price)

You can check Wikipedia for more details.

## Congratulations!

You have deployed the quote-generator as a microservice. In the next component, we are going to implement an event bus service (the portfolio microservice). 
