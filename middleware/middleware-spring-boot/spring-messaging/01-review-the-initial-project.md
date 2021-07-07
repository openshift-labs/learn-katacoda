# Import the code

Let's refresh the code we'll be using. Run the following command to clone the sample project:

`cd /root/projects && rm -rf rhoar-getting-started && git clone https://github.com/openshift-katacoda/rhoar-getting-started && cd rhoar-getting-started/spring/spring-messaging`{{execute}}

# Review the base structure of the application

For your convenience, this scenario has been created with a base project using the Java programming language and the Apache Maven build tool.

As you review the content, you will notice that there are a lot of **TODO** comments. **Do not remove them!** These comments are used as markers for later exercises in this scenario. 

**1. Add JMS Dependencies**

To add Spring JMS to our project all we have to do is to add the following line in ``pom.xml``{{open}}

<pre class="file" data-filename="pom.xml" data-target="insert" data-marker="<!-- TODO: Add JMS dependency here -->">
    &lt;dependency&gt;
      &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
      &lt;artifactId&gt;spring-boot-starter-artemis&lt;/artifactId&gt;
    &lt;/dependency&gt;
    &lt;dependency&gt;
        &lt;groupId&gt;com.fasterxml.jackson.core&lt;/groupId&gt;
        &lt;artifactId&gt;jackson-databind&lt;/artifactId&gt;
    &lt;/dependency&gt;
</pre>

Along with the JMS dependencies this starter also brings in the ActiveMQ Broker. The Broker manages connections to the Queue and acts as the mediator between the application and ActiveMQ. The `jackson-databind` dependency is for marshalling and unmarshalling the messages we will send. We will cover this later.

Right now the application will not compile because we are missing our Message object in the provided code. In our next step we'll fill in those required classes.

## Congratulations

You have now successfully executed the first step in this scenario. In the next step we will setup the code necessary to send and receive JMS messages.
