## Writing the first Camel K application
We are going to start fresh with a simple Camel K getting started application. Go to the text editor on the right, under the folder /root/camel-basic. Right click on the directory and choose New -> File and name it `Basic.java`.

Paste the following code into the application.

<pre class="file" data-filename="Basic.java" data-target="replace">
// camel-k: language=java

import org.apache.camel.builder.RouteBuilder;

public class Basic extends RouteBuilder {
  @Override
  public void configure() throws Exception {

      from("timer:java?period=1000&fixedRate=true")
      .setHeader("example")
      .constant("java")
      .setBody().simple("Hello World! Camel K route written in ${header.example}.")
      .to("log:ingo");

  }
}

</pre>

Notice you don't need to specify ANY dependency specification in the folder, Camel K will figure it out, and inject it during the build. So all you need is to JUST write your application. In this case, the Kamel binary will push it to the cluster and the operator will do all the tedious footworks for you.

``kamel run camel-basic/Basic.java --dev``{{execute}}

Wait for the integration to be running (you should see the logs streaming in the terminal window).
```
integration "basic" created
Progress: integration "basic" in phase Initialization
IntegrationPlatformAvailable for Integration basic: camel-k
Integration basic in phase Initialization
Progress: integration "basic" in phase Building Kit
No IntegrationKitAvailable for Integration basic: creating a new integration kit
Integration basic in phase Building Kit
Integration basic dependent resource kit-bqceoqg41jjjfrfg2okg (Integration Kit) changed phase to Build Submitted
Integration basic dependent resource kit-bqceoqg41jjjfrfg2okg (Build) changed phase to Scheduling
Integration basic dependent resource kit-bqceoqg41jjjfrfg2okg (Integration Kit) changed phase to Build Running
```

It's going to take 1-2 mins to start up your first application, since it needs to pull and build the image for the first time. But the next build will only take seconds.

Once it started. You can find the pod running this Basic application in the terminal.

```
[3] 2020-04-17 00:31:44.003 INFO  [Camel (camel-k) thread #1 - timer://java] ingo - Exchange[ExchangePattern: InOnly, BodyType: String, Body: Hello World! Camel K route written in java.]
[3] 2020-04-17 00:31:45.003 INFO  [Camel (camel-k) thread #1 - timer://java] ingo - Exchange[ExchangePattern: InOnly, BodyType: String, Body: Hello World! Camel K route written in java.]
[3] 2020-04-17 00:31:46.002 INFO  [Camel (camel-k) thread #1 - timer://java] ingo - Exchange[ExchangePattern: InOnly, BodyType: String, Body: Hello World! Camel K route written in java.]
[3] 2020-04-17 00:31:47.002 INFO  [Camel (camel-k) thread #1 - timer://java] ingo - Exchange[ExchangePattern: InOnly, BodyType: String, Body: Hello World! Camel K route written in java.]
[3] 2020-04-17 00:31:48.002 INFO  [Camel (camel-k) thread #1 - timer://java] ingo - Exchange[ExchangePattern: InOnly, BodyType: String, Body: Hello World! Camel K route written in java.]
[3] 2020-04-17 00:31:49.004 INFO  [Camel (camel-k) thread #1 - timer://java] ingo - Exchange[ExchangePattern: InOnly, BodyType: String, Body: Hello World! Camel K route written in java.]
[3] 2020-04-17 00:31:50.002 INFO  [Camel (camel-k) thread #1 - timer://java] ingo - Exchange[ExchangePattern: InOnly, BodyType: String, Body: Hello World! Camel K route written in java.]
[3] 2020-04-17 00:31:51.003 INFO  [Camel (camel-k) thread #1 - timer://java] ingo - Exchange[ExchangePattern: InOnly, BodyType: String, Body: Hello World! Camel K route written in java.]
```

Go to  [Console](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com/k8s/ns/camel-basic/pods). Login if you have not already do so. Click into the *basic-xxxxxxxxxx* pod, click on the log tab. The output in the console should be the same as in the terminal.

Go back to the editor and try changing the word `java` to  `Java` with Capital letter. And see what happens.   


```
[3] 2020-04-17 00:32:11.003 INFO  [Camel (camel-k) thread #1 - timer://java] ingo - Exchange[ExchangePattern: InOnly, BodyType: String, Body: Hello World! Camel K route written in Java.]
[3] 2020-04-17 00:32:12.003 INFO  [Camel (camel-k) thread #1 - timer://java] ingo - Exchange[ExchangePattern: InOnly, BodyType: String, Body: Hello World! Camel K route written in Java.]
[3] 2020-04-17 00:32:13.002 INFO  [Camel (camel-k) thread #1 - timer://java] ingo - Exchange[ExchangePattern: InOnly, BodyType: String, Body: Hello World! Camel K route written in Java.]
[3] 2020-04-17 00:32:14.002 INFO  [Camel (camel-k) thread #1 - timer://java] ingo - Exchange[ExchangePattern: InOnly, BodyType: String, Body: Hello World! Camel K route written in Java.]
[3] 2020-04-17 00:32:15.002 INFO  [Camel (camel-k) thread #1 - timer://java] ingo - Exchange[ExchangePattern: InOnly, BodyType: String, Body: Hello World! Camel K route written in Java.]
[3] 2020-04-17 00:32:16.004 INFO  [Camel (camel-k) thread #1 - timer://java] ingo - Exchange[ExchangePattern: InOnly, BodyType: String, Body: Hello World! Camel K route written in Java.]
[3] 2020-04-17 00:32:17.002 INFO  [Camel (camel-k) thread #1 - timer://java] ingo - Exchange[ExchangePattern: InOnly, BodyType: String, Body: Hello World! Camel K route written in Java.]
[3] 2020-04-17 00:32:18.003 INFO  [Camel (camel-k) thread #1 - timer://java] ingo - Exchange[ExchangePattern: InOnly, BodyType: String, Body: Hello World! Camel K route written in Java.]
```

Hit ctrl+c on the terminal window. This will also terminate the execution of the integration.
