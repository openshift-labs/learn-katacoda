# Review the base structure of the application

For your convenience, this scenario has been created using the OpenShift Launcher found [here](https://launch.openshift.io/launch/filtered-wizard/all). This launcher will automatically generate a zip file of a project that's in a ready-to-deploy state. We've selected the `Circuit Breaker` project and will be using the Spring Boot runtime option.

**1. Understanding the Application**

The project is a simple Greeting application with two services: a Greeting service and a Name service. When you invoke the Greeting service, it makes a call to our secondary Name service. The name service returns the name of the user which our greeting service then greets.

However there is one problem: our greeting service is dependent on the name service. If the name service were to crash or go offline for some amount of time our greeting service would fail for the entire duration Name service is unavailable. This is an issue that can arise when we have multiple microservices communicating with one another and one solution is to use something called a `Circuit Breaker` pattern.

**2. The Circuit Breaker Pattern**

The Circuit Breaker pattern's purpose is to make sure that failing remote calls don't crash a system or cause unwarranted behavior. They do this by wrapping the desired function call into a circuit breaker object that monitors the attempted calls. When there is a failure, or the failures reach some boundary the user created, the circuit will trip (entering the `Open` state) and **no further calls will be made to our remote service**. Instead we can send back some default value or some response alerting the user what's happened.

Once the circuit is tripped no calls can be made to the failing service. However if we were to keep the circuit in this state we could never call the remote service again. In order to work around this issue, we can poll after some defined interval to see if the remote service is responding yet. If it responds, it means that the issue has been fixed and the circuit is again in the `Closed` state. If not, we can keep the circuit closed and wait for another interval to try again. Sometimes this in-between state of not knowing if the service is up is called a `Half-Open` state.

You can read more about the Circuit Breaker pattern and see some helpful diagrams [here](https://martinfowler.com/bliki/CircuitBreaker.html).

**3. Implementation of the Circuit Breaker pattern**

Our two-service application is currently implementing this pattern. If we take a look at our ``fruit-service/src/main/java/io/openshift/booster/service/FruitController.java``{{open}} file, we see that our simple controller is simply calling our `NameService`. Below we will add some code to the project. Click the `Copy to Editor` button to do this automatically


<pre class="file" data-filename="fruit-service/src/main/java/io/openshift/booster/service/FruitController.java" data-target="insert" data-marker="// TODO Call name service here">
    @RequestMapping("/api/greeting")
    public Fruit getFruit() throws Exception {
        String result = String.format("You've picked %s!", nameService.getName());
        handler.sendMessage(nameService.getState());
        return new Fruit(result);
    }
</pre>

If we take a look at the NameService class ``fruit-service/src/main/java/io/openshift/booster/service/NameService.java``{{open}} We see that we're using something called `Hystrix`. Hystrix is a Java library created by Netflix that is used to handle cascading failures and provide fallback options. We use it here to handle our circuit breaking pattern. If we take a look at the code, we see that we're setting a timeout for the given Hystrix command:



<pre class="file" data-filename="fruit-service/src/main/java/io/openshift/booster/service/NameService.java" data-target="insert" data-marker="// TODO Add Hystrix command here">
    @HystrixCommand(commandKey = "NameService", fallbackMethod = "getFallbackName", commandProperties = {
            @HystrixProperty(name = "execution.isolation.thread.timeoutInMilliseconds", value = "1000")
    })
</pre>

We're telling Hystrix to call a given fallback method (`getFallbackName`) if our execution takes longer than the given timeout allotment and return that value instead. This means that on a timeout, we will be returning the value `Fallback` instead of the given name. We can see that function below:


<pre class="file" data-filename="fruit-service/src/main/java/io/openshift/booster/service/NameService.java" data-target="insert" data-marker="// TODO Add fallback method here">
    private String getFallbackName() {
        return "banana from fallback";
    }
</pre>

So if our circuit is Closed, we expect to see a message similar to `You've picked apple!`. If we have an Open circuit we will see `You've picked banana from fallback!`.

## Congratulations

You have now successfully executed the first step in this scenario. We learned about the Circuit Breaker pattern and saw how we could implement the pattern in our application. In the next step we will log in to OpenShift so we can deploy our application. 

To learn more about Hystrix, view their Github wiki page [here](https://github.com/Netflix/Hystrix/wiki).